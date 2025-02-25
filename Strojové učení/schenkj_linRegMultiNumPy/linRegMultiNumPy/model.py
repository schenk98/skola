import numpy as np


class LinearRegression:

    def __init__(self, x_dim):
        self.theta = np.zeros(x_dim)
        self.cost_history = []
        self.theta_history = []

    def predict(self, X):
        """
        Computes the prediction (hzpothesis) of the linear regression
        :param X: input data as row vectors
        :return: vector of predicted outputs
        """
        temp = X * self.theta.T
        if len(X.shape) != 1:
            temp =  np.sum(temp, axis=1)
        else:
            temp = np.sum(temp, axis=0)

        #print (temp)
        return temp

    def cost(self, X, y):
        """
        Computes the loss function of a linear regression (mean square error)
        :param X: input data as row vectors
        :param y: vector of the expected outputs
        :return: Loss value
        """
        sum = 0
        #print(self.theta[1])
        #print(X[:,1])
        #print(X[0][1])
        for i in range(X.shape[0]):
            sum+=(self.theta[1]*X[i][1]+self.theta[0]-y[i])*(self.theta[1]*X[i][1]+self.theta[0]-y[i])  
             
        #self.cost_history[self.costCounter]=sum    
        #self.costCounter+=1
        return sum

    def grad(self, X, y):
        """
        Computes the gradient of the loss function with regard to the parameters theta
        :param X: input data as row vectors
        :param y: vector of the expected outputs
        :return: Gradient
        """
        m=X.shape[0]

        vec=[]
        for j in range(0,X.shape[1]):
            zavorka = np.subtract(self.predict(X),y)
            vec.append(np.sum((np.multiply(zavorka,X[:,j]))) / m)

        return np.array(vec)

    def analytical_solution(self, X, y):
        """
        Computes analytical solution of the least-squares method (normal equation)
        :param X: input data as row vectors
        :param y: vector of the expected outputs
        :return:
        """
        xt = np.transpose(X)
        XtX = np.linalg.inv(np.matmul(xt,X))
        XtY = np.matmul(xt,y)
        self.theta = np.matmul(XtX, XtY)
        return None
        
