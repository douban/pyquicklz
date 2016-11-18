#!/usr/bin/env python
import sys
from setuptools import setup, Extension
setup(
    name='quicklz',
    version='1.4.1',
    description='python binding of quicklz',
    setup_requires=['setuptools_cython', 'Cython >= 0.18'],
    ext_modules=[
        Extension('quicklz', ['quicklz.pyx', 'src/quicklz.c']),
    ],
    test_suite="test",
)
