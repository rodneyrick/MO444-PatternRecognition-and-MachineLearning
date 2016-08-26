
import csv
from datetime import datetime

def get_interval(interval={}, c=0):
    FMT = '%H:%M'
    mindelta = datetime.strptime("0:00", FMT) - datetime.strptime("0:00", FMT)
    for k,v in interval.items():
        tdelta_1 = datetime.strptime(v[1], FMT) - datetime.strptime(v[0], FMT)
        tdelta_2 = datetime.strptime(c, FMT) - datetime.strptime(v[0], FMT)
        if tdelta_2 < tdelta_1 and tdelta_2 > mindelta:
            return k
    return "20_2"

def SVM_read_rows_per_hour(input="results/new_training.csv",hour=[8,14,20,2]):
    reader = csv.reader(open(input, "r"), delimiter=",")
    y = {}
    X = {}
    interval = {}
    size = len(hour)
    for i in range(size):
        tmp = ""
        interv = None
        if i < (size-1):
            init = str(hour[i])
            final = str(hour[i+1])
            tmp = init + '_' + final
            interv = [init +':00', final +':00']
        else:
            init = str(hour[i])
            final = str(hour[0])
            tmp = init + '_' + final
            interv = [init +':00', final +':00']
        X[tmp] = []
        y[tmp] = []
        interval[tmp] = interv
    target_names = []
    idx = 0
    max_print = 0
    for row in reader:
        if idx > 10000: break
        if idx > 0:

            if idx % 10000 == 0:
                if max_print == 25:
                    print idx
                    max_print = 0
                else:
                    print idx,
                    max_print += 1

            if row[4] not in target_names:
                target_names.append(row[4])
            t = [
                # row[0], # "num.Complaint.Type"
                # row[1], # "Created.Date",
                # row[2], # "Agency",
                # row[3], # "Agency.Name",
                # row[4], # "Complaint.Type",
                # row[5], # "Descriptor",
                # row[6], # "Location.Type",
                # row[7], # "Incident.Zip",
                # row[8], # "Incident.Address",
                # row[9], # "Street.Name",
                # row[10], # "Cross.Street.1",
                # row[11], # "Cross.Street.2",
                # row[12], # "Address.Type",
                # row[13], # "City",
                # row[14], # "Borough",
                # float(row[15]), # "Latitude",
                # float(row[16]), # "Longitude",
                # row[17], # "weekday",
                # row[18], # "time",
                # row[19], # "dates",
                # int(row[20]), # "day",
                # int(row[21]), # "month",
                # int(row[22]), # "year",
                # int(row[23]), # "minute",
                # int(row[24]), # "hour",
                # int(row[25]), # "week_num",
                float(row[26]), # "pca_Latitude",
                float(row[27]), # "pca_Longitude",
                float(row[28]), # "pca_minute",
                float(row[29]), # "pca_hour",
                float(row[30]), # "pca_week_num",
                float(row[31]), # "skewness",
                float(row[32]), # "kurtosis",
                float(row[33]), # "avg",
                float(row[34]), # "minimun",
                float(row[35]) # "maximun"
            ]
            # print row[24]
            interv = get_interval(interval=interval,c=row[18]) # "hour",
            y[interv].append(int(row[0]))
            X[interv].append(t)
        idx += 1
    return y,X,target_names, interval


y_all,X_all,target_names,interval = SVM_read_rows_per_hour()
y_all_test,X_all_test,target_names_test,interval_test = SVM_read_rows_per_hour(input="results/new_testing.csv")

from sklearn import metrics
from sklearn.naive_bayes import MultinomialNB
import numpy as np
import pandas as pd

for interv in interval:
    print "Calculate for interval between " + interval[interv][0] + " and " + interval[interv][1]

    print "\t","Converting to numpy array..."

    if not y_all[interv] and y_all_test[interv]: print "Nothing\n\n"
    else:
        X_all[interv] = np.array(X_all[interv])
        X_all_test[interv] = np.array(X_all_test[interv])
        y_all[interv] = np.array(y_all[interv])
        y_all_test[interv] = np.array(y_all_test[interv])
        size = len(y_all[interv])

        model = MultinomialNB()
        model.fit(X_all[interv], y_all[interv])

        print "\t", "predicting..."
        # make predictions
        expected = y_all_test[interv]
        predicted = model.predict(X_all_test[interv])
        # summarize the fit of the model

        filename = "results/MultinomialNB" + "_" + interv + ".txt"
        print "\t", "saving output to " + filename
        with open(filename, "w") as text_file:
            text_file.write("Model for interval " + interval[interv][0] + " and " + interval[interv][1])
            text_file.write("\n")

            text_file.write("MultinomialNB Model:\n")
            text_file.write(str(model))
            text_file.write("\n\n")

            print "\t", "Accuracy"
            text_file.write("Accuracy = ")
            text_file.write(str(metrics.accuracy_score(expected, predicted)))
            text_file.write("\n\n")

            print "\t", "Classification Report"
            text_file.write("Classification Report\n")
            text_file.write(metrics.classification_report(expected, predicted,target_names=target_names))
            text_file.write("\n\n")
            text_file.close()

            print "\t", "Confusion Matrix"
            # text_file.write("Confusion Matrix")
            # text_file.write("\n")
            y_expected = [target_names[i] for i in expected]
            y_predicted = [target_names[i] for i in predicted]
            # s = str(metrics.confusion_matrix(y_expected, y_predicted,labels=target_names))

            y_actu = pd.Series(y_expected, name='Actual')
            y_pred = pd.Series(y_predicted, name='Predicted')
            df_confusion = pd.crosstab(y_actu, y_pred, rownames=['Actual'], colnames=['Predicted'], margins=True)

            filename = "results/MultinomialNB" + "_" + interv + "_Confusion_Matrix.csv"
            df_confusion.to_csv(filename, sep=',')
            # text_file.write(str(df_confusion))





























































