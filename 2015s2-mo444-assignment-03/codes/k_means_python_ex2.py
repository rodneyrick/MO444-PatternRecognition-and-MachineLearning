import random
import math

NUM_CLUSTERS = 5
TOTAL_DATA = 100
BIG_NUMBER = math.pow(10, 10)
MIN_COORDINATE = 0.0
MAX_COORDINATE = 500.0
MAX_ITERATIONS = 20 # Keeps algorithm from looping infinitely when centroids oscillate.

data = []
centroids = []

class DataPoint:
    def __init__(self, x, y):
        self.x = x
        self.y = y
    
    def set_x(self, x):
        self.x = x
    
    def get_x(self):
        return self.x
    
    def set_y(self, y):
        self.y = y
    
    def get_y(self):
        return self.y
    
    def set_cluster(self, clusterNumber):
        self.clusterNumber = clusterNumber
    
    def get_cluster(self):
        return self.clusterNumber

class Centroid:
    def __init__(self, x, y):
        self.x = x
        self.y = y
    
    def set_x(self, x):
        self.x = x
    
    def get_x(self):
        return self.x
    
    def set_y(self, y):
        self.y = y
    
    def get_y(self):
        return self.y

def get_distance(dataPointX, dataPointY, centroidX, centroidY):
    # Calculate Euclidean distance.
    return math.sqrt(math.pow((centroidY - dataPointY), 2) + math.pow((centroidX - dataPointX), 2))

def initialize_centroids():
    print("Centroids initialized at:")
    
    # initialize centroids randomly 
    for i in range(NUM_CLUSTERS):
        xValue = random.randrange(MIN_COORDINATE, MAX_COORDINATE)
        yValue = random.randrange(MIN_COORDINATE, MAX_COORDINATE)
        centroids.append(Centroid(xValue, yValue))
        print("(", centroids[i].get_x(), ", ", centroids[i].get_y(), ")")
    
    print()
    return

def recalculate_centroids():
    for j in range(NUM_CLUSTERS):
        totalX = 0.0
        totalY = 0.0
        totalInCluster = 0.0
        
        for k in range(len(data)):
            if(data[k].get_cluster() == j):
                totalX += float(data[k].get_x())
                totalY += float(data[k].get_y())
                totalInCluster += 1.0
        
        if(totalInCluster > 0):
            centroids[j].set_x(totalX / totalInCluster)
            centroids[j].set_y(totalY / totalInCluster)
    
    return

def initialize_datapoints():
    # Add in new data, one at a time, recalculating centroids with each new one.
    for i in range(TOTAL_DATA):
        xValue = random.randrange(MIN_COORDINATE, MAX_COORDINATE)
        yValue = random.randrange(MIN_COORDINATE, MAX_COORDINATE)
        newPoint = DataPoint(xValue, yValue)
        
        bestMinimum = BIG_NUMBER
        currentCluster = 0
        
        for j in range(NUM_CLUSTERS):
            distance = get_distance(xValue, yValue, centroids[j].get_x(), centroids[j].get_y())
            if(distance < bestMinimum):
                bestMinimum = distance
                currentCluster = j
        
        newPoint.set_cluster(currentCluster)
        
        data.append(newPoint)
        
        recalculate_centroids()
    
    return

def update_clusters():
    isStillMoving = 0
    
    for i in range(TOTAL_DATA):
        bestMinimum = BIG_NUMBER
        currentCluster = 0
        
        for j in range(NUM_CLUSTERS):
            distance = get_distance(data[i].get_x(), data[i].get_y(), centroids[j].get_x(), centroids[j].get_y())
            if(distance < bestMinimum):
                bestMinimum = distance
                currentCluster = j
        
        if(data[i].get_cluster() is None or data[i].get_cluster() != currentCluster):
            data[i].set_cluster(currentCluster)
            isStillMoving = 1
    
    return isStillMoving

def perform_kmeans():
    isStillMoving = 1
    count = 0
    
    initialize_centroids()
    
    initialize_datapoints()
    
    while isStillMoving and count < MAX_ITERATIONS:
        recalculate_centroids()
        isStillMoving = update_clusters()
        count += 1
    
    return

def print_results():
    for i in range(NUM_CLUSTERS):
        print("Cluster ", i, " includes:")
        for j in range(TOTAL_DATA):
            if(data[j].get_cluster() == i):
                print("(", data[j].get_x(), ", ", data[j].get_y(), ")")
        print()
    
    print("Centroids finalized at: ")
    for i in range(NUM_CLUSTERS):
        print("(", math.floor(centroids[i].get_x()), ", ", math.floor(centroids[i].get_y()), ")")
    
    return

perform_kmeans()
print_results()
