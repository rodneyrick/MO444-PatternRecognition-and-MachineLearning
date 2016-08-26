#
import matplotlib.pyplot as plt
import numpy as np

range_n_clusters = [1,2,3,4,5,6]
sum_distance = [7.4735534281, 4.80869421, 3.525288079, 2.794280153, 2.3014718041, 1.9495966052]

def teste(range_n_clusters,sum_distance):
    range_n_clusters = np.array(range_n_clusters)
    sum_distance = np.array(sum_distance)
    for i in range(len( sum_distance)-1):
        print sum_distance[i]*0.6, sum_distance[i+1], (sum_distance[i]*0.75 > sum_distance[i+1])

sum_distance = [7.4735534281, 4.80869421, 3.525288079, 2.794280153, 2.3014718041, 1.9495966052]
teste(range_n_clusters,sum_distance)

print
sum_distance = [2.3818526386,1.5158964406,1.0994621474,0.8656075488,0.7062344794,0.597039253]
teste(range_n_clusters,sum_distance)

print
sum_distance = [4.0108949201, 2.5625153963, 1.8671530875, 1.4721768248, 1.2042527245, 1.0219407251]
teste(range_n_clusters,sum_distance)



#
# plt.plot(range_n_clusters, sum_distance,'b*-')
# plt.plot(range_n_clusters[1], sum_distance[1], marker='o', markersize=12,
#     markeredgewidth=2, markeredgecolor='r', markerfacecolor='None')
# plt.grid(True)
# plt.xlabel('Number of clusters')
# plt.ylabel('Sum of squares')
# plt.title("Elbow Rule for interval between")
#
# filename = "results/clustering_elbow_rule.png"
# plt.savefig(filename, dpi=200)
#
# import pandas as pd
# dataframe = pd.DataFrame({"Numbers of Clusters": range_n_clusters,
#                           "Sum total distance":sum_distance})
# filename = "results/test.csv"
# dataframe.to_csv(filename, sep=',',index=False)

# import time
# start = time.time()
#
# time.sleep(10)  # or do something more productive
#
# done = time.time()
# elapsed = done - start
# print(elapsed)