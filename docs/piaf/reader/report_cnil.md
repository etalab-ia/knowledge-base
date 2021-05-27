Performance on CNIL Dataset
===========

# Introduction
The objective of this report is to evaluate the performances of the PIAF-stack on the dataset provided by the CNIL.

These performances will be compared to the performances obtained with the current solution implemented on the CNIL
website [besoin d'aide](https://www.cnil.fr/fr/cnil-direct)


# Test method
Each question of the dataset will be queried to the knowledge base. This will be done with two types of pipelines:

- One containing a retriever and a reader
- One containing a retriever.

For the retriever/reader pipeline, the result of the pipeline will be evaluated by comparing the answer obtained with
the gold answer. If the answer obtained contains or is contained by the gold answer then the answer will be considered
valid.

For the retriever pipeline, the ID of the retrieved document will be compared to the true document.

The parameters for configuring the pipeline retriever + reader are described below. Two methods will be compared in this
protocol.

One method is using a gridsearch to find the best parameters for the pipeline. Below are the parameters evaluated.

Parameters for gridsearch:
```python
parameters = {
    "k_retriever": [1, 3, 5, 10, 20, 50],
    "k_title_retriever": [1, 3, 5, 10, 20, 50],  # must be present, but only used when retriever_type == title_bm25
    "k_reader_per_candidate": [1, 3, 5, 10, 20, 50],
    "k_reader_total": [3, 5, 10],
    "reader_model_version": ["053b085d851196110d7a83d8e0f077d0a18470be"],
    "retriever_model_version": ["1a01b38498875d45f69b2a6721bf6fe87425da39"],
    "retriever_type": ["title_bm25"],  # Can be bm25, sbert, dpr, title or title_bm25
    "squad_dataset": ["./clients/cnil/knowledge_base/besoindaide_PIAF_V5.json"],
    "filter_level": [None],
    "preprocessing": [False],
    "boosting": [1, 10],  # default to 1
    "split_by": ["word"],  # Can be "word", "sentence", or "passage"
    "split_length": [1000000],
    "experiment_name": ["cnil"]
}
```

The second method is using the library scikit-optimize which is using the Bayesian Optimisation to find the best set of
parameters for the evaluation.

Parameters for scikit optimize:
```python
parameters = {
    "k_retriever": [1, 50],
    "k_title_retriever": [1, 50],  # must be present, but only used when retriever_type == title_bm25
    "k_reader_per_candidate": [1, 20],
    "k_reader_total": [5],
    "reader_model_version": ["053b085d851196110d7a83d8e0f077d0a18470be"],
    "retriever_model_version": ["1a01b38498875d45f69b2a6721bf6fe87425da39"],
    "retriever_type": ["title_bm25"],  # Can be bm25, sbert, dpr, title or title_bm25
    "squad_dataset": ["./clients/cnil/knowledge_base/besoindaide_PIAF_V5.json"],
    "filter_level": [None],
    "preprocessing": [False],
    "boosting": [1, 10],  # default to 1
    "split_by": ["word"],  # Can be "word", "sentence", or "passage"
    "split_length": [1000000],
    "experiment_name": ["cnil_optimize"]
}
```

The parameters for the pipeline retriever only are the following. The retriever used is a `TitleEmbeddingRetriever`

```python
parameters = {
    "k_retriever": [5],
    "squad_dataset": ["./clients/cnil/knowledge_base/besoindaide_PIAF_V5.json"],
    # data/evaluation-datasets/fquad_valid_with_impossible_fraction.json data/evaluation-datasets/testing_squad_format.json
    "filter_level": [None],
    "preprocessing": [True],
}
```

Note that for this test the final results that would be displayed to a user are the two 5 best answers/documents

# Dataset
The dataset used for this evaluation is the dataset `besoindaide_PIAF_V5.json`. This datasets contains the knowledge
base of besoin d'aide. This knowledge base contains 523 contexts in which an answer can be found. The documents are
organized with a title and a context. In this case, the title is always a question. Also, the first question annotated
is always the title of the document. Additionally, the CNIL annotated the dataset with 168 additional questions. This
results in 691 questions that can be queried to the knowledge base.
However, for a reason that is unknown only 683 questions were tested. This is because the following questions were duplicated:
```python
["Le droit à l'image s'applique-t-il sur internet ?",
 'Un site peut-il réutiliser les informations du Registre du commerce et des sociétés ?',
 "Numéro de sécurité sociale (NIR) : dans quels cas les communes et les départements peuvent-ils l'utiliser ?",
 'Numéro de sécurité sociale (NIR) des enfants en école primaire : une mairie peut-elle le demander ?',
 'Les MDPH peuvent-elles utiliser le numéro de sécurité sociale des personnes qui déposent un dossier ?',
 "Télémédecine : l'échange de données de santé est-il autorisé ?",
 'DMP (dossier médical personnel) : qui peut le consulter ?',
 'La CNIL peut-elle contrôler en ligne les sites web ?']
```

# Results
## Retriever + reader pipeline
### Scikit optimize method
```python
for k_reader_total = 5
reader_top_k_accuracy_has_answer = 0.703 
reader_top_1_accuracy_has_answer = 0.138
parameters : 
k_retriever = k_title_retriever = 1
boosting = 1
k_reader_per_candidate = 12 (not sensitive : basically can be between 12 and 21) 
```

### Grid search
```python
for k_reader_total = 5 (or 3)
reader_top_k_accuracy_has_answer = 0.701
reader_top_1_accuracy_has_answer = 0.138
parameters : 
k_retriever = k_title_retriever = 1
boosting = 1
k_reader_per_candidate = 20 
```
Note that there is a small difference between the two results (1 more good answer for the scikit optimize)

### Optimization duration
It is worthwhile to say that the best configuration is found with the scikit_optimize after 100 runs and approx 20 hours
and a half. The gridsearch took 585 runs and 6 days. However, three different k_reader_total were investigated although
we were only interested in one. Therefore, we should divide the time for running the experiment by three in order to
compare it with the scikit optimize.

Therefore, we can say that scikit optimize allowed to divide the time necessary for testing by approx. a factor two in
this case.

## Retriever only
The performances with the retriever only are :
```python
for k = 5 reader_topk_accuracy_has_answer : 0.877
for k = 3 reader_topk_accuracy_has_answer : 0.861
reader_top1_accuracy_has_answer : 0.826
```

