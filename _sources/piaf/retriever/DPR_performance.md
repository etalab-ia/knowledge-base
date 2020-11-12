# Investigating the performance of DPR Camembert (finetuned over PIAF combo)

## Intro

I have fine-tuned a camambert model over our combo of French SQuAD-like datasets (PIAF, FQuAD, SQuAD-FR) using the [DPR objective](https://arxiv.org/abs/2004.04906) (similarity between query and positive and dissimilarity with negative contexts). The objective is to use this model in our PIAF Retriever module. 

### Problem 

The training has been completed on Jean ZAY. It runs without major problems apprently. Still, when testing this model with our [evaluation script](https://github.com/etalab-ia/piaf-ml/blob/master/src/evaluation/retriever_25k_eval.py) and our test dataset (460 SPF questions), the results are surprisingly low (around 5%) compared to those obtained with BM25 (~20%) and SBERT (~18%).

### Possible sources of errors

One or more initial issues may be the culprit for this low performance: 

0. Not properly following the parameters used in DPR ;

1. DPR and Huggingface and Haystack are all ready for dealing with BERT-like encoders (context and query). Camembert is based on Roberta, so maybe the differences when converting the output of the DPR training to a Haystack compatible model input generate the low performance ;

2. The training (and dev) dataset has only one positive context and one hard negative context. While in the paper (and [issues](https://github.com/facebookresearch/DPR/issues/42)) they affirm this is enough, and in the code it is indeed the case, maybe I am missing something ? Note: while the training uses only 1 hard negative contexts, the evaluation employs 30!

3. The hard negative contexts I am using are not good ? I follow the paper and use the top-k results from a BM25 query **not containing the answer** ;

4. My evaluation script des not work properly. The mapping + FAISS layer is somehow not working.



### Solutions tested already

For each problem above, I have tried:

0. I was training with 4 Nvidia V100 GPUs, so a realb batch size of 16 * 4 = 64 ; while DPR used 8 V100s, so 16 * 8 = 128. Fixed this, no dice.

1. Changed to a [multilingual bert](https://huggingface.co/bert-base-multilingual-uncased). Still bad results, so even if use the same architecture, I still have bad results.
2. Following the original Natural Questions [input datset used by DPR](https://dl.fbaipublicfiles.com/dpr/data/retriever/biencoder-nq-train.json.gz), I added around 90 hard negative contexts to each question. The results with my script are still horrible. 

```{note}
**Note**: at the end of the training, we have an average rank of about 4, while DPR reported 24 :/ 
```

3. Nothing tested until now.
4. **This notebook analyses** the possibility of an ill-conceived evaluation script (specifically, the part testing dpr).

## Methodology

I need to check if my fine-tuned multilingual Bert model (mbertDPR) is working. Let's not use my evaluation script, but [Haystack's e2e evaluation script](https://github.com/deepset-ai/haystack/blob/master/tutorials/Tutorial5_Evaluation.ipynb). We will focus exlcusively on the retriever for now. Also, while they test in English, I believe a multilingual bert should not do very bad. 

Haystack allows us to use either two types of backends: `ElasticsearchDocumentStore` or `FAISSDocumentStore`.
The former uses ElasticSearch, the latter uses Facebook FAISS.

Both backends are quite known and mature (ES much more maybe). In the following, I will test both backends in DPR mode, while using three models: 

1. the model as shared by DPR authors,
2. my mbertDPR model, and
3. the non fine-tuned multilingual Bert model (mbert).

### Using `ElasticsearchDocumentStore`

#### BM25 Default Results

```
Retriever Recall: 1.0
Retriever Mean Avg Precision: 0.9367283950617283
11/11/2020 18:50:26 - INFO - haystack.retriever.base -   For 54 out of 54 questions (100.00%), the answer was in the top-10 candidate passages selected by the retriever.

```

#### DPR (facebook) Results (embedded title)
```
11/11/2020 18:57:09 - INFO - haystack.retriever.base -   For 54 out of 54 questions (100.00%), the answer was in the top-10 candidate passages selected by the retriever.
Retriever Recall: 1.0
Retriever Mean Avg Precision: 0.9711934156378601
```

#### DPR (facebook) Results (non embedded title)
```
11/11/2020 18:59:17 - INFO - haystack.retriever.base -   For 53 out of 54 questions (98.15%), the answer was in the top-10 candidate passages selected by the retriever.
Retriever Recall: 0.9814814814814815
Retriever Mean Avg Precision: 0.955761316872428 
```


#### DPR (mbertDPR) Results (embedded title)

```
11/11/2020 19:25:12 - INFO - haystack.retriever.base -   For 54 out of 54 questions (100.00%), the answer was in the top-10 candidate passages selected by the retriever.
Retriever Recall: 1.0
Retriever Mean Avg Precision: 0.9223985890652557
```

#### DPR (mbertDPR) Results (non embedded title)

```
11/11/2020 19:43:48 - INFO - haystack.retriever.base -   For 54 out of 54 questions (100.00%), the answer was in the top-10 candidate passages selected by the retriever.
Retriever Recall: 1.0
Retriever Mean Avg Precision: 0.9259994121105234
```

#### DPR (mbert) Results (embedded title)
```
11/11/2020 19:52:58 - INFO - haystack.retriever.base -   For 20 out of 54 questions (37.04%), the answer was in the top-10 candidate passages selected by the retriever.
Retriever Recall: 0.37037037037037035
Retriever Mean Avg Precision: 0.12617577895355675
```


#### DPR (mbert) Results (non embedded title)
```
11/11/2020 19:48:42 - INFO - haystack.retriever.base -   For 18 out of 54 questions (33.33%), the answer was in the top-10 candidate passages selected by the retriever.
Retriever Recall: 0.3333333333333333
Retriever Mean Avg Precision: 0.12633009994121103
```

### Using `FAISS`

```{error}
Actually, I cannot test this using FAISS as a backend. The reason is that the method `add_eval_data` is not available for this document store.
```

Some quick solutions : 
1. Create a temporary `add_eval_data` function that could take SQuAD-like data and add it to a FAISS document store without taking into consideration the QA part (i.e., without Reader evaluation).

2. Another way would be to use an `ElasticSearchDocumentStore` in my evaluation script instead of a FAISS store. 

I chose solution two, as it would validate quickly whether camembertDPR is working or not.

## Using `ElasticSearchDocumentStore` in our Evaluation script



