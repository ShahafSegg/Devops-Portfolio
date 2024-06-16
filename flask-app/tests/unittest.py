import unittest

class TestPass(unittest.TestCase):
  def testalwayspass(self):
    self.assertTrue(True)

if name == '__main':
  unittest.main()