#!/usr/bin/env python

from setuptools import setup, Extension

setup(
        name = 'quicklz',
        version = '1.4.1',
        description = 'python binding of quicklz',
        requires = ['pyrex'],
        ext_modules = [
            Extension('quicklz', ['quicklz.pyx','src/quicklz.c']),
            ],
        py_modules=['quicklz'],
        test_suite="test",
)
