__author__ = 'mint64'

from sklearn.cluster import KMeans
from collections import Counter

import matplotlib.pyplot as plt
from matplotlib.backends.backend_pdf import PdfPages
import numpy as np
import datetime
import time
import pandas as pd


import read_file

def get_best_value(distance_list):
    x = np.mean(distance_list)
    i = 0
    test = True
    while test:
        test = (distance_list[i]*0.75 > distance_list[i+1])
        i += 1
    return i

def best_places():
    print "Load y,X and target names"
    y_all,X_all,target_names,interval = read_file.clustering_Lat_Long(input="data/new_training.csv",
                                                         hour=[2,4,6,8,10,12,14,16,18,20,22,0])

    range_n_clusters = np.array(range(100,400,50))

    print "Loop..."

    for interv in interval:

        print "\nCalculate for interval between " + interval[interv][0] + " and " + interval[interv][1]

        if X_all[interv]:

            print "\tConverting to np.array"
            y_all[interv] = np.array(y_all[interv])
            X_all[interv] = np.array(X_all[interv])

            # scipy.cluster.vq.kmeans

            print "\tCalculate distances..."
            sum_distance = []
            times = []
            for k in range_n_clusters:
                print "\t\tFor %s clusters" % str(k)
                clusterer = KMeans(n_clusters=k, random_state=10)

                print "\t\tRunning model.."
                start = datetime.datetime.now()
                startt = time.time()
                clusterer.fit_transform(X_all[interv],y_all[interv])
                stop = datetime.datetime.now()
                stopp = time.time()

                print "\t\tTime total = ", (stop-start), " seconds = ", (stopp - startt)
                sum_distance.append(clusterer.inertia_)
                times.append(stopp - startt)

            print "\tPlotting..."
            kIdx = get_best_value(sum_distance)
            sum_distance = np.array(sum_distance)

            dataframe = pd.DataFrame({"Numbers of Clusters": range_n_clusters,
                                      "Sum total distance":sum_distance,
                                      "Time running": times})
            filename = "results/clustering_elbow_rule" + "_" + interv + ".csv"
            dataframe.to_csv(filename, sep=',',index=False)

            # elbow curve
            plt.plot(range_n_clusters, sum_distance, 'b*-')
            plt.plot(range_n_clusters[kIdx], sum_distance[kIdx], marker='o', markersize=12,
                markeredgewidth=2, markeredgecolor='r', markerfacecolor='None')
            plt.grid(True)
            plt.xlabel('Number of clusters')
            plt.ylabel('Sum of squares')
            plt.title("Elbow Rule for interval between " + interval[interv][0] + " and " + interval[interv][1])

            filename = "results/clustering_elbow_rule" + "_" + interv + ".png"
            plt.savefig(filename)
            plt.cla()

        else:
            print "\t","No data for this interval"

        # for n_clusters in range_n_clusters:
        #
        #     print "\tNumber of cluster ", n_clusters
        #     clusterer = KMeans(n_clusters=n_clusters, random_state=10)
        #     clusterer.fit_transform(X_all[interv],y_all[interv])
        #     distance.append([n_clusters,clusterer.inertia_])
        #
        #     # alternative: scipy.spatial.distance.cdist
        #     D_k = [cdist(X_all[interv], cent, 'euclidean') for cent in clusterer.cluster_centers_]
        #     cIdx = [np.argmin(D,axis=1) for D in D_k]
        #     dist = [np.min(D,axis=1) for D in D_k]
        #     avgWithinSS = [sum(d)/X.shape[0] for d in dist]
        #
        #     # elbow curve
        #     plot(n_clusters, avgWithinSS, 'b*-')
        #     plot(K[kIdx], avgWithinSS[kIdx], marker='o', markersize=12,
        #         markeredgewidth=2, markeredgecolor='r', markerfacecolor='None')
        #     plt.grid(True)
        #     plt.xlabel('Number of clusters')
        #     plt.ylabel('Average within-cluster sum of squares')
        #     plt.title('Elbow for KMeans clustering')

            # filename = "results/clustering_distances" + "_" + interv + ".png",
            # plt.savefig(filename, dpi=200)

        # distance = np.array(distance)
        # s = 'NY with best positions working ' + str(n_clusters) + \
        #     ' between ' + interval[interv][0] + " and " + interval[interv][1]
        # plt.title(s)
        # plt.xlabel('Number of clusters')
        # plt.ylabel('Sum of distances of samples to their closest cluster center')
        # plt.plot(distance[:,0], distance[:,1], '--', linewidth=2)
        # plt.grid(True)
        # plt.savefig("results/clustering_distances.png", dpi=200)
        #
        # read_file.append_features_to_file('results/clustering_distances.txt',[i[0],i[1]])
        # for i in distance:
        #     read_file.append_features_to_file('results/clustering_distances.txt',[i[0],i[1]])



def best_places_per_interval():
    print "Load y,X and target names"
    y_all,X_all,target_names,interval = read_file.clustering_Lat_Long(input="data/new_training.csv",
                                                         hour=[2,4,6,8,10,12,14,16,18,20,22,0])
    interval_clusters = {
        "2_4":200,      "4_6":200,  "6_8":200,  "8_10":200, "10_12":200,
        "12_14":250,    "14_16":200,  "16_18":200,  "18_20":200,
        "20_22":200,    "22_0":200,
    }

    for interv in interval:
        print "Calculate for interval between " + interval[interv][0] + " and " + interval[interv][1]

        if y_all[interv]:

            print "\t","Converting to numpy array..."
            X_all[interv] = np.array(X_all[interv])
            y_all[interv] = np.array(y_all[interv])
            size = len(y_all[interv])

            n_clusters = interval_clusters[interv]

            print "\t","Number of cluster ", n_clusters

            # Initialize the clusterer with n_clusters value and a random generator
            # seed of 10 for reproducibility.
            clusterer = KMeans(n_clusters=n_clusters, random_state=10)
            cluster_labels = clusterer.fit_transform(X_all[interv],y_all[interv])

            print "\t", "Labeling the clusters"
            centers = clusterer.cluster_centers_
            # Draw white circles at cluster centers

            print "\t", "Get frequencies for each 'Complaint.Type'"
            most_frequency = {}
            for i in range(size):
                try:
                    num_cluster = int(clusterer.labels_[i])
                    num_target = int(y_all[interv][i])
                    if num_cluster not in most_frequency:
                        most_frequency[num_cluster] = []
                    most_frequency[num_cluster].append(num_target)
                except Exception, e:
                    if i % 10000 == 0:
                        print i, num_cluster, len(clusterer.labels_), size
                    # tests_5.append_features("errors.txt",[i,int(clusterer.labels_[i]), int(y[i]),e])

            try:
                print "\t", "Get 1 most frequencies 'Complaint.Types' for each Cluster"
                labels = []
                for i in most_frequency:
                    word_counts = Counter(most_frequency[i])
                    top_three = word_counts.most_common(3)
                    labels.append(",".join([target_names[i[0]] for i in top_three]))
            except Exception, e:
                print e

            print "\t", "Plotting..."
            plt.scatter(centers[:, 1], centers[:, 0], marker='o', c="white", alpha=1, s=200)
            for i, c in enumerate(centers):
                plt.scatter(c[1], c[0], marker='$%d$' % i, alpha=1, s=50)

            try:
                print "\t", "Labels for plot..."
                labels_filename = "results/n_clusters_" + str(n_clusters) + "_" + interv + ".csv"
                read_file.append_features_to_file(filename=labels_filename,l=["Longitude","Latitude","Labels"])
                for label, x, y in zip(labels, centers[:, 1], centers[:, 0]):
                    read_file.append_features_to_file(filename=labels_filename,l=[x,y,label])
                    # plt.annotate(
                    #     label,
                    #     xy = (x, y), xytext = (-20, 20),
                    #     textcoords = 'offset points', ha = 'right', va = 'bottom',
                    #     bbox = dict(boxstyle = 'round,pad=0.5', fc = 'yellow', alpha = 0.5),
                    #     arrowprops = dict(arrowstyle = '->', connectionstyle = 'arc3,rad=0'),
                    #     size='xx-small'
                    # )
            except Exception, e:
                print e

            plt.title("NY - " + str(n_clusters) + " services stations between " + interval[interv][0] + " and " + interval[interv][1])
            plt.xlabel('Longitude')
            plt.ylabel('Latitude')
            print "\t", "saving plot"
            plt.savefig("results/n_clusters_"+str(n_clusters)+"_"+interv+".png", dpi=200)
            plt.cla()

        else:
            print "\t","No data for this interval"

# best_places()
best_places_per_interval()

