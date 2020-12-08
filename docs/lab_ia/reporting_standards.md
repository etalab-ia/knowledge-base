
# Reporting Standards

This section will spec out what we feel are the minimum requirement/recommendations for writing useful reports on experiments we carry out here at the Lab IA team. We can have two main types of reports: 
1. Those that aim to be read by other team members involved in the same project ;
2. More general reports that allow other public to familiarize with our work.

In general, we should strive to write a report when we have multiple options to improve an existing system and we must choose one, when we believe that we have a more efficient method to solve a problem, when we need to confirm or debunk an idea, or when we want to communicate our progress to people outside of our team. 

While experimenting is good, we should keep in mind that the methods we test, if succesful, may end up in our production pipeline. That is why we should consider our methods from a production point of view (i.e, my method augments performance 10% but it is 5x slower than the existing solution plus it adds another library/misterious-hack layer to the current stack).

As you will find  out, these standards are very similar to the standards followed while coding. 

## Experiments review

Experiments review is easiest when begining from a pull request on GitHub.

## Requesting review

When requesting a report review spell out to the reviewer the context and objectives of the reported experiment. The specifics of the report should be spelled out in each subsection. 

## Reviewing others reports

This list is by no means exhaustive, report review should be a chance to see how others approach problems, learn from them, and suggested changes.

* Are the experiments well explained?
* Does the experiments do what the author intended?
* Does the experiments do what it said it should overall?
* Regarding the experimental setup, is it coherent with the requirements of the experiment?
* Are the plots well labeled, do the scales make sense?
* Is there a conclusion? Is the conclusion backed up by the results of the experiments?

## Minimum structure

A easy and fast to read report (either a Jupyter Notebook or a Markdown file) should have at the bare minima the following sections: 

1. Intro
    * Context
    * Problem
    * Proposed solution/analysis/intuition.
2. Experimental Setup
    * System environment (OS, GPU/noGPU, RAM size (if applicable)),
    * Code version (hash of the commit used to produce these results)
    * Data characteristics (version, distribution, size, ...)
3. Anaysis/Modeling
    * Steps followed to perform the analysis/modeling.
4. Results
    * Plots/tables of the obtained results
5. Conclusions
    * Do we achieved what we set to achieve?
    * Why do we think we obtain what we obtain (why does it works, why not?)
    * What are some advantages/disadvantages/shortcomings/potentials of the proposed work?
    * Can we apply it easily/hastily to our current development pipeline?
    * Is the solution scalable? Does it adds too much complexity to the current basecode (in terms of computer power and in technical requirements)?
6. Next steps
    * What should we do now? 
    * What should still be tested?
    * What's the place of this new method in the pipeline (if any)?
    * How to add it to our basecode? 

## Markdown (or MyST) Syntax

The version of Markdown used in Jupyter Book is called MyST, which is a mix of RST with regular Markdown. 

```{note}
This Markdown version is different than the one used in our pad's. Most of the functionality is there but there are certain aspects that do not work, such as the emojis :/
```

RST has some quite nice capabilities, such as directly mixing code with text à la Rmarkdown. 

[Here](https://jupyterbook.org/reference/cheatsheet.html) you can find a quick list of recurrent syntax elements to help you during your reporting.

