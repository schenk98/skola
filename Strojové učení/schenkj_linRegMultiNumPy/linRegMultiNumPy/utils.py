import numpy as np
from collections import defaultdict


def normalize_features(X):
    """
    Normalizes features to zero mean and unit variance
    :param X: input data
    :return: normalized data, original means, and standard deviations
    """
    normed=[]
    mean=[]
    sds = []
    for i in X.T:
        m = np.mean(i)
        mean.append(m)
        sd = np.std(i)
        sds.append(sd)
        n = (i-m)/sd
        normed.append(n)
    normed = np.array(normed).T
    return normed, mean, sds


def build_dict(data):
    """Creates dictionary for dictionary feature transform (training phase)
    :param data: list (1D array) of input strings
    :return: the dictionary"""
    dict = {}
    dict_index = 1

    for string in data:
        if string not in dict:
            dict[string] = dict_index
            dict_index+=1
    return dict
def transform(dict, string_list):
    """Transforms the input strings into one-hot vectors
    :param dict: dictionary from the training phase
    :param string_list: list (1D array) of input strings
    :return: a matrix of one-hot row vectors"""
    mat = []
    for string in string_list:
        vec = np.zeros(len(dict) + 1)
        if string in dict:
            vec[dict[string]] = 1
        else:
            vec[0] = 1
        mat.append(vec)
    return np.array(mat)


def cross_validation(X, y, k, opt_gen, model_gen):
    """
    Performs k-fold cross-validation
    :param X: input data as row vectors
    :param y: vector of the expected outputs
    :param k: number of folds
    :param opt_gen: function which creates an optimizer (with the model as a parameter)
    :param model_gen: function which creates a model
    :return: test predicted values for whole dataset
    """
    y_pred = np.zeros_like(y)
    step = int(X.shape[0] / k)
    for i in range(k):
        test_min = i * step
        test_max = np.minimum((i + 1) * step, X.shape[0])
        X_train = np.concatenate([X[:test_min, :], X[test_max:, :]], axis=0)
        y_train = np.concatenate([y[:test_min], y[test_max:]], axis=0)
        X_test = X[test_min: test_max, :]
        model = model_gen()
        opt = opt_gen(model)
        opt.optimize_full_batch(X_train, y_train)
        y_pred[i * step: (i + 1) * step] = model.predict(X_test)
    return y_pred


def add_one(X):
    if len(X.shape) == 1:
        X = np.expand_dims(X, axis=0)
    return np.concatenate([np.ones([X.shape[0], 1]), X], axis=1)
