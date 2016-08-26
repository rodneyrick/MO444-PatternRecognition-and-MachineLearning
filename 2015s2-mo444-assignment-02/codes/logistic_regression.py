from sklearn import linear_model
import numpy as np
import math
import matplotlib.pyplot as plt
from datetime import datetime
from sklearn.svm import l1_min_c
from pylab import scatter, show, legend, xlabel, ylabel

# https://www.youtube.com/watch?v=-BQCB6Uch1g
# from __future__ import division

def logistic_func(theta, x):
  return float(1) / (1 + math.e**(-x.dot(theta)))

def log_gradient(theta, x, y):
  first_calc = logistic_func(theta, x) - np.squeeze(y)
  final_calc = first_calc.T.dot(x)
  return final_calc

def cost_func(theta, x, y):
  log_func_v = logistic_func(theta,x)
  y = np.squeeze(y)
  step1 = y * np.log(log_func_v)
  step2 = (1-y) * np.log(1 - log_func_v)
  final = -step1 - step2
  return np.mean(final)

def grad_desc(theta_values, X, y, lr=.001, limit=10):
  #normalize
  X = (X - np.mean(X, axis=0)) / np.std(X, axis=0)
  #setup cost iter
  cost_iter = []
  i = 0
  while(i < limit):
    # old_cost = cost
    theta_values = theta_values - (lr * log_gradient(theta_values, X, y))
    cost = cost_func(theta_values, X, y)
    cost_iter.append([i, cost])
    i+=1
  return theta_values, np.array(cost_iter)

def pred_values(theta, X, hard=True):
  #normalize
  X = (X - np.mean(X, axis=0)) / np.std(X, axis=0)
  pred_prob = logistic_func(theta, X)
  pred_value = np.where(pred_prob >= .5, 1, 0)
  if hard:
    return pred_value
  return pred_prob

def logistic_regression(Y, X, X_validation=[],Y_validation=[], limit=100):
  shape = X.shape[1]
  print("Dimension = (",shape,")")
  betas = np.zeros(shape)
  fitted_values, cost_iter = grad_desc(betas, X, Y,limit=limit)
  # print("Fit values =",fitted_values)

  predicted_y = pred_values(fitted_values, X)
  print("Y =",Y)
  print("Predict Y =",predicted_y)

  score_y = np.sum(Y)

  print("Y =",score_y)
  print("Predict Y =", np.sum(predicted_y))
  print("Compare predict_y and Y =", np.sum(Y == predicted_y), " values are equal")

  print(cost_iter)
  plt.plot(cost_iter[:,0], cost_iter[:,1])
  plt.ylabel("Cost")
  plt.xlabel("Iteration")
  plt.show()
  plt.savefig('cost_iter.png')


  #normalize data
  # norm_X = (X - np.mean(X, axis=0)) / np.std(X, axis=0)
  # myargs = (norm_X, Y)
  # betas = np.zeros(norm_X.shape[1])


  # logreg = linear_model.LogisticRegression()
  # logreg.fit(norm_X, Y)
  # print("From 'sklearn' --> logreg.predict == Y =", sum(Y == logreg.predict(norm_X,)))
  # print(logreg.score(norm_X, Y))

  # print("Computing regularization path ...")
  # start = datetime.now()
  # clf = linear_model.LogisticRegression(C=1.0, penalty='l1', tol=1e-6)
  # # coefs_ = []
  # # cs = l1_min_c(X, Y, loss='log') * np.logspace(0, 3)
  #
  # cost_iter = []
  # i = 0
  # # for c in cs:
  # clf.fit(X, Y)
  # while (i < limit):
  #   # clf.set_params(C=c)
  #   # coefs_.append(clf.coef_.ravel().copy())
  #   cost = float(sum(Y_validation == clf.predict(X_validation,)))/float(score_y)
  #   cost_iter.append([i, cost])
  #   print(i, cost, flush=True)
  #   i += 1
  # print("This took ", datetime.now() - start)

  # coefs_ = np.array(coefs_)
  # plt.plot(np.log10(cs), coefs_)
  # ymin, ymax = plt.ylim()
  # plt.xlabel('log(C)')
  # plt.ylabel('Coefficients')
  # plt.title('Logistic Regression Path')
  # plt.axis('tight')
  # plt.show()
  # plt.savefig("cost_iter_second.png")

  # print(cost_iter)
  # cost_iter = np.array(cost_iter)
  # plt.plot(cost_iter[:,0], cost_iter[:,1],'-', linewidth=3)
  # plt.ylabel("Cost")
  # plt.xlabel("Iteration")
  # plt.xlim(0, len(cost_iter[:,0]))
  # # plt.ylim(0, 100)
  # plt.show()
  # plt.savefig('cost_iter.png')


  # fitted_values, cost_iter = grad_desc(betas, norm_X, Y)
  # predicted_y = pred_values(fitted_values, norm_X)
  # print("From 'my function' --> Predict Y =",sum(predicted_y == Y))
  #
  # plt.plot(cost_iter[:,0], cost_iter[:,1],'-', linewidth=3)
  # plt.ylabel("Cost")
  # plt.xlabel("Iteration")
  # plt.show()
