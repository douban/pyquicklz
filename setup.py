#!/usr/bin/env python
import sys
from setuptools import setup, Extension
setup(
    name='pyquicklz',
    version='1.4.1',
    description='python binding of quicklz',
    setup_requires=['Cython >= 0.18'],
    ext_modules=[
        Extension('quicklz', ['quicklz.pyx', 'src/quicklz.c']),
    ],
    test_suite="test",
)
