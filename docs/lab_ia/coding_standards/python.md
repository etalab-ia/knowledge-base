
# Python

You should always use Python 3.

## requirements.txt

All python projects should have a `requirements.txt` (or `envoronment.yml`) file in the root directory.

We always use environments to contenarize the specific versions of our libraries. A recommended way is by using a [conda distribution](https://www.anaconda.com/products/individual) specific to your system. Once installed, you can create a new environment with: 

```bash
 conda create --name new_env  python=3.7 -y
```
Reload you terminal session (e.g., logoff/logon) and then activate it with:
```bash
conda activate new_env
```

## Parameters

Avoid hard coded parameters wherever possible: use a separate file (`parameters.py` or `param.json` or some other single place to set params you're likely to change).

Detailing the parameters as a table in `README.md` can also be useful.

## Notebooks (.ipynb)

Please see the section on Jupyter Notebooks if you use them.

## Code

These shouldn't be too prescriptive or limiting - the intention is to set a standard to enable others who use your code to get started quickly.
Style

The Hitchhikers Guide has a comprehensive style guide for best practice, but this is a bit prescriptive. To keep us on the same page for collaboration code should:

    * Confirm to [PEP8](https://www.python.org/dev/peps/pep-0008/) (see [pycodestyle](https://github.com/PyCQA/pycodestyle) for linting in text editors and [autopep8](https://pypi.org/project/autopep8/) or [YAPF](https://github.com/google/yapf) for automatic correction)
    * Use *spaces instead of tabs*

## Docstrings

Ideally, even simple functions should have a docstring. What is simple at the time of writing might not be simple to someone who hasn't seen the code before.

```python
def double(x):
    '''Double a number'''
    return(x * 2)
```

For complex functions that take a number of parameters the numpy docstring format is recommended. Text editor plugins can be used to autogenerate much of the docstring. This example is perhaps a bit more than you would need to write - but sets out a nice layout for writing docstrings.

```python
def nanmax(a, axis=None, out=None, keepdims=np._NoValue):
    """
    Return the maximum of an array or maximum along an axis, ignoring any
    NaNs.  When all-NaN slices are encountered a ``RuntimeWarning`` is
    raised and NaN is returned for that slice.

    Parameters
    ----------
    a : array_like
        Array containing numbers whose maximum is desired. If `a` is not an
        array, a conversion is attempted.
    axis : {int, tuple of int, None}, optional
        Axis or axes along which the maximum is computed. The default is to compute
        the maximum of the flattened array.
    out : ndarray, optional
        Alternate output array in which to place the result.  The default
        is ``None``; if provided, it must have the same shape as the
        expected output, but the type will be cast if necessary.  See
        `doc.ufuncs` for details.
    keepdims : bool, optional
        If this is set to True, the axes which are reduced are left
        in the result as dimensions with size one. With this option,
        the result will broadcast correctly against the original `a`.
        If the value is anything but the default, then
        `keepdims` will be passed through to the `max` method
        of sub-classes of `ndarray`.  If the sub-classes methods
        does not implement `keepdims` any exceptions will be raised.

    Returns
    -------
    nanmax : ndarray
        An array with the same shape as `a`, with the specified axis removed.
        If `a` is a 0-d array, or if axis is None, an ndarray scalar is
        returned.  The same dtype as `a` is returned.


    Notes
    -----
    NumPy uses the IEEE Standard for Binary Floating-Point for Arithmetic
    (IEEE 754). This means that Not a Number is not equivalent to infinity.
    Positive infinity is treated as a very large number and negative
    infinity is treated as a very small (i.e. negative) number.
    If the input has a integer type the function is equivalent to np.max.

    Examples
    --------
    >>> a = np.array([[1, 2], [3, np.nan]])
    >>> np.nanmax(a)
    3.0
    """
```
