# -*- encoding:utf-8 -*-
import unittest
import random
import quicklz
import marshal

def randstr(len):
    return ''.join(chr(random.randint(1,255)) for i in range(len))

class Test(unittest.TestCase):

    def test_compress(self):
        text = 'hello'
        assert text == quicklz.decompress(quicklz.compress(text))
        text = randstr(10000)
        assert text == quicklz.decompress(quicklz.compress(text))

    def test_try_compress(self):
        cases = [
            ('hello', False, 'short string'),
            (randstr(1024*100), False, 'random str'),
            (marshal.dumps(range(1024*4)), True, 'marshal of range()'),
        ]
        for text, c, desc in cases:
            ok, d = quicklz.try_compress(text)
            assert ok == c, desc
            if ok:
                assert text == quicklz.decompress(d), 'data not match'

if __name__ == '__main__':
    unittest.main()
