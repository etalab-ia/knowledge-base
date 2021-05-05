# Evaluation Metrics
## Retriever/Reader Evaluation

Evaluating a model's performance is an important building block in development, and assessing its performance on diffrent datasets reauires diffrent sets of metrics. The following Article presents the metrics used to evaluate the reqder and retriever in PIAF. 

## Retriever/Reader Evaluation metrics

- Retriever 
    - Recall
    - Mean Average Precision
    - Mean Reciprocal Rank
- Reader
    - reader_top1_accuracy
    - reader_top1_accuracy_has_answer
    - reader_topk_accuracy
    - reader_topk_accuracy_has_answer
    - reader_top1_em
    - reader_top1_em_has_answer
    - reader_topk_em
    - reader_topk_em_has_answer
    - reader_top1_f1
    - reader_top1_f1_has_answer
    - reader_top1_fk
    - reader_top1_fk_has_answer

### Retriever metrics
#### Recall

Recall is the fraction of correct retreivals from the queries in a single run

$$Recall = \frac{Correct\,Retrieval\,count}{Query\,Count}$$

where **Correct Retrieval count** is the number of times the retriever was able to find at least one relevant document for a query in a singe run
And **Query Count** is the number of queries(questions) in a single run

#### Mean Average Precision

MAP(Mean Average Precision) is the mean of average precisions of queries, it is used in case of interest in finding many relevant documents for each query.

Let's introduce precision@k and average precision first :
- Precision@k is the percentage of relevant documents in the top K elements
- Average precision is the average of p@k at k when new relevant document is retrieved 
- Mean Average precision is the mean of average precision of sevral queries

> Example : Let's consider a retreiver with k=5, it manages to extract 2 relevant documents at ranks 2 and 4 
so, precision@2 = $$\frac{1}{2}$$  and precision@4 = $$\frac{2}{4}$$ 
Average precision is equal to $$\frac{1}{2} \times (\frac{1}{2} +  \frac{2}{4})$$
Finally we calculate the mean of avreage precision for all the queries.
 
#### Mean Reciprocal Rank

MRR (Mean Reciprocal Rank)  is the average of the reciprocal ranks of the first retrieved relevant document for a sample of queries Q, it is used to evaluate processes that produces a list of ordered responses.

$$MRR = \frac{1}{Q} \sum_{1}^{Q}\frac{1}{Rank_1}$$

> Example : 3 queries with the first retrieved document at positions 1,2 and 4, the reciprocal ranks for each query are 1, $$\frac{1}{2}$$ and $$\frac{1}{4}$$ respectively. So,  MRR= $$\frac{(1+\frac{1}{2} + \frac{1}{4})}{3}$$ = 0.58

### Reader metrics
Before diving into reader metrics let's clarify Nomenclature of Metrics 
top1 : means that this metrics considers only the first result returned by the reader
topk : means that this metrics considers the first k results returned by the reader
has_answer : means that this metrics only takes into conseditarion the questions that are not impossible to answer.

#### reader_accuracy
Accuracy is the measure of correct readings over correct retrievals. where correct readings signifies the number of times where the reqder was able to extract a correct answer if the query has answer or or None if the query is impossible to answer.

$$Accuracy = \frac{correct\,readings}{correct\,retrievals}$$

- reader_top1_accuracy : checks for correct readings only in the first answer
- reader_top1_accuracy_has_answer : checks for correct readings only in the first answer only for queries not impossible to answer.
- reader_topk_accuracy : checks for correct readings in the first k answers
- reader_topk_accuracy_has_answer : checks for correct readings in the first k answers only for queries not impossible to answer.

#### reader_em
Exact match is a simple metric that checks if the predicted answers matchs exactly the true answer. so for every query, reader_em is the fraction of answers that matches exactly the true answer over the correct retrieval.

$$reader\_em = \frac{exact\,matches\,count}{correct\,retrievals}$$

- reader_top1_em : compares only the first predicted answer with the true label
- reader_top1_em_has_answer : compares only the first predicted answer with the true label for queries not impossible to answer.
- reader_topk_em : compares the first k predicted answer with the true label if any of these answers matches this answer the count is augmented
- reader_topk_em_has_answer : compares the first k predicted answer with the true label for queries not impossible to answer.

#### reader_f1
Before Introducing f1 in the context of QA let's first remember, what is F1

F-measure is a measure of a test's accuracy. It is calculated from the precision and recall of the test, where the precision is the number of true positive results divided by the number of all positive results, including those not identified correctly, and the recall is the number of true positive results divided by the number of all samples that should have been identified as positive.

$$precision = \frac{true\,positives}{true\,positives\,+\,false\,positives}$$

$$recall = \frac{true\,positives}{true\,positives\,+\,false\,negatives}$$

$$F1 = 2 \times \frac{precision \times recall}{precision + recall}$$

In the case of QA, the predicted and true answers are divided into characters, and check the presence of characters in both answer 

> #True Positives : # of characters present in both predicted answer and true answer
#False Positives : # of characters present in the predicted answer but not the true answer
#False Negatives ; # of characters present in the true answer but not in the predicted answer

Then the same formulas are applied.

- reader_top1_f1 : average of F1 scores for only the first predicted answers of all the queries
- reader_top1_f1_has_answer : Average of F1 scores for only the first predicted answers not impossible to answer.
- reader_top1_fk : Average of F1 scores of the first k predicted answers of all the queries
- reader_top1_fk_has_answer : Average of F1 scores of the first k predicted answers not impossible to answe of all the queries.




