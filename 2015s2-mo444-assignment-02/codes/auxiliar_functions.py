import csv
import json
import random

def save_csv(data, header=[], filename="out.csv",delimiter=','):
  with open(filename, 'w') as csvfile:
    csv_write = csv.writer(csvfile, delimiter=delimiter, quoting=csv.QUOTE_ALL)
    if header:
      csv_write.writerow(header)
    for item in data:
      csv_write.writerow(item)
    csvfile.close()

def read_csv(filename='2015s2-mo444-assignment-02-new.csv', delimiter="|"):
  f = open(filename,'r')
  csv_f = csv.reader(f, delimiter=delimiter)
  lines = []
  for row in csv_f:
    lines.append(row)
  f.close()
  return lines

def write_file(data, filename="variable.txt"):
  #Open new data file
  f = open(filename, "w")
  f.write( str(data)  )
  f.close()

def save_json(jsonData, filename="variable.json"):
  with open(filename, 'w') as json_file:
    # json.dump(jsonData, json_file, sort_keys = True, indent = 4, ensure_ascii=False)
    json.dump(jsonData, json_file, sort_keys = True, indent = 2)
    json_file.close()

def read_json(filename="variable.json"):
  with open(filename) as json_file:
    json_data = json.load(json_file)
    json_file.close()
    return json_data

def count_words(data):
  coll = {}
  set_coll = set()
  for row in data:
    if row[3] in coll:
      coll[row[3]] += 1
    else:
      coll[row[3]] = 1
    set_coll.add(row[3])
  return coll, set_coll


def generate_random_data(input='2015s2-mo444-assignment-02-new.csv',
                         output="random_data.csv",
                         limit=50000):
  data = read_csv('2015s2-mo444-assignment-02-new.csv', delimiter=",")
  new_coll = get_random_from_list(coll=lines,limit=limit)
  save_csv(new_coll, filename=output)

  print("Write random data into file", output)

def get_random_from_list(coll=[],limit=10):
  idx = 0
  my_list = []
  while idx < limit:
    idx += 1
    rd = random.randint(0,len(coll)-1)
    my_list.append(coll.pop(rd))
  return my_list

# print(list(range(50)))


# # create a set from words
# coll = list(set(stem_words))
# coll = list(filter(None, coll))

# # save set into file
# write_file(coll,filename="words.txt")

# lines = auxiliar_functions.read_csv('2015s2-mo444-assignment-02-new.csv', delimiter=",")
# sub_file = [ [w[2].lower(),w[3].lower()] for w in lines]
# auxiliar_functions.save_csv(sub_file, header=['y','description'], filename="out.csv")


# lines = read_csv('2015s2-mo444-assignment-02-new.csv', delimiter=",")
# coll, set_coll = count_words(lines)
# save_json(coll)
# d = read_json()
# save_csv(d,header=['quantity','description'])