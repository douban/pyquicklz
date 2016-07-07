__author__    = "davies <davies.liu@gmail.com>"
__version__   = "1.4.1"
__copyright__ = "Copyright (C) 2010 douban.com"
__license__   = "Apache License 2.0"

from libc.stdint cimport uint16_t, uint32_t, uint16_t
from libc.stdlib cimport malloc, free
from cpython cimport PyBytes_AsStringAndSize, PyBytes_FromStringAndSize

cdef extern from "src/quicklz.h":
    cdef enum:
        QLZ_SCRATCH_COMPRESS
        QLZ_SCRATCH_DECOMPRESS
    size_t qlz_size_decompressed(char *source) nogil
    size_t qlz_size_compressed(char *source) nogil
    size_t qlz_decompress(char *source, void *destination, char *scratch_decompress) nogil
    size_t qlz_compress(void *source, char *destination, size_t size, char *scratch_compress) nogil

def compress(bytes val):
    cdef char *wbuf
    cdef char *src
    cdef char *dst
    cdef Py_ssize_t vlen
    cdef int csize
    if not val:
        return b""
    PyBytes_AsStringAndSize(val, &src, &vlen)
    dst = <char *>malloc(vlen + 400)
    with nogil:
        wbuf = <char *>malloc(QLZ_SCRATCH_COMPRESS)
        csize = qlz_compress(src, dst, vlen, wbuf)
        free(wbuf)

    val = PyBytes_FromStringAndSize(dst, csize)
    free(dst)
    return val

def decompress(bytes val):
    cdef char wbuf[QLZ_SCRATCH_DECOMPRESS]
    cdef char *src
    cdef char *dst
    cdef Py_ssize_t slen, dlen
    if not val:
       return b""
    PyBytes_AsStringAndSize(val, &src, &slen)
    if qlz_size_compressed(src) != slen:
        raise ValueError('compressed length not match %d!=%d' % (slen, qlz_size_compressed(src)))
    dst = <char*> malloc(qlz_size_decompressed(src))
    with nogil:
        dlen = qlz_decompress(src, dst, wbuf)

    val = PyBytes_FromStringAndSize(dst, dlen);
    free(dst)
    return val

TRY_LENGTH = 1024 * 10

def try_compress(bytes val, minlength=256, ratio=0.8):
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
