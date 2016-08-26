import read_file

print "selecting traning data"
y_train,X_train,target_names,interval = read_file.read_rows_per_hour_with_text(input="data/new_training.csv",
                                                                           hour=[2,4,6,8,10,12,14,16,18,20,22,0])

print "\nselecting testing data"
y_test,X_test,target_names_test,interval_test = read_file.read_rows_per_hour_with_text(input="data/new_testing.csv",
                                                                                               hour=[2,4,6,8,10,12,14,16,18,20,22,0])

import metrics
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.feature_extraction.text import TfidfTransformer
from sklearn.naive_bayes import MultinomialNB
from sklearn.pipeline import Pipeline

model = Pipeline([('vect', CountVectorizer()),
                     ('tfidf', TfidfTransformer()),
                     ('clf', MultinomialNB())
                    ])

for interv in interval:
    print "\nCalculate for interval between " + interval[interv][0] + " and " + interval[interv][1]

    print "\t","Converting to numpy array..."

    if y_train[interv]:

        model = model.fit(X_train[interv], y_train[interv])
        predicted = model.predict(X_test[interv])

        parameters = {
            "filename_model_results":"results/NaiveBayes_Pipeline" + "_" + interv + ".txt",
            "filename_confusion_matrix":None,
            "model_interval" : [interval[interv][0],interval[interv][1]],
            "model_type":"NaiveBayes_Pipeline Model",
            "model":model,
            "expected":y_test[interv],
            "predicted":predicted,
            "target_names":target_names}

        metrics.calc_metrics(parameters)

    else:
        print "\t","No data for this interval"