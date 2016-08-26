from sklearn.metrics.ranking import auc
import auxiliar_functions
import words
import logistic_regression
import neural_network_mlp
import numpy as np


def log_regression():
  # if necessary get new random data
  # auxiliar_functions.generate_random_data()

  # pre-selecting random data from all of data from original file (step before)
  data = auxiliar_functions.read_csv('random_data.csv', delimiter=",")

  train = words.get_random_from_list(coll=data, limit=100)
  # validation = words.get_random_from_list(coll=data,limit=10000)
  # test = words.get_random_from_list(coll=data,limit=15000)

  # free memory
  del data

  stem_words, freq_words = words.bag_words(train)
  ys_train, xs_train = words.y_xs(coll=train, stem_words=stem_words)
  # tranform categorics in number
  ys_train = words.change_y_for_number(ys_train)
  ys_train, xs_train = np.array(ys_train), np.array(xs_train)


  # stem_words, freq_words = words.bag_words(validation)
  # ys_validation, xs_validation = words.y_xs(coll=validation, stem_words=stem_words)
  # # tranform categorics in number
  # ys_validation = words.change_y_for_number(ys_validation)
  # ys_validation, xs_validation = np.array(ys_validation), np.array(xs_validation)

  # print(ys)
  logistic_regression.logistic_regression(ys_train, xs_train,  # ys_validation, xs_validation,
                                          limit=10)


# log_regression()

def nn_descrption():

  def concat_y_x(ys, xs):
    result = []
    for i in range(len(ys)):
      y = ys[i]
      x = xs[i]
      result.append([x,[y]])
    return result

  data = auxiliar_functions.read_csv('random_data.csv', delimiter=",")
  train = auxiliar_functions.get_random_from_list(coll=data, limit=1000)
  validation = auxiliar_functions.get_random_from_list(coll=data,limit=1000)

  del data

  stem_words, freq_words = words.bag_words(train)
  ys_train, xs_train = words.y_xs(coll=train, stem_words=stem_words)
  categories = {}
  ys_train, categories = words.change_y_for_number(ys_train,categories)

  # print(sorted(categories, key=categories.get))

  ys_validation, xs_validation = words.y_xs(coll=validation, stem_words=stem_words)
  # tranform categorics in number
  ys_validation, categories = words.change_y_for_number(ys_validation,categories)

  # print(sorted(categories, key=categories.get))

  del train, validation

  train = concat_y_x(ys_train,xs_train)
  validation = concat_y_x(ys_validation,xs_validation)

  neural_network_mlp.main(train,validation)

  # auxiliar_functions.write_file(validation,filename="nn.txt")


  # ys_train, xs_train = np.array(ys_train), np.array(xs_train)


def predict_district_day_lat_long():

  def tranform_string_2_number(element, d={}):
    idx = 0
    if d: idx = len(d)
    if element not in d:
      d[element] = idx
      idx += 1
    return d

  def transform_base(data, y={},district={}):
    import copy
    result = []
    lat = [10000.0,-10000.0]
    long = [10000.0,-10000.0]

    for row in data:
      day_week = words.day_of_week2number(row[4])
      y = tranform_string_2_number(row[2],y)
      district = tranform_string_2_number(row[5], district)

      longitude = float(row[8]) # longitude
      latitude = float(row[9]) # latitude

      if latitude < lat[0]: lat[0] = latitude
      if latitude > lat[1]: lat[1] = latitude

      if longitude < long[0]: long[0] = longitude
      if longitude > long[1]: long[1] = longitude

      result.append([
        [
          day_week,
          district[row[5]],
          longitude,
          latitude
        ],
        [y[row[2]]]
      ])

    for row in result:
      row[0][2] = (row[0][2] - long[0]) / (long[1]-long[0])
      row[0][3] = (row[0][3] - lat[0]) / (lat[1]-lat[0])

    return result, y, district


  # day_of_week2number('Monday')

  data = auxiliar_functions.read_csv('random_data.csv', delimiter=",")
  train = auxiliar_functions.get_random_from_list(coll=data, limit=200)
  validation = auxiliar_functions.get_random_from_list(coll=data,limit=1000m)

  del data

  print(train[0])
  y = {}
  district = {}

  train_set,y,district = transform_base(train,y,district)
  del train

  validation_set,y,district = transform_base(validation,y,district)
  del validation

  print(train_set[0])

  neural_network_mlp.main(train_set,validation_set,filename='nn_predict_district_day_lat_long.png')


predict_district_day_lat_long()
# nn()



























