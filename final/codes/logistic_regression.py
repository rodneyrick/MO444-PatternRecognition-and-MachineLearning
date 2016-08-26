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
from sklearn.linear_model import LogisticRegression
from sklearn.pipeline import Pipeline

print "Running model...\n"

for interv in interval:

    print "Calculate for interval between " + interval[interv][0] + " and " + interval[interv][1]

    if y_train[interv]:

        print "\t","Converting to numpy array..."
        X_train[interv] = np.array(X_train[interv])
        X_test[interv] = np.array(X_test[interv])
        y_train[interv] = np.array(y_train[interv])
        y_test[interv] = np.array(y_test[interv])
        size = len(y_train[interv])

        print "\t", "Model compute for size = " + str(size)
        print "\t", "computing model..."
        model = Pipeline([('vect', CountVectorizer()),
                  ('tfidf', TfidfTransformer()),
                  ('clf', LogisticRegression(solver='sag', tol=1e-1, C=1.e4 / X_train[interv].shape[0]))
                ])
        model.fit(X_train[interv], y_train[interv])

        print "\t", "predicting..."
        # make predictions
        predicted = model.predict(y_train[interv])
        # summarize the fit of the model

        parameters = {
            "filename_model_results":"results/LogisticRegression" + "_" + interv + ".txt",
            "filename_confusion_matrix":"results/LogisticRegression" + "_" + interv + "_Confusion_Matrix.csv",
            "model_interval" : [interval[interv][0],interval[interv][1]],
            "model_type":"Logistic Regression Model (SAG)",
            "model":model,
            "expected":y_test[interv],
            "predicted":predicted,
            "target_names":target_names}

        metrics.calc_metrics(parameters)

    else:
        print "\t","No data for this interval"