from sklearn import linear_model
import numpy as np
import math
import matplotlib.pyplot as plt
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
  cost = cost_func(theta_values, X, y)
  cost_iter.append([0, cost])
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

def logistic_regression(Y, X, limit=100):
  shape = X.shape[1]
  # print("Dimension = (",shape,")")
  # y_flip = np.logical_not(Y)
  betas = np.zeros(shape)
  fitted_values, cost_iter = grad_desc(betas, X, Y,limit=limit)
  # print("Fit values =",fitted_values)
  predicted_y = pred_values(fitted_values, X)
  # print("Y =",Y)
  # print("Predict Y =",predicted_y)

  print("Y =",np.sum(Y))
  print("Predict Y =", np.sum(predicted_y))
  print("Equal =", np.sum(Y == predicted_y))

  # print(cost_iter)
  plt.plot(cost_iter[:,0], cost_iter[:,1],'-', linewidth=3)
  plt.ylabel("Cost")
  plt.xlabel("Iteration")
  plt.show()
  plt.savefig('cost_iter.png')

  from scipy.optimize import fmin_l_bfgs_b
  #normalize data
  norm_X = (X - np.mean(X, axis=0)) / np.std(X, axis=0)
  myargs = (norm_X, Y)
  betas = np.zeros(norm_X.shape[1])
  lbfgs_fitted = fmin_l_bfgs_b(cost_func, x0=betas, args=myargs, fprime=log_gradient)

  lbfgs_predicted = pred_values(lbfgs_fitted[0], norm_X, hard=True)

  print("\n2a part")
  # print("l_bfgs_b =",lbfgs_fitted[0])
  print("lbfgs_predicted == Y =", sum(lbfgs_predicted == Y))

  logreg = linear_model.LogisticRegression()
  logreg.fit(norm_X, Y)
  print("From 'sklearn' --> logreg.predict == Y =", sum(Y == logreg.predict(norm_X,)))
  print(logreg.score(norm_X, Y))

  fitted_values, cost_iter = grad_desc(betas, norm_X, Y)
  predicted_y = pred_values(fitted_values, norm_X)
  print("From 'my function' --> Predict Y =",sum(predicted_y == Y))

  plt.plot(cost_iter[:,0], cost_iter[:,1],'-', linewidth=3)
  plt.ylabel("Cost")
  plt.xlabel("Iteration")
  plt.show()
  plt.savefig("cost_iter_second.png")

def test():
  import seaborn as sns
  #matplotlib inline
  sns.set(style='ticks', palette='Set2')

  data = datasets.load_iris()
  X = data.data[:100, :2]
  y = data.target[:100]
  X_full = data.data[:100, :]

  setosa = plt.scatter(X[:50,0], X[:50,1], c='b')
  versicolor = plt.scatter(X[50:,0], X[50:,1], c='r')
  plt.xlabel("Sepal Length")
  plt.ylabel("Sepal Width")
  plt.legend((setosa, versicolor), ("Setosa", "Versicolor"))
  sns.despine()

  shape = X.shape[1]
  print("Dimension = (",shape,")")
  y_flip = np.logical_not(y) #flip Setosa to be 1 and Versicolor to zero to be consistent
  betas = np.zeros(shape)
  fitted_values, cost_iter = grad_desc(betas, X, y)
  print("Fit values =",fitted_values)

  predicted_y = pred_values(fitted_values, X)

  print("Predict Y =",predicted_y)

  # print(np.sum(y_flip == predicted_y))

  plt.plot(cost_iter[:,0], cost_iter[:,1])
  plt.ylabel("Cost")
  plt.xlabel("Iteration")
  sns.despine()

  plt.show()
  # plt.savefig('foo.png')

  from scipy.optimize import fmin_l_bfgs_b
  #normalize data
  norm_X = (X_full - np.mean(X_full, axis=0)) / np.std(X_full, axis=0)
  myargs = (norm_X, y_flip)
  betas = np.zeros(norm_X.shape[1])
  lbfgs_fitted = fmin_l_bfgs_b(cost_func, x0=betas, args=myargs, fprime=log_gradient)
  print("l_bfgs_b =",lbfgs_fitted[0])

  lbfgs_predicted = pred_values(lbfgs_fitted[0], norm_X, hard=True)
  print(sum(lbfgs_predicted == y_flip))

  logreg = linear_model.LogisticRegression()
  logreg.fit(norm_X, y_flip)
  print(sum(y_flip == logreg.predict(norm_X)))

  fitted_values, cost_iter = grad_desc(betas, norm_X, y_flip)
  predicted_y = pred_values(fitted_values, norm_X)
  print(sum(predicted_y == y_flip))

