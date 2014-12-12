#!/usr/bin/env python
import sys
from setuptools import setup, Extension
# setuptools DWIM monkey-patch madness: http://dou.bz/37m3XL

if 'setuptools.extension' in sys.modules:
    m = sys.modules['setuptools.extension']
    m.Extension.__dict__ = m._Extension.__dict__

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
