import read_file
import metrics

print "selecting traning data"
# tests_5.unbalancing(input="results/training.csv",
#                 output="results/new_training.csv",
#                 max_per_type=10000)

y_all,X_all,target_names,interval = read_file.read_rows_per_hour()

print "selecting testing data"
# tests_5.unbalancing(input="results/testing.csv",
#                 output="results/new_testing.csv",
#                 max_per_type=500)
y_all_test,X_all_test,target_names_test,interval_test = read_file.read_rows_per_hour()

from sklearn.multiclass import OneVsRestClassifier
from sklearn.svm import LinearSVC
import numpy as np

print "Running model...\n"
model = OneVsRestClassifier(LinearSVC(random_state=0))

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

from sklearn import datasets

iris = datasets.load_iris()
X, y = iris.data, iris.target
