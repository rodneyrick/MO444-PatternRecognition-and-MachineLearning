__author__ = 'mint64'


import read_file
import metrics

print "\nSelecting traning data"
# tests_5.unbalancing(input="results/training.csv",
#                 output="results/new_training.csv",
#                 max_per_type=10000)

y_all,X_all,target_names,interval = read_file.read_rows_per_hour(input="data/new_training.csv")

print "\nSelecting testing data"
# tests_5.unbalancing(input="results/testing.csv",
#                 output="results/new_testing.csv",
#                 max_per_type=500)
y_all_test,X_all_test,target_names_test,interval_test = read_file.read_rows_per_hour(input="data/new_testing.csv")

from sklearn.svm import SVC
import numpy as np

print "Running model...\n"
model = SVC(decision_function_shape="ovr")

for interv in interval:
    print "Calculate for interval between " + interval[interv][0] + " and " + interval[interv][1]

    print "\t","Converting to numpy array..."

    X_all[interv] = np.array(X_all[interv])
    X_all_test[interv] = np.array(X_all_test[interv])
    y_all[interv] = np.array(y_all[interv])
    y_all_test[interv] = np.array(y_all_test[interv])
    size = len(y_all[interv])

    print "\t", "Model compute for size = " + str(size)
    print "\t", "computing model..."
    model.fit(X_all[interv], y_all[interv])

    print "\t", "predicting..."
    expected = y_all_test[interv]
    predicted = model.predict(X_all_test[interv])

    parameters = {
        "filename_model_results":"results/SVM" + "_" + interv + ".txt",
        "filename_confusion_matrix":"results/SVM" + "_" + interv + "_Confusion_Matrix.csv",
        "model_interval" : [interval[interv][0],interval[interv][1]],
        "model_type":"SVM Model",
        "model":model,
        "expected":y_all_test[interv],
        "predicted":predicted,
        "target_names":target_names}

    metrics.calc_metrics(parameters)