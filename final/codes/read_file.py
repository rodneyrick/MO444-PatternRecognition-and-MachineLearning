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
# float(row[26]), # "pca_Latitude",
# float(row[27]), # "pca_Longitude",
# float(row[28]), # "pca_minute",
# float(row[29]), # "pca_hour",
# float(row[30]), # "pca_week_num",
# float(row[31]), # "skewness",
# float(row[32]), # "kurtosis",
# float(row[33]), # "avg",
# float(row[34]), # "minimun",
# float(row[35]) # "maximun"

def read_row(row=[],index=[]):
    t = []
    for i in index:
        if i in [15,16,25, 26, 27, 28, 29, 30, 31, 32, 33, 34]:
            t.append(float(row[i]))
        elif i in [0,19, 20, 21, 22, 23, 24]:
            t.append(int(row[i]))
        else:
            t.append(row[i])
    return t

def get_interval(interval={}, c=0,limits=[]):
    FMT = '%H:%M'
    mindelta = datetime.strptime("0:00", FMT) - datetime.strptime("0:00", FMT)
    for k,v in interval.items():
        tdelta_1 = datetime.strptime(v[1], FMT) - datetime.strptime(v[0], FMT)
        tdelta_2 = datetime.strptime(c, FMT) - datetime.strptime(v[0], FMT)
        if tdelta_2 < tdelta_1 and tdelta_2 > mindelta:
            return k
    return "%s_%s" % (str(limits[-1]),str(limits[0]))

def create_interval(hour=[8,14,20,2]):
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
    return y,X,interval

def print_index(idx,max_print):
    if idx % 10000 == 0:
        if max_print == 25:
            print idx
            max_print = 0
        else:
            print idx,
            max_print += 1

    return max_print


import pandas as pd
import re
import csv
from datetime import datetime

def append_features_to_file(filename,l=[]):
    myfile = open(filename, 'a')
    wr = csv.writer(myfile)
    wr.writerow(l)

def run(filename="results/training.csv", nrows=10):
    train = pd.read_csv(filename, header=0, nrows=nrows,delimiter=",", quoting=0)

    targets_dict = {}
    X = []
    y = []
    max_number_class = 0
    for i in range(nrows):
        if (i % 10000 == 0): print i
        if type(train['Complaint.Type'][i]) is str:

            target = train['Complaint.Type'][i]
            y.append(train['Complaint.Type'][i])

            X.append([
                train["Latitude"][i],
                train["Longitude"][i],
                train["minute"][i],
                train["hour"][i],
                train["week_num"][i]
            ])

            if target not in targets_dict:
                targets_dict[target] = max_number_class
                max_number_class += 1

    for i in range(nrows):
        y[i] = targets_dict[y[i]]

    return y,X, targets_dict

def unbalancing(input="results/training.csv",
                output="results/new_training.csv",
                max_per_type=500):
    append_features_to_file(output,
                    l=["num.Complaint.Type","Created.Date","Agency","Agency.Name","Complaint.Type","Descriptor","Location.Type","Incident.Zip","Incident.Address","Street.Name","Cross.Street.1","Cross.Street.2","Address.Type","City","Borough","Latitude","Longitude","weekday","time","dates","day","month","year","minute","hour","week_num","pca_Latitude","pca_Longitude","pca_minute","pca_hour","pca_week_num","skewness","kurtosis","avg","minimun","maximun"])
    targets_dict = {}
    targets_num = {}
    reader = csv.reader(open(input, "r"), delimiter=",")
    idx = 0
    num_target = 0
    max_print = 0
    print "Reading file..."
    for row in reader:
        # if idx > nrows: break
        if idx > 0:
            max_print = print_index(idx,max_print)

            if row[3] not in targets_dict:
                targets_dict[row[3]] = 1
                targets_num[row[3]] = num_target
                num_target += 1

            if targets_dict[row[3]] < max_per_type:
                targets_dict[row[3]] += 1
                t = [
                    targets_num[row[3]], # "num.Complaint.Type"
                    row[0], # "Created.Date",
                    row[1], # "Agency",
                    row[2], # "Agency.Name",
                    row[3], # "Complaint.Type",
                    row[4], # "Descriptor",
                    row[5], # "Location.Type",
                    row[6], # "Incident.Zip",
                    row[7], # "Incident.Address",
                    row[8], # "Street.Name",
                    row[9], # "Cross.Street.1",
                    row[0], # "Cross.Street.2",
                    row[11], # "Address.Type",
                    row[12], # "City",
                    row[13], # "Borough",
                    float(row[14]), # "Latitude",
                    float(row[15]), # "Longitude",
                    row[16], # "weekday",
                    row[17], # "time",
                    row[18], # "dates",
                    int(row[19]), # "day",
                    int(row[20]), # "month",
                    int(row[21]), # "year",
                    int(row[22]), # "minute",
                    int(row[23]), # "hour",
                    int(row[24]), # "week_num",
                    float(row[25]), # "pca_Latitude",
                    float(row[26]), # "pca_Longitude",
                    float(row[27]), # "pca_minute",
                    float(row[28]), # "pca_hour",
                    float(row[29]), # "pca_week_num",
                    float(row[30]), # "skewness",
                    float(row[31]), # "kurtosis",
                    float(row[32]), # "avg",
                    float(row[33]), # "minimun",
                    float(row[34]) # "maximun"
                ]
                append_features_to_file(output,l=t)
        idx += 1

def clustering_Lat_Long(input="results/new_training.csv",
                        hour=[2,4,6,8,10,12,14,16,18,20,22,0]):
    reader = csv.reader(open(input, "r"), delimiter=",",)
    y,X,interval = create_interval(hour=hour)
    target_names = []
    idx = 0
    max_print = 0
    max_number_per_class = {}
    print "Reading file..."
    for row in reader:
        # if idx >1000: break
        if idx > 0:
            max_print = print_index(idx,max_print)
            if row[4] not in target_names:
                target_names.append(row[4]) # "Complaint.Type"
                max_number_per_class[row[4]] = 1

            if max_number_per_class[row[4]] < 500:
                t = [
                    float(row[15]), # "Latitude",
                    float(row[16]), # "Longitude",
                ]
                interv = get_interval(interval=interval,c=row[18],limits=hour) # "hour",
                y[interv].append(int(row[0])) # "num.Complaint.Type"
                X[interv].append(t)
        idx += 1
    print ""
    return y,X,target_names,interval

def read_rows(input="results/new_training.csv"):
    reader = csv.reader(open(input, "r"), delimiter=",",)
    y = []
    X = []
    target_names = []
    idx = 0
    max_print = 0
    print "Reading file..."
    for row in reader:

        if idx > 0:
            max_print = print_index(idx,max_print)

            y.append(int(row[0]))  # "num.Complaint.Type"
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
                float(row[15]), # "Latitude",
                float(row[16]), # "Longitude",
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
            X.append(t)
        idx += 1
    print ""
    return y,X,target_names

def read_rows_per_hour(input="results/new_training.csv",hour=[8,14,20,2]):
    reader = csv.reader(open(input, "r"), delimiter=",",)
    y,X,interval = create_interval(hour=hour)
    target_names = []
    idx = 0
    max_print = 0
    max_number_per_class = {}
    print "Reading file..."
    for row in reader:
        # if idx >10: break
        if idx > 0:
            max_print = print_index(idx,max_print)
            if row[4] not in target_names:
                target_names.append(row[4])
                max_number_per_class[row[4]] = 0

            if max_number_per_class[row[4]] < 500:
                max_number_per_class[row[4]] += 1
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
                interv = get_interval(interval=interval,c=row[18],limits=hour) # "hour",
                y[interv].append(int(row[0]))
                X[interv].append(t)
        idx += 1
    print ""
    return y,X,target_names, interval


def teste(input="results/new_training.csv",hour=[4,8,12,16,20,0]):
    reader = csv.reader(open(input, "r"), delimiter=",",)
    y,X,interval = create_interval(hour=hour)
    target_names = []
    idx = 0
    max_print = 0
    max_number_per_class = {}
    print "Reading file..."
    for row in reader:
        if idx > 100: break
        if idx > 0:
            max_print = print_index(idx,max_print)

            if row[4] not in target_names:
                target_names.append(row[4])
                max_number_per_class[row[4]] = 1

            if max_number_per_class[row[4]] < 500:
                max_number_per_class[row[4]] += 1
                t = [
                    # row[0], # "num.Complaint.Type"
                    # row[1], # "Created.Date",
                    row[2], # "Agency",
                    # row[3], # "Agency.Name",
                    # row[4], # "Complaint.Type",
                    # row[5], # "Descriptor",
                    # row[6], # "Location.Type",
                    # row[7], # "Incident.Zip",
                    # row[8], # "Incident.Address",
                    re.sub(' +',' ',''.join([i for i in row[8] if not i.isdigit()]).strip()), # "Incident.Address",
                    # row[9], # "Street.Name",
                    # row[10], # "Cross.Street.1",
                    # row[11], # "Cross.Street.2",
                    # row[12], # "Address.Type",
                    row[13], # "City",
                    row[14], # "Borough",
                    row[17],  # "weekday",
                    # int(row[23]), # "minute",
                    # int(row[24]), # "hour",
                    # float(row[15]), # "Latitude",
                    # float(row[16]) # "Longitude",
                ]
                # print row[24]
                interv = get_interval(interval=interval,c=row[18],limits=hour) # "hour",
                y[interv].append(int(row[0]))
                X[interv].append(t)
        idx += 1
    print ""
    return y,X,target_names, interval



def read_rows_per_hour_with_text(input="results/new_training.csv",
                       hour=[4,8,12,16,20,0]):
    reader = csv.reader(open(input, "r"), delimiter=",",)
    y,X,interval = create_interval(hour=hour)
    target_names = []
    idx = 0
    max_print = 0
    max_number_per_class = {}
    print "Reading file..."
    for row in reader:
        # if idx > 100: break
        if idx > 0:
            max_print = print_index(idx,max_print)

            if row[4] not in target_names:
                target_names.append(row[4])
                max_number_per_class[row[4]] = 1

            if max_number_per_class[row[4]] < 500:
                max_number_per_class[row[4]] += 1
                t = [
                    # row[2], # "Agency",
                    row[5], # "Descriptor",
                    row[6], # "Location.Type",
                    # "Incident.Address",
                    re.sub(' +',' ',''.join([i for i in row[8] if not i.isdigit() and not i == "-"]).strip()),
                    row[13], # "City",
                    row[14], # "Borough",
                    row[17],  # "weekday",
                ]
                t = " ".join(t)
                interv = get_interval(interval=interval,c=row[18],limits=hour) # "hour",
                y[interv].append(row[4])
                X[interv].append(t)
        idx += 1
    print ""
    return y,X,target_names, interval







