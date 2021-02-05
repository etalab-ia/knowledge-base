# Testing the Haystack Pipelines

## Context

At the dawn of launching a new project on the CRPA data to further test the opportunity of using PIAF in the context of
the French administration, we were facing concerns regarding the standardization of the data we were to feed to PIAF.

We want to be able to launch a new instance of PIAF with as few human intervention as possible. However the performance
of the whole pipeline are very much influenced by the size of the knowledge base at disposable for searching. We also
know that many parameters will influence the answer retrieval in terms of quality (number of correct retrievals) and
performances (time necessary for retrieval). These parameters can be : document length, number of documents retreived,
number of answers requested per documents.

It is accepted that some knowledge and orders of magnitude can be acquired by running experiments on general purposed
squad formated dataset generated based on Wikipedia articles. However, we believe that it will be necessary to fine tune every project to make sure that the parameters are optimized. Also, one cannot imagine putting to production a solution that has not been properly evaluated. 

## Solution

In order to use our solution, we thus need to format our data in a form that will be always the same so that every other piece of software we use in the processing the data does not need to be tuned to the use case. 

Our natural solution was to turn to the SQUAD format. Our final goal is to aim at a solution where you would only have to process your data in the squad format. You would then launch the piaf annotation platform to annotate yourself the data. The annotated data will then be used to fine tune and launch your QA solution. 

## Sprint content 
This sprint aims at implementing the solution allowing the evaluation of the PIAF solution. 

## Testing and results 
### Datasets
The results presented in this 