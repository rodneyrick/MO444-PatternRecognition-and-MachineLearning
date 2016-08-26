
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
from sklearn.tree import DecisionTreeClassifier
from sklearn.pipeline import Pipeline

model = Pipeline([('vect', CountVectorizer()),
                  ('tfidf', TfidfTransformer()),
                  ('clf', DecisionTreeClassifier(random_state=0,criterion="entropy",max_features="log2"))
                ])


print "Running model...\n"

for interv in interval:
    print "\nCalculate for interval between " + interval[interv][0] + " and " + interval[interv][1]

    if y_train[interv]:
        print "\t","Converting to numpy array..."
        X_train[interv] = np.array(X_train[interv])
        X_test[interv] = np.array(X_test[interv])
        y_train[interv] = np.array(y_train[interv])
        y_test[interv] = np.array(y_test[interv])
        size = len(y_train[interv])

        print "\t", "Model compute for size = " + str(size)
        print "\t", "computing model..."
        model.fit(X_train[interv], y_train[interv])

        # # save model
        # filename_model = "models/DecisionTreeClassifier_" + interv + ".pkl"
        # joblib.dump(model, filename_model)

        print "\t", "predicting..."
        # make predictions
        predicted = model.predict(X_test[interv])
        parameters = {
            "filename_model_results":"results/DecisionTreeClassifier" + "_" + interv + ".txt",
            "filename_confusion_matrix":None,
            "model_interval" : [interval[interv][0],interval[interv][1]],
            "model_type":"DecisionTreeClassifier Model",
            "model":model,
            "expected":y_test[interv],
            "predicted":predicted,
            "target_names":target_names}

        metrics.calc_metrics(parameters)

    else:
        print "\t","No data for this interval"