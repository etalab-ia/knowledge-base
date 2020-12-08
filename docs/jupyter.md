
# Notebooks (.ipynb)

Notebooks are great for conduction exploratory analysis and keeping notes, but they do introduce some problems - particularly when maintaining project structure, sensible imports, and version control.

Also refer to Python guidance.

## Structure

One problem with notebooks is they encourage bad importing practice. It might be tempting to do something like this:

```python
# ipython notebook:
%run my_notebook_of_handy_functions.py
y = my_function(x)
```

This should be avoided, as it is akin to from my_notebook_of_handy_functions import *, which doesn't give the reader of the code much of a clue where the functions are located. It [is generally considered best practice](https://www.python.org/dev/peps/pep-0008/#id23) to declare explicit imports at the top of the file, with one line per module:

```python
from os import environ
# for multiple functions you can use commas
from numpy import sqrt, correlate, pi
# for very long imports use a tuple
from numpy import (apply_along_axis, arange, argsort, correlate, cos,
                   diagonal, pi, sqrt, tan, tile)
# or use the module.function syntax if you're using a lot of functions
# (note that import that both approaches are computationally identical)
import numpy
numpy.sqrt(x)
```


## Version control

Notebooks do not lend themselves well to version control - because of their verbose file structure that contains lots of information in addition to the code - makes [git diff](https://git-scm.com/docs/git-diff) or pull requests difficult to interpret. To prevent this from causing difficulties, I'd suggest taking one or both of the following steps:

1. Use [`nbstripout`](https://git-scm.com/docs/git-diff) to remove `.ipynb` output

    One of the main reasons commits from ​notebooks are so verbose is that they contain the output of the code. This can often change lots for a small change in code, making large git diffs. nbstripout remove the output from the notebook before it is sent to GitHub (i.e. a git filter). To set it up:

    ```bash
    pip install -U nbstripout
    cd $local_git_repo
    nbstripout --install --attributes .gitattributes
    ```

2. Use a custom pre-commit hook to generate `.py` files

    Git hooks let you run scripts at certain times during the git process. You can use the following script to generate two version of the code for the repo: one containing only the code (great for `git diff`) and a rendered version for viewing.

    To create a pre-commit git hook, that generates a .py and .html file for each .ipynb, create the file repo/.git/hooks/pre-commit (note the file has no extension) containing:

    ```bash
    #!/bin/sh
    #
    ## Convert all .ipynb files to .py and .html versions for git

    files=` git diff --cached --name-only | grep 'ipynb' | grep -v '.ipynb_checkpoints'`

    # Don't treat spaces as a new file
    OIFS="$IFS"
    IFS=$'\n'

    for f in $files; do

        echo $f

        # Get dirnames and create them
        newdir=`dirname "$f"`
        mkdir -p "nb_src/$newdir"
        mkdir -p "nb_render/$newdir"

        # Convert to .py and .html
        pyfile="nb_src/${f%.ipynb}.py"
        htmlfile="nb_render/${f%.ipynb}.html"

        jupyter nbconvert --to script "$f" --stdout > "$pyfile"
        jupyter nbconvert --to html "$f" --stdout > "$htmlfile"

        # Add it back to index
        git add "$pyfile"
        git add "$htmlfile"

    done

    # Reset spaces
    IFS="$OIFS"
    ```

    *Note*: The generated `.py` and `.html` files will be committed but are not present in the git diff message presented in the terminal. This is a bug in git as the diff message is generated before the pre-commit script fires.

