
# Why my trained DPR is (was) not working


## Intro

I have fine-tuned a camambert model over our combo of French SQuAD-like datasets (PIAF, FQuAD, SQuAD-FR) using the [DPR objective](https://arxiv.org/abs/2004.04906) (similarity between query and positive and dissimilarity with negative contexts). The objective is to use this model in our PIAF Retriever module. 

### Problem 

The training has been completed on Jean ZAY. It runs without major problems apprently. Still, when testing this model with our [evaluation script](https://github.com/etalab-ia/piaf-ml/blob/master/src/evaluation/retriever_25k_eval.py) and our test dataset (460 SPF questions), the results are surprisingly low (MAP around 5%) compared to those obtained with BM25 (~20%) and SBERT (~18%).

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
**Note**: at the end of the training, we have an average rank of about 4, while DPR reported 24 :/ 


3. For problem 3, nothing tested yet.

4. **This notebook analyses** the possibility of an ill-conceived evaluation script (specifically, the part testing dpr).

## Performance with Haystack's Evaluation Script

I need to check if my fine-tuned multilingual Bert model (`mbertDPR`) is working. Let's not use my evaluation script, but [Haystack's e2e evaluation script](https://github.com/deepset-ai/haystack/blob/master/tutorials/Tutorial5_Evaluation.ipynb). We will focus exlcusively on the retriever for now. Also, while they test in English, I believe a multilingual bert should not do very bad. 

Haystack allows us to use either two types of backends: `ElasticsearchDocumentStore` or `FAISSDocumentStore`.
The former uses ElasticSearch, the latter uses Facebook FAISS.

Both backends are quite known and mature (ES much more maybe). In the following, I will test both backends in DPR mode, while using three models: 

1. the model as shared by DPR authors,
2. my `mbertDPR` model, and
3. the non fine-tuned multilingual Bert model (`mbert`).

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


#### DPR (`mbertDPR`) Results (embedded title)

```
11/11/2020 19:25:12 - INFO - haystack.retriever.base -   For 54 out of 54 questions (100.00%), the answer was in the top-10 candidate passages selected by the retriever.
Retriever Recall: 1.0
Retriever Mean Avg Precision: 0.9223985890652557
```

#### DPR (`mbertDPR`) Results (non embedded title)

```
11/11/2020 19:43:48 - INFO - haystack.retriever.base -   For 54 out of 54 questions (100.00%), the answer was in the top-10 candidate passages selected by the retriever.
Retriever Recall: 1.0
Retriever Mean Avg Precision: 0.9259994121105234
```

#### DPR (`mbert`) Results (embedded title)
```
11/11/2020 19:52:58 - INFO - haystack.retriever.base -   For 20 out of 54 questions (37.04%), the answer was in the top-10 candidate passages selected by the retriever.
Retriever Recall: 0.37037037037037035
Retriever Mean Avg Precision: 0.12617577895355675
```


#### DPR (`mbert`) Results (non embedded title)
```
11/11/2020 19:48:42 - INFO - haystack.retriever.base -   For 18 out of 54 questions (33.33%), the answer was in the top-10 candidate passages selected by the retriever.
Retriever Recall: 0.3333333333333333
Retriever Mean Avg Precision: 0.12633009994121103
```

#### Discussion

In this proposed test, DPR from faceboook (MAP: 0.97) is indeed better than BM25 (MAP: 0.93). 

```{attention}
And what is better ! Our `mbertDPR` model is performing not as good as facebook's DPR, but correctly (MAP: 0.92)! Maybe the model actually works and it is something else not working ... 
```

** This means there is an error in my evaluation script. ** Before moving on to find this bug, I decided to check the delta in performance between a FAISS and an ES backend.


### Using `FAISS`

```{error}
Actually, I cannot test this using FAISS as a backend. The reason is that the method `add_eval_data` is not available for this document store.
```

We cannot test using Haystack evaluation script but we can test with our script (linked above). I took this evaluation (with FAISS as backend) as far as I could without wasting too much time. It works equally well (or bad) as with ElasticSearchDocumentStore. Some issues start popping up about the size of the column of a table used by FAISS (with postgres backup). It became too much of a hassle. Also, FAISS does not seem to deal with filters (theme, dossier, ...).

Furthermore, I found this table below on the [evaluation](https://github.com/deepset-ai/haystack/blob/2531c8e0613f24b66838ab82ed02024d505aa578/test/benchmarks/retriever_query_results.csv) carried on by Haystack and it shows that it is very much the same thing using FAISS or ES as backends.


```{figure} ../../assets/piaf/haystack_ES_faiss_backend.png
:name: results_haystack

Results reported by Haystack [here] (https://github.com/deepset-ai/haystack/blob/0a1e814bd99301dd186ea29de3d0e7619556a28a/test/benchmarks/retriever_query_results.csv)
```
## Performance with our Evaluation Script 
The main reason I was getting horrible results using FAISS is because I was running this line before indexing in FAISS :
```
document_store.faiss_index.reset()
```

Which I do not know what it does but it doesn't do what I want: to clean the FAISS DB before indexing 

Once this line was removed, I started getting decent results, which are reported in another report [overhere]().

## Conclusion

The objective of this experiment was to try and determine the source of error that caused the low performance of a fine-tuned DPR model on a French QA dataset. We found that the main culprit of this error was a bug in our evaluation script. I determined this error by using Haystack's evaluation script and testing different DPR models.

The performance given by Facebook's DPR model (MAP:0.97) is in the same ball-park than those found by the fine-tuned multilingual Bert model (MAP: 0.92) which would indicate that it works.

This result entails that my fine-tuning is actually working. It is important to note that **this result is found with my `mbertDPR` model trained with 90 hard negative examples per question**.

A bug in the evaluation script was found and fixed, this allowed me to compute the results with our evaluation script. The results of the evaluation can be found in my next report [here](). 

To recap, **there was a bug in the analysis script** and **now we are using ~90 hard negative contexts**. This way we get **decent results with `mbertDPR`**.

As a final remark, both **FAISS or ES as backends seem to be the same performance-wise** (with the amount of data we have).



## Next Steps

We now know that the fine-tuned `mbertDPR` works. Thus, a fine tuned camemBERT should also work. This is covered in the next report (see {doc}`./DPR_fine_tuning`.
