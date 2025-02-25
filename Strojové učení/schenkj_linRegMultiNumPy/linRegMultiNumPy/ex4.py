import numpy as np
from model import LinearRegression
import visualize as vis
import utils as utils
from optimize import GradientDescent


def load_data(path):
    x_ = []
    y_ = []

    with open(path, 'r') as f:
        for line in f:
            vals = line.split(",")
            _x = vals[:-1]
            _y = vals[-1]
            x_.append([float(x) for x in _x])
            y_.append(float(_y))

    return np.array(x_), np.array(y_)


if __name__ == '__main__':
    X, y = load_data("C:/Users/jakub/python-workspace/SU/linRegMultiNumPy/data1.txt")
    X_norm, mu, sigma = utils.normalize_features(X)
    X = utils.add_one(X)
    X_norm = utils.add_one(X_norm)
    linReg = LinearRegression(X.shape[1])
    m, n = X.shape
    vis.plot_data(X, y)
    opt = GradientDescent(linReg)
    opt.optimize_full_batch(X_norm, y)
    vis.plot_regression(X, mu, sigma, y, linReg)
    vis.plot_cost(X_norm, y, linReg, opt.alpha)
    vis.plot_convergence(X_norm, y, linReg, opt.alpha)
    normal_eq = LinearRegression(X.shape[1])
    normal_eq.analytical_solution(X, y)
    x =np.array([1650, 3])
    pred_normal = normal_eq.predict(utils.add_one(x))
    print("Predicted price of a 1650 sq-ft, 3 br house (using normal equation): %f" % pred_normal)
    pred_gd = opt.model.predict(utils.add_one((x - mu) / sigma))
    print("Predicted price of a 1650 sq-ft, 3 br house (using gradient descent): %f" % pred_gd)
