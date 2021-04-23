# Secrets

Sometimes projects require the use of secure information, like **passwords** or **api keys**, that you wouldn't want to store in GitHub as text. This document will offer some recommendations for working with secret files.

## Keep secrets in the environment

**Secrets should never be hardcoded.** Instead they should be stored as environment variables.

`direnv`, [a shell extension]([https://direnv.net/]), can take much of the hard work out of maintaining environment variable - as it automates the loading of environment variables when you cd into a directory containing a `.envrc` file. 

`.envrc` files are blocked by default (to prevent them running automatically if you've cloned a repo) so enable them with direnv allow.

### Example

This example uses a separate secrets file, as some programs do not support the export var=secret syntax.

`.envrc:`

```bash
#!bash
# `set -a` will export all variables that are sourced
set -a

#Call the secrets file
. ./secrets
## Return set the the default: `set +a`
set +a
```

`secrets`:

```bash
VERY_SECRET_ENV_VAR=12345
ANOTHER_SERET_ENV_VAR="password"
```

`prefs.py:`

```python
import os
VERY_SECRET_ENV_VAR = os.environ['VERY_SECRET_ENV_VAR']
```

## Secret files should never be committed

Secret files should never be committed to GitHub in a readable form.

To ensure this is the case maintain a `.gitignore` file that will prevent any files being committed. One idea is to end all secret files with a particular extension, then include that in the `.gitignore` file:

```
**/secrets
**/*.key
```

## Perform checks before pushing

To check for files that contain secrets in a repo use `trufflehog`. This looks for strings with high entropy (that are probably passwords or keys) in a git repo.
```
# To install
pip3 install trufflehog
# Look for keys in the current repo
trufflehog .
```

## Do not commit sensitive data

Often we work with **data that should not be commited** to Github (either in public nor in public repos**). For now, the easiest way to avoid this is to take care while commiting the files contained in your `data` folder. 

## Bonus: what to do if you actually commit sensitive data (or secrets) ?

Do not panic and follow the detailed instructions [here](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/removing-sensitive-data-from-a-repository)

In short, using the recommended option, using `filter-branch` (less black-boxy than `BFG`), you should do:
```bash
# 1. 

git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch PATH-TO-YOUR-FILE-WITH-SENSITIVE-DATA" \
  --prune-empty --tag-name-filter cat -- --all

# 2. 

echo "YOUR-FILE-WITH-SENSITIVE-DATA" >> .gitignore
$ git add .gitignore
$ git commit -m "Add YOUR-FILE-WITH-SENSITIVE-DATA to .gitignore"


# 3. 

git push origin --force --all


# 4. After checking everything is cool: 

git for-each-ref --format="delete %(refname)" refs/original | git update-ref --stdin
git reflog expire --expire=now --all
git gc --prune=now

# 5. Contact GitHub Support or GitHub Premium Support, asking them to remove cached views and references to the sensitive data in pull requests on GitHub.
```