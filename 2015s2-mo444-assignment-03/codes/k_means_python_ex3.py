import math

A1 = [0, 0, 1, 1, 0, 0, 0, 
      0, 0, 0, 1, 0, 0, 0, 
      0, 0, 0, 1, 0, 0, 0, 
      0, 0, 1, 0, 1, 0, 0, 
      0, 0, 1, 0, 1, 0, 0, 
      0, 1, 1, 1, 1, 1, 0, 
      0, 1, 0, 0, 0, 1, 0, 
      0, 1, 0, 0, 0, 1, 0, 
      1, 1, 1, 0, 1, 1, 1]

B1 = [1, 1, 1, 1, 1, 1, 0, 
      0, 1, 0, 0, 0, 0, 1, 
      0, 1, 0, 0, 0, 0, 1, 
      0, 1, 0, 0, 0, 0, 1, 
      0, 1, 1, 1, 1, 1, 0, 
      0, 1, 0, 0, 0, 0, 1, 
      0, 1, 0, 0, 0, 0, 1, 
      0, 1, 0, 0, 0, 0, 1, 
      1, 1, 1, 1, 1, 1, 0]

C1 = [0, 0, 1, 1, 1, 1, 1, 
      0, 1, 0, 0, 0, 0, 1, 
      1, 0, 0, 0, 0, 0, 0, 
      1, 0, 0, 0, 0, 0, 0, 
      1, 0, 0, 0, 0, 0, 0, 
      1, 0, 0, 0, 0, 0, 0, 
      1, 0, 0, 0, 0, 0, 0, 
      0, 1, 0, 0, 0, 0, 1, 
      0, 0, 1, 1, 1, 1, 0]

D1 = [1, 1, 1, 1, 1, 0, 0, 
      0, 1, 0, 0, 0, 1, 0, 
      0, 1, 0, 0, 0, 0, 1, 
      0, 1, 0, 0, 0, 0, 1, 
      0, 1, 0, 0, 0, 0, 1, 
      0, 1, 0, 0, 0, 0, 1, 
      0, 1, 0, 0, 0, 0, 1, 
      0, 1, 0, 0, 0, 1, 0, 
      1, 1, 1, 1, 1, 0, 0]

E1 = [1, 1, 1, 1, 1, 1, 1, 
      0, 1, 0, 0, 0, 0, 1, 
      0, 1, 0, 0, 0, 0, 0, 
      0, 1, 0, 1, 0, 0, 0, 
      0, 1, 1, 1, 0, 0, 0, 
      0, 1, 0, 1, 0, 0, 0, 
      0, 1, 0, 0, 0, 0, 0, 
      0, 1, 0, 0, 0, 0, 1, 
      1, 1, 1, 1, 1, 1, 1]

J1 = [0, 0, 0, 1, 1, 1, 1, 
      0, 0, 0, 0, 0, 1, 0, 
      0, 0, 0, 0, 0, 1, 0, 
      0, 0, 0, 0, 0, 1, 0, 
      0, 0, 0, 0, 0, 1, 0, 
      0, 0, 0, 0, 0, 1, 0, 
      0, 1, 0, 0, 0, 1, 0, 
      0, 1, 0, 0, 0, 1, 0, 
      0, 0, 1, 1, 1, 0, 0]

K1 = [1, 1, 1, 0, 0, 1, 1, 
      0, 1, 0, 0, 1, 0, 0, 
      0, 1, 0, 1, 0, 0, 0, 
      0, 1, 1, 0, 0, 0, 0, 
      0, 1, 1, 0, 0, 0, 0, 
      0, 1, 0, 1, 0, 0, 0, 
      0, 1, 0, 0, 1, 0, 0, 
      0, 1, 0, 0, 0, 1, 0, 
      1, 1, 1, 0, 0, 1, 1]

A2 = [0, 0, 0, 1, 0, 0, 0, 
      0, 0, 0, 1, 0, 0, 0, 
      0, 0, 0, 1, 0, 0, 0, 
      0, 0, 1, 0, 1, 0, 0, 
      0, 0, 1, 0, 1, 0, 0, 
      0, 1, 0, 0, 0, 1, 0, 
      0, 1, 1, 1, 1, 1, 0, 
      0, 1, 0, 0, 0, 1, 0, 
      0, 1, 0, 0, 0, 1, 0]

B2 = [1, 1, 1, 1, 1, 1, 0, 
      1, 0, 0, 0, 0, 0, 1, 
      1, 0, 0, 0, 0, 0, 1, 
      1, 0, 0, 0, 0, 0, 1, 
      1, 1, 1, 1, 1, 1, 0, 
      1, 0, 0, 0, 0, 0, 1, 
      1, 0, 0, 0, 0, 0, 1, 
      1, 0, 0, 0, 0, 0, 1, 
      1, 1, 1, 1, 1, 1, 0]

C2 = [0, 0, 1, 1, 1, 0, 0, 
      0, 1, 0, 0, 0, 1, 0, 
      1, 0, 0, 0, 0, 0, 1, 
      1, 0, 0, 0, 0, 0, 0, 
      1, 0, 0, 0, 0, 0, 0, 
      1, 0, 0, 0, 0, 0, 0, 
      1, 0, 0, 0, 0, 0, 1, 
      0, 1, 0, 0, 0, 1, 0, 
      0, 0, 1, 1, 1, 0, 0]

D2 = [1, 1, 1, 1, 1, 0, 0, 
      1, 0, 0, 0, 0, 1, 0, 
      1, 0, 0, 0, 0, 0, 1, 
      1, 0, 0, 0, 0, 0, 1, 
      1, 0, 0, 0, 0, 0, 1, 
      1, 0, 0, 0, 0, 0, 1, 
      1, 0, 0, 0, 0, 0, 1, 
      1, 0, 0, 0, 0, 1, 0, 
      1, 1, 1, 1, 1, 0, 0]

E2 = [1, 1, 1, 1, 1, 1, 1, 
      1, 0, 0, 0, 0, 0, 0, 
      1, 0, 0, 0, 0, 0, 0, 
      1, 0, 0, 0, 0, 0, 0, 
      1, 1, 1, 1, 1, 0, 0, 
      1, 0, 0, 0, 0, 0, 0, 
      1, 0, 0, 0, 0, 0, 0, 
      1, 0, 0, 0, 0, 0, 0, 
      1, 1, 1, 1, 1, 1, 1]

J2 = [0, 0, 0, 0, 0, 1, 0, 
      0, 0, 0, 0, 0, 1, 0, 
      0, 0, 0, 0, 0, 1, 0, 
      0, 0, 0, 0, 0, 1, 0, 
      0, 0, 0, 0, 0, 1, 0, 
      0, 0, 0, 0, 0, 1, 0, 
      0, 1, 0, 0, 0, 1, 0, 
      0, 1, 0, 0, 0, 1, 0, 
      0, 0, 1, 1, 1, 0, 0]

K2 = [1, 0, 0, 0, 0, 1, 0, 
      1, 0, 0, 0, 1, 0, 0, 
      1, 0, 0, 1, 0, 0, 0, 
      1, 0, 1, 0, 0, 0, 0, 
      1, 1, 0, 0, 0, 0, 0, 
      1, 0, 1, 0, 0, 0, 0, 
      1, 0, 0, 1, 0, 0, 0, 
      1, 0, 0, 0, 1, 0, 0, 
      1, 0, 0, 0, 0, 1, 0]

A3 = [0, 0, 0, 1, 0, 0, 0, 
      0, 0, 0, 1, 0, 0, 0, 
      0, 0, 1, 0, 1, 0, 0, 
      0, 0, 1, 0, 1, 0, 0, 
      0, 1, 0, 0, 0, 1, 0, 
      0, 1, 1, 1, 1, 1, 0, 
      1, 0, 0, 0, 0, 0, 1, 
      1, 0, 0, 0, 0, 0, 1, 
      1, 1, 0, 0, 0, 1, 1]

B3 = [1, 1, 1, 1, 1, 1, 0, 
      0, 1, 0, 0, 0, 0, 1, 
      0, 1, 0, 0, 0, 0, 1, 
      0, 1, 1, 1, 1, 1, 0, 
      0, 1, 0, 0, 0, 0, 1, 
      0, 1, 0, 0, 0, 0, 1, 
      0, 1, 0, 0, 0, 0, 1, 
      0, 1, 0, 0, 0, 0, 1, 
      1, 1, 1, 1, 1, 1, 0]

C3 = [0, 0, 1, 1, 1, 0, 1, 
      0, 1, 0, 0, 0, 1, 1, 
      1, 0, 0, 0, 0, 0, 1, 
      1, 0, 0, 0, 0, 0, 0, 
      1, 0, 0, 0, 0, 0, 0, 
      1, 0, 0, 0, 0, 0, 0, 
      1, 0, 0, 0, 0, 0, 1, 
      0, 1, 0, 0, 0, 1, 0, 
      0, 0, 1, 1, 1, 0, 0]

D3 = [1, 1, 1, 1, 0, 0, 0, 
      0, 1, 0, 0, 1, 0, 0, 
      0, 1, 0, 0, 0, 1, 0, 
      0, 1, 0, 0, 0, 1, 0, 
      0, 1, 0, 0, 0, 1, 0, 
      0, 1, 0, 0, 0, 1, 0, 
      0, 1, 0, 0, 0, 1, 0, 
      0, 1, 0, 0, 1, 0, 0, 
      1, 1, 1, 1, 0, 0, 0]

E3 = [1, 1, 1, 1, 1, 1, 1, 
      0, 1, 0, 0, 0, 0, 1, 
      0, 1, 0, 0, 1, 0, 0, 
      0, 1, 1, 1, 1, 0, 0, 
      0, 1, 0, 0, 1, 0, 0, 
      0, 1, 0, 0, 0, 0, 0, 
      0, 1, 0, 0, 0, 0, 0, 
      0, 1, 0, 0, 0, 0, 1, 
      1, 1, 1, 1, 1, 1, 1]

J3 = [0, 0, 0, 0, 1, 1, 1, 
      0, 0, 0, 0, 0, 1, 0, 
      0, 0, 0, 0, 0, 1, 0, 
      0, 0, 0, 0, 0, 1, 0, 
      0, 0, 0, 0, 0, 1, 0, 
      0, 0, 0, 0, 0, 1, 0, 
      0, 0, 0, 0, 0, 1, 0, 
      0, 1, 0, 0, 0, 1, 0, 
      0, 0, 1, 1, 1, 0, 0]

K3 = [1, 1, 1, 0, 0, 1, 1, 
      0, 1, 0, 0, 0, 1, 0, 
      0, 1, 0, 0, 1, 0, 0, 
      0, 1, 0, 1, 0, 0, 0, 
      0, 1, 1, 0, 0, 0, 0, 
      0, 1, 0, 1, 0, 0, 0, 
      0, 1, 0, 0, 1, 0, 0, 
      0, 1, 0, 0, 0, 1, 0, 
      1, 1, 1, 0, 0, 1, 1]

names = ["A", "B", "C", "D", "E", "J", "K"]

NUMBER_OF_CLUSTERS = 7; # Seven letters among the samples.
NUM_CENTROIDS = 4; # One for each corner (NE, SE, SW, NW).
TEST_SAMPLES = 21;
SAMPLE_WIDTH = 7;
SAMPLE_HEIGHT = 9;
BIG_NUMBER = math.pow(10, 10); # some big number that's sure to be larger than our data range.
MAX_ITERATIONS = 20 # Keeps algorithm from looping infinitely when centroids oscillate.

pointsFound = []
dataSet = []
centroids = []
pattern = []
clusters = []

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

def initialize_arrays():
    pattern.append(A1)
    pattern.append(B1)
    pattern.append(C1)
    pattern.append(D1)
    pattern.append(E1)
    pattern.append(J1)
    pattern.append(K1)
    pattern.append(A2)
    pattern.append(B2)
    pattern.append(C2)
    pattern.append(D2)
    pattern.append(E2)
    pattern.append(J2)
    pattern.append(K2)
    pattern.append(A3)
    pattern.append(B3)
    pattern.append(C3)
    pattern.append(D3)
    pattern.append(E3)
    pattern.append(J3)
    pattern.append(K3)

    # I want to collect the two values (x and y) of each centroid:
    for i in range(NUMBER_OF_CLUSTERS):
        clusters.append([0.0] * NUM_CENTROIDS * 2)

    return

def get_distance(dataPointX, dataPointY, centroidX, centroidY):
    # Calculate Euclidean distance.
    return math.sqrt(math.pow((centroidY - dataPointY), 2) + math.pow((centroidX - dataPointX), 2))

def initialize_new_cycle():
    pointsFound[:] = [] # Clears the list.  Splice into list [] (0 elements) at the location [:] (all indexes from start to finish)
    dataSet[:] = []
    centroids[:] = []

    centroids.append(Centroid(1.0, 1.0)) # NW corner.
    centroids.append(Centroid(5.0, 1.0)) # NE.
    centroids.append(Centroid(1.0, 7.0)) # SW.
    centroids.append(Centroid(5.0, 7.0)) # SE.
    return

def find_coordinates(patternNum):
    z = 0
    # Find the coordinates of each "1" that makes out the letter in each sample's 7x9 grid.
    for y in range(SAMPLE_HEIGHT):
        for x in range(SAMPLE_WIDTH):
            if(pattern[patternNum][z] > 0):
                pointsFound.append(DataPoint(x, y))
            z += 1

    return

def recalculate_centroids():
    for j in range(NUMBER_OF_CLUSTERS):
        totalX = 0.0
        totalY = 0.0
        totalInCluster = 0.0

        for k in range(len(dataSet)):
            if(dataSet[k].get_cluster() == j):
                totalX += float(dataSet[k].get_x())
                totalY += float(dataSet[k].get_y())
                totalInCluster += 1.0

        if(totalInCluster > 0):
            centroids[j].set_x(totalX / totalInCluster)
            centroids[j].set_y(totalY / totalInCluster)

    return

def initialize_datapoints():
    # Add in new data, one at a time, recalculating centroids with each new one.
    count = len(pointsFound)
    for i in range(count):
        newPoint = pointsFound[i]
        bestMinimum = BIG_NUMBER
        currentCluster = 0

        for j in range(NUM_CENTROIDS):
            distance = get_distance(newPoint.get_x(), newPoint.get_y(), centroids[j].get_x(), centroids[j].get_y())
            if(distance < bestMinimum):
                bestMinimum = distance
                currentCluster = j

        newPoint.set_cluster(currentCluster)

        dataSet.append(newPoint)

        recalculate_centroids()

    return

def update_clusters():
    isStillMoving = False

    count = len(dataSet)
    for i in range(count):
        bestMinimum = BIG_NUMBER
        currentCluster = 0

        for j in range(NUM_CENTROIDS):
            distance = get_distance(dataSet[i].get_x(), dataSet[i].get_y(), centroids[j].get_x(), centroids[j].get_y())
            if(distance < bestMinimum):
                bestMinimum = distance
                currentCluster = j

        if(dataSet[i].get_cluster() is None or dataSet[i].get_cluster() != currentCluster):
            dataSet[i].set_cluster(currentCluster)
            isStillMoving = True

    return isStillMoving

def perform_kmeans():
    isStillMoving = True
    count = 0

    initialize_datapoints()

    while isStillMoving and count < MAX_ITERATIONS:
        recalculate_centroids()
        isStillMoving = update_clusters()
        count += 1

    return

def get_minimum(anArray):
    minimum = 0
    foundNewMinimum = False
    done = False
    
    while not done:
        foundNewMinimum = False
        for i in range(NUMBER_OF_CLUSTERS):
            if anArray[i] < anArray[minimum]:
                minimum = i
                foundNewMinimum = True
        
        if not foundNewMinimum:
            done = True
    
    return minimum

def train():
    clusterID = 0
    isFirstCycle = True; # No point in averaging a single number with itself.

    for i in range(TEST_SAMPLES):
        initialize_new_cycle()
        find_coordinates(i)
        perform_kmeans()

        m = 0
        for j in range(NUM_CENTROIDS):
            # The x and y coordinates of each centroid are collected, then averaged with previous coordinates.
            if isFirstCycle:
                # Average with previous x coordinates of this centroid.
                clusters[clusterID][m] = (clusters[clusterID][m] + centroids[j].get_x()) / 2.0
            else:
                clusters[clusterID][m] = centroids[j].get_x()

            m += 1

            if isFirstCycle:
                # Average with previous y coordinates of this centroid.
                clusters[clusterID][m] = (clusters[clusterID][m] + centroids[j].get_y()) / 2.0
            else:
                clusters[clusterID][m] = centroids[j].get_y()

            m += 1

        clusterID += 1
        # Seven letters of each font are presented in order A, B, C, D, E, J, K.
        if clusterID >= NUMBER_OF_CLUSTERS:
            clusterID = 0
            isFirstCycle = False

    return

def test():
    for z in range(TEST_SAMPLES):
        initialize_new_cycle()
        find_coordinates(z)
        perform_kmeans()
        
        predictions = [0.0] * NUMBER_OF_CLUSTERS
        
        for j in range(NUMBER_OF_CLUSTERS):
            k = 0
            totalDistance = 0.0
            for i in range(NUM_CENTROIDS):
                totalDistance += math.fabs(centroids[i].get_x() - clusters[j][k])
                k += 1
                totalDistance += math.fabs(centroids[i].get_y() - clusters[j][k])
                k += 1
            
            predictions[j] = totalDistance
        
        print("Expected: ", names[z % NUMBER_OF_CLUSTERS], ", Actual: ", names[get_minimum(predictions)])
        
    return


if __name__ == '__main__':
    initialize_arrays()
    train()
    test()