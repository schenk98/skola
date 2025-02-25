import numpy as np
import random
import matplotlib
matplotlib.rcParams['agg.path.chunksize'] = 10000
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import plotly.graph_objs as go
from plotly.offline import plot
import config
import pointFlatter
import os
import csv
from multiprocessing import Process
import plotly


#function for quick check of configuration - can be expanded
def checkConfig(filename, sampleSize):
    #check sample size if its number
    try:
        sample = int(sampleSize)
    except ValueError:
        sample = config.SAMPLE_SIZE
        printText("ERROR: 2nd argument for sample size need to be number, config.py will be used instead.")
    #check input file if it exists
    if os.path.exists(filename):
        inputFile=filename
    else:
        inputFile=config.INPUT_FILE
        printText("ERROR: This path does not exit. Using config.py instead.")
    
    #maximal Z difference tolerated before switching function for having overhang
    treshold = config.Z_THRESHOLD# = 0.5

    #treshold for what is sparse and what is ok - #points < avg*SPARSE_PLACE_THRESHOLD
    sparsePlace = config.SPARSE_PLACE_THRESHOLD# = 0.1

    radius = config.SPARSE_SURROUNDINGS_RADIUS# = 3

    #how many times can triangle be than average to be considered too large - big gap
    maxTriangleSize = config.TRIANGLE_SIZE_THRESHOLD# = 4
    ret = True

    #check for dangerous values
    if sample!= 1 and (sample < 100 or sample > 1000000):
        printText("config.sampleSize should be 1 or in (100, 1 000 000) interval")
        ret = False
    
    if treshold < 0 or treshold > 1:
        printText("config.Z_THRESHOLD must be in (0,1) interval")
        ret = False
    
    if sparsePlace < 0 or sparsePlace > 1:
        printText("config.SPARSE_PLACE_THRESHOLD must be in (0,1) interval")
        ret = False
    
    if radius < 0:
        printText("config.SPARSE_SURROUNDINGS_RADIUS must be > 0")
        ret = False
    
    if maxTriangleSize < 1:
        printText("config.TRIANGLE_SIZE_THRESHOLD must be > 1")
        ret = False
    
    if config.OVERHANG_SPARSE_TRESHOLD < 0 or config.OVERHANG_SPARSE_TRESHOLD > 1:
        printText("config.OVERHANG_SPARSE_TRESHOLD should be in (0,1) interval")
        ret = False

    return ret, inputFile, sample


#load 2D points from file - experimental
def load_2d(path):
    # Read point cloud data from file
    with open(path, 'r') as file:
        num_points = int(file.readline().strip())
        x, y = [], []
        for line in file:
            a, b = map(float, line.strip().split())
            if a>0.6 or a<0.4 or b>0.6 or b<0.4:
                x.append(a)
                y.append(b)

    # Convert data to numpy arrays
    return np.array([x, y]).T

#load points from file
def load(path):
    # Read point cloud data from file
    with open(path, 'r') as file:
        first_line = file.readline().strip()
        if first_line.count(" ") > 1 and first_line.count(".") > 1:
            file.close
            file = open(path, 'r')

        x, y, z = [], [], []
        for line in file:
            a, b, c = map(float, line.strip().split())
            x.append(a)
            y.append(b)
            z.append(c)

    # Convert data to numpy arrays
    return np.array([x, y, z]).T

#load points from file and create hole in the middle - experimental
def loadPart(path):
    # Read point cloud data from file
    with open(path, 'r') as file:
        first_line = file.readline().strip()
        if first_line.count(" ") > 1 and first_line.count(".") > 1:
            file.close
            file = open(path, 'r')
        x, y, z = [], [], []
        for line in file:
            a, b, c = map(float, line.strip().split())
            if a>0.6 or a<0.4 or b>0.6 or b<0.4:
                x.append(a)
                y.append(b)
                z.append(c)

    # Convert data to numpy arrays
    return np.array([x, y, z]).T

#validate if file exists and if it contains points in right format
def validate_file(file_path, delimiter=' '):
    # Check if the file exists
    if not os.path.exists(file_path):
        return False, "File does not exist."

    # Try to open and read the file to validate its contents
    try:
        with open(file_path, 'r') as file:
            reader = csv.reader(file, delimiter=delimiter)
            headers = next(reader)  # Skip the header
            if headers is None:
                return False, "File does not contain a header."

            # Check each subsequent line
            for row in reader:
                if len(row) < 3:
                    return False, "Found a line with fewer than 3 values."

    except Exception as e:
        return False, f"An error occurred: {str(e)}"

    return True, "File is valid and contains points."

#save points into output file
def storePoints(points, path=config.OUTPUT_FILE):
    # Write point cloud data to file
    with open(path, 'w') as file:
        for point in points:
            file.write(f"{point[0]} {point[1]} {point[2]}\n")

#show 2D points
def show_2d(points_2d, color="blue", size=0.5):
    fig, ax = plt.subplots()
    ax.scatter(points_2d[:,0], points_2d[:,1], s=size, c=color)

    # Set axis labels
    ax.set_xlabel('X')
    ax.set_ylabel('Y')

    # Show the plot
    plt.show()

#show 2D points with more params
def show_2d(points_2d, color="blue", size=0.5, ax=None, title="2D plot"):
    isCalledNormaly = True
    if ax is None:
        fig, ax = plt.subplots()
    else:
        isCalledNormaly = False
    ax.scatter(points_2d[:, 0], points_2d[:, 1], s=size, c=color)

    # Set axis labels
    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax.set_title(title)
    if isCalledNormaly:
        plt.show()

#add points to existing plot
def addToPlot(ax, points_2d, color="blue", size=0.5):
    ax.scatter(points_2d[:, 0], points_2d[:, 1], s=size, c=color)

#function that will merge two datasets, one in blue and one in red into one plot
def showAndAdd_2d(points1, points2, color="blue", size=0.5, title="2D plot"):
    fig, ax = plt.subplots()
    show_2d(points1, color, size, ax, title)
    addToPlot(ax, points2, "red", 3)

    plt.show()

#another function to plot - experimental
def show1(points, title="show(points)"):
    # Create a 3D scatter plot of the resulting points
    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')
    ax.scatter(points[:,0], points[:,1], points[:,2], c=points[:,2], marker='o', s=0.5)

    # Add axes labels
    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax.set_zlabel('Z')
    plt.show()

#show 3D points and ensure updated plot - experimental
def show(points, title="Graph"):
    plt.ion()  # Enable interactive mode
    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')
    ax.scatter(points[:,0], points[:,1], points[:,2], c=points[:,2], cmap='viridis', marker='o', s=0.5)

    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax.set_zlabel('Z')
    ax.set_title(title)

    plt.draw()  # Redraw the current figure
    plt.pause(0.1)  # Pause briefly to ensure the plot is updated

#point class
class p3d:
    def __init__(x,y,z):    
        x = x
        y = y
        z = z

#show points and subset of them in black - experimental
def showSubset(points, subset):
    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')
    ax.scatter(points[:,0], points[:,1], points[:,2], c=points[:,2], alpha=.1, marker='o', s=0.1)
    ax.scatter(subset[:,0], subset[:,1], subset[:,2], c="black", marker="o", s=5)

    # Add axes labels
    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax.set_zlabel('Z')

    # Show the plot
    plt.show()

#show 3D with plotly - interactive plot for less points
def showInteractive(points, sizeIn=1, opacityIn=1):
    x,y,z = points.T
    #point graph creation
    trace = go.Scatter3d(x=x, y=y, z=z,
        mode='markers', marker=dict(size=sizeIn, color=z, opacity=opacityIn))

    #axes definition
    layout = go.Layout(scene=dict(
            xaxis=dict(title='X'),
            yaxis=dict(title='Y'),
            zaxis=dict(title='Z'),))
    #show
    fig = go.Figure(data=[trace], layout=layout)
    #show differently - experimental
    plotly.offline.plot(fig, filename='temp-plot.html', auto_open=True)
    #fig.show()


#create boxes/areas of points and prepare them in different lists for visualization - extract sparse cells
def getBoxesForVisualization(sparseVisited, indexesRange, visitedIndexes, grid, points):
    #prepare sparse cells list
    xL,yL=list(),list()
    for sparseCell in sparseVisited:
        x = sparseCell%indexesRange[0]
        y = int(sparseCell/indexesRange[0])
        xL.append(x)
        yL.append(y)
    boxSparse = np.array((xL, yL)).T

    #prepare sparse+vicinity cells
    xL,yL=list(),list()
    min, max = [indexesRange[0]+1, indexesRange[1]+1],[-1,-1]
    for includedCell in visitedIndexes:
        x = includedCell%indexesRange[0]
        y = int(includedCell/indexesRange[0])
        if x < min[0]:
            min[0]=x
        if y < min[1]:
            min[1]=y
        if x > max[0]:
            max[0]=x
        if y > max[1]:
            max[1]=y
        xL.append(x)
        yL.append(y)
    boxPoints = np.array((xL,yL)).T

    #prepare outer rectangular box
    #prepare points from sparse cell
    criticalPoints = list()
    xL,yL=list(),list()
    xShow, yShow, zShow = list(), list(), list()
    for i in range(min[0], max[0]+1):
        for j in range(min[1], max[1]+1):
            xL.append(i)
            yL.append(j)
            for p in grid[i][j]:
                pt=points[p]
                xShow.append(pt[0])
                yShow.append(pt[1])
                zShow.append(pt[2])
    boxWhole=np.array((xL,yL)).T
    criticalPoints = np.array((xShow, yShow, zShow)).T
    return criticalPoints, boxSparse, boxPoints, boxWhole

#plot plane and points - experimental
def showPlaneAndPoints(critical_points, point, normal):
    # a plane is a*x+b*y+c*z+d=0
    # [a, b, c] is the normal. Thus, we have to calculate
    # d and we're set
    d = -point.dot(normal)

    # Use the coordinates of your dataset to define xx and yy
    xx, yy = np.meshgrid(critical_points[:, 0], critical_points[:, 1])

    # Calculate corresponding z values for the plane
    z = (-normal[0] * xx - normal[1] * yy - d) * 1.0 / normal[2]

    # Create a Plotly figure
    fig = go.Figure()

    # Plot the plane
    fig.add_trace(go.Surface(z=z, x=critical_points[:, 0], y=critical_points[:, 1], opacity=0.05))

    # Plot the dataset points
    fig.add_trace(go.Scatter3d(
        x=critical_points[:, 0],
        y=critical_points[:, 1],
        z=critical_points[:, 2],
        mode='markers',
        marker=dict(size=2, color=critical_points[:, 2], colorscale='Viridis')
    ))

    # Set labels
    fig.update_layout(scene=dict(xaxis=dict(title='X'), yaxis=dict(title='Y'), zaxis=dict(title='Z')))

    # Show the figure
    fig.show()

#plot more datasets into different graphs but in single plot - not used now
def show_multiple_datasets(datasets, titles=None):
    num_datasets = len(datasets)
    if titles is None:
        titles = [f"Dataset {i+1}" for i in range(num_datasets)]

    num_cols = 4  # Maximum number of plots per row
    num_rows = (num_datasets - 1) // num_cols + 1  # Calculate number of rows needed

    fig, axes = plt.subplots(num_rows, num_cols, figsize=(5*num_cols, 5*num_rows), subplot_kw={'projection': '3d'})

    for i, (data, title) in enumerate(zip(datasets, titles)):
        row_index = i // num_cols
        col_index = i % num_cols

        if num_rows == 1:
            ax = axes[col_index]
        else:
            ax = axes[row_index, col_index]

        ax.scatter(data[:, 0], data[:, 1], data[:, 2], c=data[:, 2], marker='o', s=1)
        ax.set_xlabel('X')
        ax.set_ylabel('Y')
        ax.set_zlabel('Z')
        ax.set_title(title)

    # Hide empty subplots
    for i in range(num_datasets, num_rows * num_cols):
        if num_rows == 1:
            axes[i].axis('off')
        else:
            axes[i // num_cols, i % num_cols].axis('off')

    plt.tight_layout()
    plt.show()



#calculate area on which points are located
def calculate_area(points):
    if len(points) < 3:
        return 0
    points = np.array(points)
    flatPoints = pointFlatter.projectPoints(points.copy())
    normal = pointFlatter.getNormal(flatPoints.copy())
    if np.isnan(normal).any():
        normal=[0,0,1]
    rotatedFlat = pointFlatter.rotatePlane(flatPoints.copy(),normal, [0,0,1])
    
    # Extract x and y coordinates from the points
    x_coords = points[:, 0]
    y_coords = points[:, 1]
    
    # Calculate minX, minY, maxX, maxY
    minX = np.min(x_coords)
    minY = np.min(y_coords)
    maxX = np.max(x_coords)
    maxY = np.max(y_coords)
    
    area = (maxX-minX)*(maxY-minY)
    return area

#print text into console or into output file - based on config
def printText(text):
    if config.CONSOLE_OUTPUT:
        print(text)
    else:
        with open("output_"+config.OUTPUT_FILE, 'a') as file:
            file.write("{}\n".format(text))