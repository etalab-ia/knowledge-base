# Test : Preprocessing directly with ElasticSearch Analyzers

## Intro

Currently, we are preprocessing the text we ingest into ElasticSearch (ES) with the [following function](https://github.com/etalab-ia/piaf-ml/blob/9f27997447fe5985eb3d4ddf959fe9435206548e/src/util/convert_json_to_dictsAndEmbeddings.py#L18): 

```python
def preprocess_text(text: str):
    """
    Tokenize, lemmatize, lowercase and remove stop words
    :param text:
    :return:
    """
    if not NLP:
        print('Warning NLP not loaded, text will not be preprocessed')
        return text

    doc = NLP(text)
    text = " ".join(t.lemma_.lower() for t in doc if not t.is_stop).replace("\n", " ")
    return text
```


## Problem

The preprocessing function needs to be ran both while indexing the documents and also while dealign with queries.

To facilitate the installation of our pipeline, our current solution is as coupled to the original Haystack dev as possible. This entails that in production, no other Python code is run. We use the Haystack library as it is in its own master repo. Thus, the function above cannot be run without creating a wrapper that would complexify our production environment. The same is true while querying, this preprocessing would need to run client-side (hard) or creating yet-anonther wrapper for our system that add this function.

## Solution
To solve the issue, @Guillim got an insight from the DScientists working in the _Code du Travail Numerique_ project : use the preprocessors (called _analyzers_) already existing in the ElasticSearch stack. 

In this way, everything would be self-contained within ES.

## Methodo
Analizers [are defined by passing](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-lang-analyzer.html#french-analyzer) a JSON object to our running ES instance (a more French-specific discussion can be found [here](https://jolicode.com/blog/construire-un-bon-analyzer-francais-pour-elasticsearch)).
Once this config is part of the instantiation of ES, we must specify the analyzer to be used (if any) in the specific property of our custom mapping.

```{important}
We are now using the `icu_tokenizer` so we need to install the `analysis-icu` ES plugin. This would be achieved in ES (via Dockerfile installation) like so:

`RUN bin/elasticsearch-plugin install --silent analysis-icu`

```

The resulting PR containing these modifs is [here]().  


## Results


### Python Pre-Processing
The previous simple procesing yields the following improvment: 

1. BM25, v12, 406 QA dataset, no filtering, with no preprocessing: `Mean_precision 0.2199074074074074. Time per ES query (ms): 16.721`
2. BM25, v12, 406 QA dataset, no filtering, with preprocessing:   `Mean_precision 0.3431069958847736. Time per ES query (ms): 19.722`

>In this case, the improvement is of about 13%. Still, the time to run this functions **augments the total time about 3 times.** 


With these results in mind, we can compare the performance of the ES preprocessor below.

### ES Analyzer

We have four _analyzer_ filters:

```python                    
"filter": [
    "french_elision",
    "lowercase",
    "french_stop",
    "french_stemmer"
]
```
Let's do a quick ablation test (check the perf offered by each filter). More info about each of these filters can be found by following the links above.
#### Only _french_elision_ 

* Mean_precision 0.24. Time per ES query (ms): 20.607

#### Only _lowercase_

* Mean_precision 0.21. Time per ES query (ms): 19.473

#### Only _french_stop_

* Mean_precision 0.30. Time per ES query (ms): 10.056

#### Only _french_stemmer_

* Mean_precision 0.22. Time per ES query (ms): 23.966

#### All of them: _french_elision_,  _lowercase_, _french_stop_, _french_stemmer_


* Mean_precision 0.34. Time per ES query (ms): 11.148

#### All of them: _french_elision_,  _lowercase_, _french_stop_, _french_stemmer_ 
Using the `standard` tokenizer instead of the recommended `icu-tokenizer`

* Mean_precision 0.34. Time per ES query (ms): 9.000


## Conclusion

Using the four analyzer filters gives the best performance. Using the pre-processing function gives a negligeable improvement over using an ES analyzer. Still the advantage of an self-contained ES analyzer are multiple: faster, included in ES, and easier to deploy. 

For this experiment the `icu-tokenizer` does not seem to offer an advantage over the `standard` tokenizer.



## TODO

Merge the proposed PR into master and add the required plugin line to Haystack's ES Dockerfile. If it is not possible to add it to the Hastack master, maybe we can roll with the `standard` tokenizer and it will be fine.

