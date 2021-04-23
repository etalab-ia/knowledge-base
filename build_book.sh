rm -rf docs/_build &&  \
jupyter-book toc docs --output-folder docs && \
jupyter-book build --all docs
