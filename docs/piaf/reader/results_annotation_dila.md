Results generated dila dataset with more annotations
=========

# Context
We annotated 93 questions answers on the dataset from the DILA. The annotation was conducted on the most searched pages from service-public.fr
We want to evaluate the impact on the performances

# Data
The dataset used is in version full_spf_squad.json_V1, which includes the previously annotated QA (128) and the latest QA (93)

# Test
This is the test config 
```python
parameters = {
    "k_retriever": [1],
    "k_title_retriever" : [1], # must be present, but only used when retriever_type == title_bm25
    "k_reader_per_candidate": [20],
    "k_reader_total": [5],
    "reader_model_version": ["053b085d851196110d7a83d8e0f077d0a18470be"],
    "retriever_model_version": ["1a01b38498875d45f69b2a6721bf6fe87425da39"],
    "retriever_type": ["bm25", "title_bm25"], # Can be bm25, sbert, dpr, title or title_bm25
    "squad_dataset": ["./clients/dila/knowledge_base/squad.json"],
    "filter_level": [None],
    "preprocessing": [False],
    "boosting" : [1], #default to 1
    "split_by": ["word"],  # Can be "word", "sentence", or "passage"
    "split_length": [1000],
    "experiment_name": ["DILA_fullspfV1"]
}
# rules:
# corpus and retriever type requires reloading ES indexing
# filtering requires >v10
#
```

# Results
| Retriever | Dataset | top-k accuracy has answer |
| -------- | -------- | -------- |
| bm25     | full_spf     | 0.49     |
| bm25     | full_spf_v1     | 0.35     |
| title_bm25     | full_spf     | 0.59     |
|   title_bm25      | full_spf_v1    | 0.43     |

Note that the performance has slightly dropped from the previously generated results (from 52 to 49%). This enforces the need for a non-regression test on the PRs. 
