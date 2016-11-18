#!/bin/bash
set -e -x

PACKAGE=$1
PYENV=$2


# Install a system package required by our library
yum install -y atlas-devel

if [[ ${PYENV} = "pypy" ]]; then
    mkdir -p /pypy
    wget "https://bitbucket.org/squeaky/portable-pypy/downloads/pypy-5.6-linux_$(uname -m)-portable.tar.bz2" -qO - | tar xj -C /pypy
    /pypy/pypy*/bin/virtualenv-pypy /opt/python/pypy
fi

# Compile wheels
for PYBIN in /opt/python/${PYENV}*/bin; do
    ${PYBIN}/pip install -r /io/requirements.txt
    ${PYBIN}/pip wheel /io/ -w wheelhouse/
done

# Bundle external shared libraries into the wheels
for whl in wheelhouse/*.whl; do
    auditwheel repair $whl -w /io/dist/
done
