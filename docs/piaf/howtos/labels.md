# Haystack Label's Inquiry


## What?

Haystack uses an object called `Label` which stores the questions contained in the knowledge base (a SQuAD-like dataset). In our piaf use case, we have a single knowledge base file that contains the documents we want to index in ES **and** the questions we use to evaluate the system.

## Why?
It is very important to know how these `Labels` are treated during validation as it directly affects the score of our test metrics.

## How?

I follow the traces of the system during data loading, retrieval and reading, and evaluation of both retrieval and reading using a small dataset to move quickly.

## Data

I will use the test dataset [`tiny.json`](https://github.com/etalab-ia/piaf-ml/blob/96b13d8945a87cc1e3e5623533626067bd1072f7/test/samples/squad/tiny.json) which is a small sample of what our current (03/03/21) knowledge base looks like.

This dataset contains 3 contexts (or documents) and 17 questions:

* 15 questions with `is_impossible: false`
* 2 questions with empty answers with `"answers": []` 
    * 1 question with an empty question `"question": ""`
    * 1 question with an out of scope question
* 2 questions with 2 and 3 answers respectively.

## Data Loading

### What is stored in documents?
Easy, we have a document per context (or paragraph) (i.e., 3 documents in the `documents` index).

### What is stored in these labels?

A label per answer. That is, not 17 labels but 20 because there are 17 questions but 1 question with two answers and 1 questions with 3 answers. So, it is 15 questions with one answer (15 labels) plus 1 question with two answers (2 labels), plus one question with 3 answers (3 labels) = 15 + 2 + 3 = 20 labels.

### How are labels loaded into ES?

Documents are read in: 

```python
document_store.add_eval_data(filename=Path("./test/samples/squad/tiny.json").as_posix(), doc_index=doc_index,
                                label_index=label_index)
```

All labels are passed onto the ES "label" index. This happens specifically in the function `write_labels` of the `ElasticDocumentStore` class in `elasticsearch.py`:

```python
    def write_labels(
        self, labels: Union[List[Label], List[dict]], index: Optional[str] = None, batch_size: int = 10_000
    ):
```

* There is no filter regarding whether the question is empty.
* There is no filter regarding whether the answer is empty.
* There is no filter regarding whether the question is impossible (`is_impossible=True` or `has_answer=True`)


## Retrieval
### How are labels treated in retrieval time?

At retrieval time, `labels` are read in `eval_retriever()` function at  `utils_eval.py` (our code). They are aggregated, so we have 17 labels this time. One for each question. If a question has several answers, they are included in its corresponding label. Like so:

```python
[{'question': 'Quelle est la proportion de femmes dans le Parlement ougandais en 2016 ?', 'multiple_answers': ['un tiers', 'plus d’un tiers'], 'is_correct_answer': True, 'is_correct_document': True, 'origin': 'gold_label', 'multiple_document_ids': ['fc0afb0b-0d9c-4a3a-8b1a-b54b48b3440a', 'fc0afb0b-0d9c-4a3a-8b1a-b54b48b3440a'], 'multiple_offset_start_in_docs': [523, 516], 'no_answer': False, 'model_id': None}]
```

Also, the answers to the questions are unique. So, even if a question has three answers, if they are all the same, this label will have a single answer (hence the aggregation name).


We iterate per label (per question) and **skip those questions that are empty** (line 52 of `utils_eval.py`): 

```python
    for label in labels:
        if not label.question:
```

So, instead of dealing with 17 questions, **we deal with 16** questions.


### Evaluation

**What happens to those questions without an answer?**
ES tries to get an answer. ES is able to return no answers if it so decides to (as with the "universe" last question of our test dataset). Note that *SBERT* (and maybe *DPR* ) returns an answer even if the question is out of domain.

Keep in mind that a question that does not have an answer  is still used to compute the retrieval score: it still belongs to a parent document. So if the retrieval finds, or not, the parent document, we take it into account and add it to the final score.



## Reading

### How are labels treated in reader time?

Again, we deal only with the questions that are **not** empty, so 16 questions.

We run the pipeline (retrieval + reader) here: 

```python
predicted_answers_list = [pipeline.run(query=q, top_k_retriever=k_retriever) for q in questions]
```

and get a list of predicted answers `predicted_answers_list`. This collection contains objects like this one:
```python
predicted_answer_list[0] = {
    "query": "some query",
    "answers": {'answer': 'l’Ouganda',
            'context': 'international (FMI) et la Banque mondiale, et fait progressivement de l’Ouganda le « bon élève du FMI » en suivant les recommandations de l’instituti',
            'offset_start': 456,
            'offset_end': 465,
            'probability': 0.9944853186607361,
            'score': None,
            'document_id': '3379c613-dfc6-4223-b93e-9ec5f5b4359e',
            'meta': {'categorie': 'Société', 'name': 'Yoweri Museveni'}},
            ...
}
```
In other words, it is a `list` of `dicts`, each dict containing a query as key and a list of `dict` answers as values.  There are 10 answers per query (we then filter them with `k_display`).

When a question has no answer, the system predicts no answer (because the retriever retrieved nada): 

```python
{'answers': [], 'query': "Pourquoi l'univers existe ?"}
```

### Evaluation

We do not take into account questions marked as `is_impossible` in the main scores (`_has_answer`), but we do take them into account for the `_no_answer` scores. As our model cannot answer `_no_answer` it does not make sense to use these scores for now.

**What happens to those questions that have empty answers and are not marked as `is_impossible`?**

As they do not have an answer, their score will be 0, which will be added to the global score, which would affect the final result as we get the average (and we just added a zero for no good reason). Thus, **it is important to make sure that all non-answered questions have `is_impossible=True`**.



