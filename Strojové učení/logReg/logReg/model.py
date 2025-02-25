import numpy as np

#TODO 1st part
class LogisticRegression:

    def __init__(self, x_dim):
        self.theta = np.zeros(x_dim)
        self.cost_history = []
        self.theta_history = []

    def predict(self, X):
        """
        Computes the prediction (hypothesis) of the linear regression
        :param X: input data as row vectors
        :return: vector of predicted outputs
        """
        nasobeni = np.matmul(X, self.theta)
        ret = np.round(self.get_positive_score(nasobeni))
        return ret

    def get_positive_score(self, X):
        """
        Computes the probability of classification to the positive class
        :param X: Input data
        :return:
        """
        exp = 1 + np.exp(-X)
        ret = 1/exp
        return ret

    def cost(self, X, y):
        """
        Computes the loss function of a linear regression (mean square error)
        :param X: input data as row vectors
        :param y: vector of the expected outputs
        :return: Loss value
        """
        #cost fce s logaritmama
        m = len(y)
        h = self.get_positive_score(np.matmul(X, self.theta))
        cost = (1 / m) * ((np.matmul((-y).T, np.log(h + 1e-5))) - (np.matmul((1 - y).T, np.log(1 - h + 1e-5))))
        return cost

    def grad(self, X, y):
        """
        Computes the gradient of the loss function with regard to the parameters theta
        :param X: input data as row vectors
        :param y: vector of the expected outputs
        :return: Gradient
        """
        #to stejne jak bylo v multiLinReg (jen se jinak pocita hypoteza)
        #TODO kontrola        
        score = self.get_positive_score(np.matmul(X, self.theta))
        ret = np.matmul(X.T, (score - y))
        return ret
        """
        m=X.shape[0]

        vec=[]
        for j in range(0,X.shape[1]):
            zavorka = np.subtract(self.predict(X),y)
            vec.append(np.sum((np.multiply(zavorka,X[:,j]))) / m)

        return np.array(vec)
        """

    def update(self, theta, cost):
        # print("%s : grad = %s, cost = %s" % (str(self.theta), str(G), str(self.__cost)))
        self.theta = theta
        self.theta_history.append(np.copy(self.theta))
        self.cost_history.append(cost)

#TODO 2nd part
class OneVsAll:

    def __init__(self, model_gen, opt_gen):
        """
        One-vs-all technique implementation
        :param model_gen: a generator function which creates a new model (with number of input features as a parameter)
        :param opt_gen: a generator function which creates a new optimizer (with model as a parameter)
        """
        self.model_gen = model_gen
        self.opt_gen = opt_gen
        self.models = []

    def predict(self, X):
        """
        Predicts the class for each datapoint (row of X)
        :param X: input data
        :return:
        """
        preds = []
        X1 = X.copy()
        for i in range(0, X1.shape[0]):
            predictions = []
            rada = X1[i, :]
            for model in self.models:
                predict = model.get_positive_score(np.matmul(rada, model.theta))
                predictions.append(predict)

            trida = max(predictions)
            preds.append(predictions.index(trida))

        return preds

    def train(self, X, y):
        """
        Trains one-vs-all classifier (separate logistic regression for each class)
        :param X: input data
        :param y: gold classes
        :return:
        """
        for i in range(0, 10):
            shape1 = X.shape[1]
            model = self.model_gen(shape1)
            opt = self.opt_gen(model)
            label = (y == i).astype(int)
            opt.optimize_full_batch(X, label)
            self.models.insert(i, opt.model)
