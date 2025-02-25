import matplotlib.pyplot as plt
import numpy as np
from matplotlib import cm
from mpl_toolkits.mplot3d import axes3d, Axes3D
from matplotlib import cm
from scipy.stats import linregress

class LinearRegression:
    def __init__(self):
        self.theta = np.array([0., 0.])
        self.counter = 0
        self.costCounter = 0

        self.cost_history = np.array([0,0.])
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

        """if len(X.shape) == 1:
            return self.theta[1]*X[1]+self.theta[0]

        ret = np.zeros(X.shape[0])
        #print(X)
        for i in range(X.shape[0]):
            ret[i]=self.theta[1]*X[i][1]+self.theta[0]
        return ret"""

    def cost(self, X, y):
        """
        Computes the loss function of a linear regression (mean square error)
        :param X: input data as row vectors
        :param y: vector of the expected outputs
        :return: Loss value
        """
        # compute loss value
        sum = 0
        for i in range(X.shape[0]):
            sum+=(self.theta[1]*X[i][1]+self.theta[0]-y[i])*(self.theta[1]*X[i][1]+self.theta[0]-y[i])       
        #self.cost_history[self.costCounter]=sum    
        self.costCounter+=1
        return sum
        #pass

    def train(self, X, y, lr, k, epsilon=0.0):
        """
        Trains the linear regression model (finds optimal parameters)
        :param X: input data as row vectors
        :param y: vector of the expected outputs
        :param lr: learning rate
        :param k: number of steps
        :param epsilon:
        :return:
        """
        tmp=[0.0,0.0]
        zla_zavorka=[0.0,0.0]
        for i in range(k):
            #if i!=0 and (abs(self.theta_history[i-1][0]-self.theta[0])+abs(self.theta_history[i-1][1]-self.theta[1])) < epsilon:
            #    break
            #zavorka
            #print(k)
            zavorka = np.subtract(self.predict(X),y)
            m=X.shape[0]
            #theta0
            sum = 0.0
            j=0
            for j in range(m):
                sum+=zavorka[j]
            zla_zavorka[0]=sum/m
            
            #theta1
            sum=0.0
            j=0
            for j in range(m):
                sum+=zavorka[j]*X[j][1]
            zla_zavorka[1]=sum/m   

            tmp[0]=self.theta[0]-lr*zla_zavorka[0]
            tmp[1]=self.theta[1]-lr*zla_zavorka[1]
            self.theta[0]=tmp[0]
            self.theta[1]=tmp[1] 

            #if i<10:
            #    print(self.theta_history)

            self.theta_history.append([tmp[0],tmp[1]])
            self.counter+=1
        # implement the training procedure of a linear regression



def load_data(fn):
    """
    Loads the data for the assignment
    :param fn: file path
    :return: tuple: (input coordinates as the matrix of row vectors of the data, where each vector is in the form: [1, x],
                    expected outputs)
    """
    x_ = []
    y_ = []

    with open(fn, 'r') as f:
        for line in f:
            x, y = line.split(",")
            x_.append(float(x))
            y_.append(float(y))

    return np.stack([np.ones(len(x_)), np.array(x_)], axis=1), np.array(y_)

def plot_data(X, y):
    """
    Plots the data into a coordinates system.
    :param X:
    :param y:
    :return:
    """
    plt.figure()
    plt.scatter(X[:,1], y, marker="x", color='red')
    plt.xlabel("City population (×1e5)")
    plt.ylabel("Profit (×1e5 $)")
    plt.savefig("data.pdf")
    plt.show()

def plot_regression(model, X, y):
    """
    Plots the data with the regression line.
    :param model: Linear regression model
    :param X: inputs
    :param y: expected outputs
    :return:
    """
    plt.figure()
    plt.scatter(X[:,1], y, marker="x", color='red')
    x1 = np.min(X, axis=0)
    x2 = np.max(X, axis=0)
    y1 = model.predict(x1)
    y2 = model.predict(x2)
    plt.plot([x1[1], x2[1]], [y1, y2], color='blue')
    plt.legend(["Linear regression", "Training data"])
    plt.xlabel("City population (×1e5)")
    plt.ylabel("Profit (×1e5 $)")
    plt.savefig("regression.pdf")
    plt.show()


def plot_cost(model, X, Y):
    """
    Plots the loss value according to changing theta parameters
    :param model: Linear regression model
    :param X: input data as row vectors
    :param y: vector of the expected outputs
    :return:
    """
    dummy_model = LinearRegression()
    
    a1 = -2
    a2 = 4
    b1 = -30
    b2 = 30
    """a1 = -1
    a2 = 1
    b1 = -60
    b2 = 60"""

    a_space = np.linspace(a1 - 1, a2 + 1)
    b_space = np.linspace(b1 - 1, b2 + 1)

    A, B = np.meshgrid(a_space, b_space)
    Z = np.zeros_like(A)
    for i, a in enumerate(a_space):
        for j, b in enumerate(b_space):
            dummy_model.theta = np.array([b, a])
            Z[j, i] = dummy_model.cost(X, Y)
    plt.figure()
    plt.contour(A, B, Z, levels=30)
    plt.xlim((a1 - 1, a2 + 1))
    plt.ylim((b1 - 1, b2 + 1))

    for i in range(model.counter-1):
        plt.plot(model.theta_history[i][1],model.theta_history[i][0], 'r.')
    
    plt.savefig("cost.pdf")
    plt.show()

def lsm(X_,y_): #least square method
    xt = np.transpose(X_)
    XtX = np.linalg.inv(np.matmul(xt,X_))
    XtY = np.matmul(xt,y_)
    teta = np.matmul(XtX, XtY)
    #print(teta)
    return teta

def plot_difference(model, lsm, X_, y_):
    history = model.theta_history
    i=0
    diff = np.zeros([len(history)])
    for h in history:
        diff[i] = abs(h[0]-lsm[0]) + abs(h[1]-lsm[1])
        i+=1

    x=np.arange(start=0, stop=len(history), step=1)
    y=np.zeros([len(history)])
    dummy = LinearRegression()
    dummy.theta = lsm
    r = dummy.cost(X_, y_)
    for i in range(len(history)):
        y[i]=r
    
    #TODO vykreslit lsm a diff
    plt.plot(x,y,linestyle="--")#lsm
    plt.plot(x,diff,linestyle="-")
    plt.show()


def plot_surf(X, y):
    """
    3d plot of the surface of the loss with regard to parameters theta
    :param X: input data as row vectors
    :param y: vector of the expected outputs
    :return:
    """
    model = LinearRegression()
    theta0_vals = np.linspace(-10, 10, 100)
    theta1_vals = np.linspace(-10, 10, 100)
    Theta1, Theta0 = np.meshgrid(theta1_vals, theta0_vals)
    J_vals = np.zeros_like(Theta1)
    for i in range(len(theta1_vals)):
        for j in range(len(theta0_vals)):
            model.theta = [theta0_vals[j], theta1_vals[i]]
            J_vals[i][j] = model.cost(X, y)

    plt.figure()
    fig = plt.figure()
    ax = Axes3D(fig)
    ax.plot_surface(Theta1, Theta0, J_vals, cmap=cm.coolwarm)
    plt.savefig("convergence3d.pdf")
    plt.show()

if __name__ == '__main__':
    steps = 1000
    X_, y_ = load_data("C:/Users/jakub/python-workspace/SU/linRegSimple-NumPy/data.txt")

    analogicke = lsm(X_, y_)
    #print(analogicke)

    plot_data(X_, y_)

    lin_reg = LinearRegression()
    alpha = 0.015
    lin_reg.train(X_, y_, alpha, steps)
    print("Theta found by gradient descent: " + str(lin_reg.theta))
   
    predict1 = lin_reg.predict(np.array([1, 3.5]))
    print(f'For population = 35,000, we predict a profit of {predict1*10000}')
    predict2 = lin_reg.predict(np.array([1, 7]))
    print(f'For population = 70,000, we predict a profit of {predict2*10000}')

    plot_regression(lin_reg, X_, y_)
    plot_surf(X_, y_)
    plot_cost(lin_reg, X_, y_)
    # TODO plot convergence graphs for different values of alpha along with an analytical solution using normal equation
    plot_difference(lin_reg, analogicke, X_, y_)