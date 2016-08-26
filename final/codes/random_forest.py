
import read_file

print "selecting traning data"
y_train,X_train,target_names,interval = read_file.read_rows_per_hour_with_text(input="data/new_training.csv",
                                                                           hour=[2,4,6,8,10,12,14,16,18,20,22,0])

print "\nselecting testing data"
y_test,X_test,target_names_test,interval_test = read_file.read_rows_per_hour_with_text(input="data/new_testing.csv",
                                                                                               hour=[2,4,6,8,10,12,14,16,18,20,22,0])

import metrics
import numpy as np
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.feature_extraction.text import TfidfTransformer
from sklearn.ensemble import RandomForestClassifier
from sklearn.pipeline import Pipeline
import datetime

model = Pipeline([('vect', CountVectorizer()),
                  ('tfidf', TfidfTransformer()),
                  ('clf', RandomForestClassifier(n_estimators=len(target_names),
                                                 criterion='entropy'))])

print "Running model...\n"

for interv in interval:
    print "\nCalculate for interval between " + interval[interv][0] + " and " + interval[interv][1]

    if y_train[interv]:
        print "\t","Converting to numpy array..."
        X_train[interv] = np.array(X_train[interv])
        X_test[interv] = np.array(X_test[interv])
        y_train[interv] = np.array(y_train[interv])
        y_test[interv] = np.array(y_test[interv])
        size = len(y_test[interv])

        print "\t", "Model compute for size = " + str(size)
        print "\t", "computing model..."
        start = datetime.datetime.now()
        text_clf = model.fit(X_train[interv], y_train[interv])
        stop = datetime.datetime.now()
        final_time = (stop-start)

        print "\t", "Running = ", final_time

        print "\t", "predicting..."
        predicted = text_clf.predict(y_test[interv])

        parameters = {
            "filename_model_results":"results/RandomForest" + "_" + interv + ".txt",
            "filename_confusion_matrix":None,
            "model_interval" : [interval[interv][0],interval[interv][1]],
            "model_type":"RandomForest Model",
            "model":text_clf,
            "expected":y_test[interv],
            "predicted":predicted,
            "target_names":target_names}

        metrics.calc_metrics(parameters, final_time)

    else:
        print "\t","No data for this interval"