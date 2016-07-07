#!/usr/bin/env python
import sys
from setuptools import setup, Extension

if sys.version_info.major < 3 and 'setuptools.extension' in sys.modules:
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
