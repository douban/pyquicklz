i__author__    = "davies <davies.liu@gmail.com>"
__version__   = "1.4.1"
__copyright__ = "Copyright (C) 2010 douban.com"
__license__   = "Apache License 2.0"

cdef extern from "Python.h":
    ctypedef int Py_ssize_t
    int PyString_AsStringAndSize(object obj, char **s, Py_ssize_t *len) except -1
    object PyString_FromStringAndSize(char * v, Py_ssize_t len)

    ctypedef struct PyThreadState:
            pass
    PyThreadState *PyEval_SaveThread()
    void PyEval_RestoreThread(PyThreadState *_save)

cdef extern from "stdlib.h":
    ctypedef unsigned int size_t
    void *malloc(size_t size)
    void free(void *ptr)

cdef extern from "stdint.h":
    ctypedef unsigned short int uint16_t
    ctypedef unsigned int uint32_t
    ctypedef unsigned long long int uint64_t

cdef extern from "src/quicklz.h":
    cdef enum:
        QLZ_SCRATCH_COMPRESS
        QLZ_SCRATCH_DECOMPRESS
    size_t qlz_size_decompressed(char *source)
    size_t qlz_size_compressed(char *source)
    size_t qlz_decompress(char *source, void *destination, char *scratch_decompress)
    size_t qlz_compress(void *source, char *destination, size_t size, char *scratch_compress)

def compress(val):
    cdef char *wbuf
    cdef char *src
    cdef char *dst
    cdef Py_ssize_t vlen
    cdef int csize
    if not isinstance(val, str):
        raise ValueError
    if not val:
        return ""
    PyString_AsStringAndSize(val, &src, &vlen)
    wbuf = <char *>malloc(QLZ_SCRATCH_COMPRESS)
    dst = <char *>malloc(vlen + 400)
    csize = qlz_compress(src, dst, vlen, wbuf)
    free(wbuf)
    val = PyString_FromStringAndSize(dst, csize)
    free(dst)
    return val

def decompress(val):
    cdef char wbuf[QLZ_SCRATCH_DECOMPRESS]
    cdef char *src
    cdef char *dst
    cdef Py_ssize_t slen, dlen
    if not isinstance(val, str):
        raise ValueError
    if not val:
       return ""
    PyString_AsStringAndSize(val, &src, &slen)
    if qlz_size_compressed(src) != slen:
        raise ValueError('compressed length not match %d!=%d' % (slen, qlz_size_compressed(src)))
        
    dst = <char*> malloc(qlz_size_decompressed(src))
    dlen = qlz_decompress(src, dst, wbuf)
    val = PyString_FromStringAndSize(dst, dlen);
    free(dst)
    return val

TRY_LENGTH = 1024 * 10

def try_compress(val, minlength=256, ratio=0.8):
    if not isinstance(val, str):
        raise ValueError
    if len(val) < minlength:
        return False, val
    if len(val) > TRY_LENGTH:
        v = compress(val[:TRY_LENGTH])
        if len(v) > len(val) * ratio:
            return False, val
    v = compress(val)
    if len(v) > len(val) * ratio:
        return False, val
    return True, v
