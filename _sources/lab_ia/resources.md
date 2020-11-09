
# Resources


## Etalab
An essential overview of what Etalab is all about can be found in [the report 2016-2017 of the administrateur général des données AGD](https://www.etalab.gouv.fr/wp-content/uploads/2018/04/RapportAGD_2016-2017_web.pdf).

A list of useful links about the day-to-day work is [here](https://etalab.github.io/etalab/).

## Data Science / Machine Learning 

### Tabular Data

While the baseline way to build dataset vectors is by using the textual meta-data of each one of them (description, title, keywords, etc), we could exploit the content of the datasets. Below I show some ressources to get started on this subject.

Regarding the dataset2vec idea, ideally you can familiarize yourself with the concept of embeddings by taking a look into one of the most famous [paper on the subject](https://papers.nips.cc/paper/5021-distributed-representations-of-words-and-phrases-and-their-compositionality.pdf). Or by looking at [this interesting take by the author of NNMNLP ](https://papers.nips.cc/paper/5477-neural-word-embedding-as-implicit-matrix-factorization.pdf). There are also plenty of blogposts/papers that try to facilitate the comprehension of the topic, such as this [one](https://arxiv.org/abs/1709.03856).  


Once familiarized with the concept, this blogpost explains what I would like to try on the subject of an eventual [table2vec](https://www.fast.ai/2018/04/29/categorical-embeddings/)

An other exploration avenue is the transformation of tables into text. A mini-review on the subject can be found [here](https://github.com/sebastianruder/NLP-progress/blob/master/english/data_to_text_generation.md).

A final possibility, if there is time :), would be to explore the candidate machine learnable datasets with automatic machine learning approahces such as [autogluon](https://github.com/awslabs/autogluon) and [dabl](https://dabl.github.io/dev/).

### NLP 

A very good intro to modern NLP can be found in the first chapters of Neural Network Methods in Natural Language Processing (NNMNLP). A more applied view into modern NLP can be found in the first chapters of Natural Language Processing with PyTorch (NLPP). We have both books here at Etalab. 

For now, we are training/testing NLP with flair and sometimes with spacy or similar libraries. Flair(https://github.com/flairNLP/flair) is quite intuitive and it has great documentation. Just doing the example exercises in the repo README is enough to get started. We mainly focus on Recurrent Neural Networks (it is well explained in NNMNLP). Specifically, biLSTM + CRF architectures that were [quite famous some years ago](https://arxiv.org/abs/1603.01360).

Aside from recurrent networks, and going into more parallelizable/performant models, I want to move on to newer architectures, namely Transformers. Transformers is the name of the neural network architecture as well as the name of a NLP Python library](https://github.com/huggingface/transformers/) that facilitates the use of the Transformer methods. If you could do the intro exercises that would be good enough.

The intro chapters in NNMNLP are a really good start. If you want to go more in detail into what it is being currently done today in NLP, you can check the nice introduction to Transformers in its seminal [paper "Attention is all you need"](https://arxiv.org/abs/1706.03762). That paper, coupled to this other on [Attention Mechansims](https://arxiv.org/abs/1902.02181) should give you a good intro into what is current in NLP. 


For quicker and simpler (and not necesseraly worse, au contraire) approaches to NLP, a good tutorial on scikit-learn with text data is [this one](https://scikit-learn.org/stable/tutorial/text_analytics/working_with_text_data.html). Doing this exercise will give you a good glimpse on dealing with text with scikit-learn. Scikit-learn is the most famous machine learning library in Python, it has implemented almost all the ML famous methods. It does not have deep learning, nor graph theory though.

Both the pseudo and piaf projects use these technologies (*flair*/*transformers*). A new project that is starting here at Etalab will use them plus some more classical stuff (*scikit-learn*, *gensim*).

## DevOps

### Python

If needed, a good intro to Python in the context of data science can be found in the Python Data Science Handbook (PDSH). We have this book at etalab. The book explores the pandas and scikit-learn Python libraries. Pandas is used to get dataframes like in R and scikit-learn is the library that allows you to train/test machine learning methods. 

An equivalence guide between R and Python is [here](https://www.kdnuggets.com/2017/02/moving-r-python-libraries.html)

A nice [course on the subject is](https://datacarpentry.org/python-ecology-lesson/)


### Web Services


Building a model is nice but putting it to use is essential. You can make it useful via a web service. To do so, usually you need to build an API and a web service.

#### API RESTful

The interface that links users and models. In python, we use flask most of the times as it is the simplest approach. A simple example is [here](https://www.kdnuggets.com/2019/01/build-api-machine-learning-model-using-flask.html).

#### Building a web service

Building web services is a whole computer science domain apart. Still, in order to build quick demos to let users play with our models, it is essential to have a GUI. 

The fastest way I have found to achieve this task is by using [Dask](https://examples.dask.org/machine-learning.html) or [streamlit](https://www.streamlit.io/). The former is more powerful but a little bit more trickier. The latter is less powerful but easier to get it running.


### Git/Github

Git is essential in our coding/testing/writing workflow. Another one-day course is [here](https://swcarpentry.github.io/git-novice/).
Github is the website that allow us to store our code within git repositories.

### Working with a remote server with `ssh`

A good intro into connecting to a remote server, to perform an experiment, to access data, to deploy a service, or other, can be found over [here](https://www.digitalocean.com/community/tutorials/ssh-essentials-working-with-ssh-servers-clients-and-keys). Knowing how to work with a remote server is essential to a developper/ML engineer.
