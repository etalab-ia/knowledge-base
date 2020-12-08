
# Coding Standards

This section will spec out what we feel are the minimum requirement/recommendations for writing good code, that can be reviewed effectively, shared with others, and follows best practices.

## Code review

Code review is easiest when begining from a pull request on GitHub.

### Requesting review

When requesting a code review spell out to the reviewer what the code should do at high level. The specifics of what the code actually does should be spelled out in the docstrings (or similar) or your functions. If the reviewer needs to configure their environment to effectively test the code (e.g. with data or environment variables) set this out in the pull request.

### Reviewing others code

This list is by no means exhaustive, code review should be a chance to see how others approach problems, learn from them, and suggested changes.

* Does the code do what the author intended?
    * Does the code do what it said it should overall?
    * Do the functions do what the docstrings (or similar) say they should?
* If the project has unit/integration tests, do they pass?
* Does the code work without errors? If warnings are displayed are they explained?
* Are there edge cases you can spot that might break the code?
* Does the code follow the conventions and minimum style requirements?

## Automated testing

Automated testing can catch unforeseen errors in the code. Typically unit tests are used to test small specific sections of code (i.e. functions or methods) and integration tests are used to check the components work together in the correct way.

Projects that are high risk (i.e. the software failing or inadvertently producing incorrect results could cause significant problems) or are high scale (i.e. lots of people use them) should have unit tests. If you have identified the project as requiring unit tests, you should aim to reach code coverage ≥ 75%. If possible, the automated testing framework should integrate with a CI tool that protects the master branch from PR that do not meet this criteria.
