# -*- encoding:utf-8 -*-
import unittest
import os
import quicklz
import marshal

class Test(unittest.TestCase):

    def test_compress(self):
        text = b'hello'
        assert text == quicklz.decompress(quicklz.compress(text))
        text = os.urandom(10000)
        assert text == quicklz.decompress(quicklz.compress(text))

    def test_empty_string(self):
        text = b''
        assert quicklz.compress(text) == b''
        assert text == quicklz.decompress(quicklz.compress(text))

    def test_try_compress(self):
        cases = [
            (b'hello', False, 'short string'),
            (os.urandom(1024*100), False, 'random str'),
            (marshal.dumps(list(range(1024*4))), True, 'marshal of range()'),
        ]
        for text, c, desc in cases:
            ok, d = quicklz.try_compress(text)
            assert ok == c, desc
            if ok:
                assert text == quicklz.decompress(d), 'data not match'

if __name__ == '__main__':
    unittest.main()
