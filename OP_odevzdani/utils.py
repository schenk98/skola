import numpy as np
import random
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import plotly.graph_objs as go


#function for loading data - not useful if there will be no sorting - used for debugging and implementation  
def load(path):
    # Read point cloud data from file
    with open(path, 'r') as file:
        num_points = int(file.readline().strip())
        print("#points: {}".format(num_points))
        x, y = [], []
        for line in file:
            a, b = map(float, line.strip().split())
            x.append(a)
            y.append(b)
            
    # Convert data to numpy arrays
    return np.array([x, y]).T

#function used for visualization of points in plane - used for debugging and implementation    
def show(points_2d, color="blue"):
    fig, ax = plt.subplots()
    ax.scatter(points_2d[:,0], points_2d[:,1], s=0.5, c=color)

    # Set axis labels
    ax.set_xlabel('X')
    ax.set_ylabel('Y')

    # Show the plot
    plt.show()

def showInteractive(points):
    x,y,z = points.T
    # Vytvoření bodového grafu
    trace = go.Scatter3d(x=x, y=y, z=z,
        mode='markers', marker=dict(size=1, color=z, opacity=1))

    # Definice scény a os
    layout = go.Layout(scene=dict(
            xaxis=dict(title='X Label'),
            yaxis=dict(title='Y Label'),
            zaxis=dict(title='Z Label'),))

    # Vytvoření figury a zobrazení grafu
    fig = go.Figure(data=[trace], layout=layout)
    fig.show()