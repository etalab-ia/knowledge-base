
# Working with Git

By default all work should be stored on the [Lab IA github organisation repo](https://github.com/etalab-ia/). Still, it is prefered to move a project to the team's repo once the development is at a MVP stage. When using secrets (API keys, usernames, passwords, adresses, sensitive information, etc), you shoud  always follow the guidelines in the Secrets guideline. 

## How should I organize my codebase?

A good bare minimum data-science oriented folder structure can be found [here](https://github.com/etalab-ia/data_science_template).
This template is proposed when a new repo is created from Lab IA's organization.

```
.
├── data
├── LICENSE
├── logs
├── README.md
├── notebooks
├── reports
├── results
└── src
    ├── data
    │   └── __init__.py
    ├── __init__.py
    ├── models
    │   └── __init__.py
    └── util
        └── __init__.py
```




## Branches

Treat the master branch as a place for finished code and always work on another branch. This makes code review easy even for the initial version of a project, as you can submit a pull request to merge the first working version of the code into master.

## How often should I branch? How often to review code?

Follow the Git Flow convention. Each major feature should be developed on a branch. This should **ideally** be reviewed (see Code Review) by at least one other team member and passed any unit/integration (if existing) tests before the code is merged into the master branch. Working in this way also encourages the development of modular code.

When considering what constitutes a major feature think of the reviewer. Aim to strike a balance between having long pull requests that require a lot of time to review and short but frequent pull requests. As a ball park figure, accurate review of 200-400 lines of code should take 60-90 minutes to review with an accuracy of 70-90%.

## Create a README.md

All projects should have a README.md that gives enough information for someone to understand the project and get started with the code. If a project has multiple components, consider nesting and linking them, with each readme explaining a specific component.

```
├── README.md             (General overview)
├── Component 1
│   ├── README.md         (Specific instructions)
│   ├── code.sh
├── Component 2
│   ├── README.md
│   ├── code.sh
...
```

### Example
A bare minimum README file should contain the following sections:

* Project Name
* Project Intro/Objective
* Partner
* Methods Used
* Technologies
* Project Description
* Needs of this project
* Getting Started
* Featured Notebooks/Analysis/Deliverables
* Contributing Etalab Members
* Contact

A full README.md template can be found here

## .gitignore

Maintain a good .gitignore file. Github proposes defaut .gitignore files ready to be used. [Here is the Python example](https://github.com/github/gitignore/blob/master/Python.gitignore). Please add your `.idea` folder to your .gitignore file in order to avoid having your local PyCharm's (or other) config file in the repo :) 

## Configuration

One common mistake with Git is not correctly associating your local account with the remote one. To do this, make sure your globally configured email is the same as one of your GitHub emails.

```git config --global user.email "me@data.gouv.fr"```
