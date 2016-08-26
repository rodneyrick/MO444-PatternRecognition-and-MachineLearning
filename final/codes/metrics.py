__author__ = 'mint64'

from sklearn import metrics
import numpy as np
import pandas as pd

def calc_metrics(parameters = {
    "filename_model_results":"",
    "filename_confusion_matrix":"",
    "model_interval" : ["",""],
    "model_type":"",
    "model":None,
    "expected":"",
    "predicted":"",
    "target_names":[]},
    timing=None,
    is_classification = True):
    filename = parameters["filename_model_results"] #"results/SVM" + "_" + interv + ".txt"
    print "\t", "saving output to " + filename
    with open(filename, "w") as text_file:
        text_file.write("Model for interval " + parameters["model_interval"][0] + " and " + parameters["model_interval"][1])
        text_file.write("\n")

        text_file.write(parameters["model_type"] + ":\n")
        text_file.write(str(parameters["model"]))
        text_file.write("\n\n")

        print "\t", "saving time execution"
        text_file.write("time running = ")
        text_file.write(str(timing))
        text_file.write("\n\n")

        print "\t", "Accuracy"
        text_file.write("Accuracy = ")
        text_file.write(str(metrics.accuracy_score(parameters["expected"], parameters["predicted"])))
        text_file.write("\n\n")

        if is_classification:
            print "\t", "Classification Report"
            text_file.write("Classification Report\n")
            text_file.write(metrics.classification_report(parameters["expected"], parameters["predicted"],target_names=parameters["target_names"]))
            text_file.write("\n\n")
            text_file.close()

        if parameters["filename_confusion_matrix"]:
            print "\t", "Confusion Matrix"
            # text_file.write("Confusion Matrix")
            # text_file.write("\n")
            y_expected = [parameters["target_names"][i] for i in parameters["expected"]]
            y_predicted = [parameters["target_names"][i] for i in parameters["predicted"]]
            # s = str(metrics.confusion_matrix(y_expected, y_predicted,labels=target_names))

            y_actu = pd.Series(y_expected, name='Actual')
            y_pred = pd.Series(y_predicted, name='Predicted')
            df_confusion = pd.crosstab(y_actu, y_pred, rownames=['Actual'], colnames=['Predicted'], margins=True)

            filename = parameters["filename_confusion_matrix"] #"results/SVM" + "_" + interv + "_Confusion_Matrix.csv"
            df_confusion.to_csv(filename, sep=',')
            # text_file.write(str(df_confusion))