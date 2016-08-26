from nltk.stem.porter import *
from nltk.corpus import stopwords

from string import punctuation
import re
import random


def change_y_for_number(ys, d = {}):
  idx = 0
  if d: idx = len(d)
  for i in ys:
    if i not in d:
      d[i] = idx
      idx += 1
  for i in range(len(ys)):
    ys[i] = d[ys[i]]
  return ys, d

def Xs(words=[],stem_words=[]):
  # xs = [for i in l if i in words 1 else 0]
  numbers = [x for x in stem_words if not isinstance(x, int)]
  return list(map(lambda x: 1 if x in words else 0, numbers))

def remove_stopwords(text):
  # remove stopwords
  pattern = re.compile(r'\b(' + r'|'.join(stopwords.words('english')) + r')\b\s*')
  text = pattern.sub('', text.lower())
  return text

def stemming_words(text):
  # get a stemming from words
  stemmer = PorterStemmer()
  r = re.compile(r'[\s{},;.]+\s*'.format(re.escape(punctuation)))
  s = r.split(text)
  stem_words = [stemmer.stem(w.lower()) for w in s if w != '']
  return stem_words

def y_xs(coll=[],
  stem_words = [],
  output="y_xs.csv",
  position_categoric=2,
  position_description=3):

  ys = []
  xs = []
  for row in coll:
    desc = remove_stopwords(row[position_description])
    words = stemming_words(desc)
    vector = Xs(words=words,stem_words=stem_words)
    ys.append(row[position_categoric])
    xs.append(vector)

  # auxiliar_functions.save_csv(y_xs, header=["y","xs"], filename=output)
  return ys,xs

def day_of_week2number(element_day):
  week = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday']
  return week.index(element_day)


def bag_words(coll=[]):
  coll_set = {}
  # bag words
  for row in coll:
    descriptions = remove_stopwords(row[3])
    words = stemming_words(descriptions)

    for i in words:
      if i in coll_set: coll_set[i] += 1
      else: coll_set[i] = 1

  return [i for i in coll_set], coll_set
