__author__ = 'mint64'

import pandas as pd
import re
from nltk.corpus import stopwords # Import the stop word list
from nltk.stem.snowball import SnowballStemmer

stemmer = SnowballStemmer("english")
stops = set(stopwords.words("english"))
def words(descriptor):
    letters_only = re.sub("[^a-zA-Z]", " ", descriptor)
    ws = letters_only.lower().split()
    output = [stemmer.stem(w) for w in ws if not w in stops]
    return output

def complete_features(objective, matrix):
    objective = list(objective)
    size = len(matrix)
    s = len(objective)
    for i in range(size):
        tmp = [0] * s
        for w in matrix[i]:
            for pos in range(s):
                if w == objective[pos]: tmp[pos] = 1
        matrix[i] = tmp
    return matrix

def run(filename="trainning.csv", nrows=10, isPureTraget=True, is_number = True):
    train = pd.read_csv(filename, header=0, nrows=nrows,delimiter=",", quoting=0)
    size = len(train['Descriptor'])
    targets = set()
    targets_dict = {}
    X = []
    y = []
    all_words = set()
    max_number_class = 0
    for i in range(size):
        if (i % 10000 == 0): print i
        if type(train['Descriptor'][i]) is str and type(train['Complaint.Type'][i]) is str:
            ws = words(train['Descriptor'][i])
            X.append(ws)
            all_words.update(ws)

            target = train['Complaint.Type'][i]
            targets.add(target)
            if target not in targets_dict:
                targets_dict[target] = max_number_class
                max_number_class += 1

            if is_number: y.append(targets_dict[target])
            else: y.append([target])

    if not isPureTraget: y = complete_features(targets, y)
    X = complete_features(all_words, X)
    target_names = [k for k in targets_dict]
    return y,X, target_names, list(all_words), targets_dict

y,X, target_names, feature_names, targets_dict = run("trainning.csv",nrows=500000)

s = len(y)
with open("results/training.csv", "w") as text_file:
    for i in range(s):
        if (i % 10000 == 0): print i
        X[i].insert(0, y[i])
        X[i].insert(0, target_names[y[i]])
        # t = ",".join()
        # print str(X[i])
        t = ""
        for j in X[i]:
            t += str(j) + ","
        t = t[:-1]
        t += "\n"
        text_file.write(t)