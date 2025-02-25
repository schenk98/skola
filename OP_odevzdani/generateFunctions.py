import numpy as np
from area import Area
import random
import constants
import math
import tkinter as tk
import tkinter.ttk as ttk
import threading
import time
from scipy.spatial import Voronoi


# TODO make it work parallel to all generate and sort functions
def runProgressbar(stop):
    # Create the master object
    master = tk.Tk() 
    # Create a progressbar widget
    progress_bar = ttk.Progressbar(master, orient="horizontal", mode="determinate", maximum=100, value=0) 
    # And a label for it
    label_1 = tk.Label(master, text="Progress Bar")     
    # Use the grid manager
    label_1.grid(row=0, column=0)
    progress_bar.grid(row=0, column=1) 
    # Start auto-incrementing periodically
    progress_bar.start()
    progress_bar.step(10) 
    # The application mainloop
    tk.mainloop()

# generate data gaussian random
def generateGaussCirc(area, pointsSize, r):
    # generate
    x = np.random.normal((area.maxX + area.minX) / 2, r, pointsSize)
    y = np.random.normal((area.maxY + area.minY) / 2, r, pointsSize)
    
    #check
    for i in range(pointsSize):         
        while not area.isInArea(x[i],y[i]):
            x[i]=np.random.normal((area.maxX + area.minX) / 2, r, 1)
            y[i]=np.random.normal((area.maxY + area.minY) / 2, r, 1)
    
    #save and return
    points = np.array(list(zip(x, y)))    
    return points


# generate linear random
def generateLinear(area, pointsSize):
    points = []
    
    while len(points) < pointsSize:
        #generate new point
        x = np.random.uniform(area.minX, area.maxX)
        y = np.random.uniform(area.minY, area.maxY)
        
        #check if its in area
        if area.isInArea(x, y):
            points.append([x, y])
        else:
            # if not in area, not useful, generate again
            continue    
    return np.array(points)

#generate points in uniform array
def generateUniform(area, pointsSize):
    # get area position and size
    minX, minY = area.getMin()
    maxX, maxY = area.getMax()
    
    points = []
    #get number of steps needed in both directions
    num_steps_x = int(np.sqrt(pointsSize))
    num_steps_y = pointsSize // num_steps_x

    #get step size
    stepX = (maxX - minX) / num_steps_x
    stepY = (maxY - minY) / num_steps_y

    # generate points for every step in every direction
    for i in range(num_steps_x):
        for j in range(num_steps_y):
            x = minX + i * stepX
            y = minY + j * stepY
            #check it it is on area
            if area.isInArea(x, y):
                points.append([x, y])
            else:
                print("REGULAR - Point generated outside or area.")
    
    return np.array(points)




#                                                                                                   TODO check!!!
#functions for Hammersly generation
def corput_sequence(n, base=2):
    result = 0
    f = 1.0 / base
    i = n
    while i > 0:
        result += (i % base) * f
        i //= base
        f /= base
    return result

def hammersley_sequence(pointsSize, dimension=2):
    points = []
    for i in range(pointsSize):
        x = i / pointsSize
        y = corput_sequence(i)
        points.append([x, y])
    return points

def generateHammersley(area, pointsSize):
    hammersley_points = hammersley_sequence(pointsSize)
    scaled_points = []
    
    for point in hammersley_points:
        x = area.minX + point[0] * (area.maxX - area.minX)
        y = area.minY + point[1] * (area.maxY - area.minY)
        scaled_points.append([x, y])
    
    return np.array(scaled_points)




#functions for generation Larcher-Pillichshammer
def permuted_corput_sequence(n, base, perm):
    result = 0
    f = 1.0 / base
    i = n
    while i > 0:
        result += perm[(i % base)] * f
        i //= base
        f /= base
    return result

def generate_permutation(base):
    perm = list(range(base))
    np.random.shuffle(perm)
    return perm

def generateLP(area, num_points, bases=[2, 3]):
    points = []
    perms = [generate_permutation(base) for base in bases]
    for i in range(num_points):
        x = permuted_corput_sequence(i + 1, bases[0], perms[0])
        y = permuted_corput_sequence(i + 1, bases[1], perms[1])
        scaled_x = area.minX + x * (area.maxX - area.minX)
        scaled_y = area.minY + y * (area.maxY - area.minY)
        points.append((scaled_x, scaled_y))
    return np.array(points)

#                                                                                                   TODO check!!!
#function for jittering algorithm
def generateJittering(area, pointsSize, jitter_strength):
    # r is jitter strength here
    if(jitter_strength>1):
        jitter_strength/=100
    # get jittering distance
    jitterX = abs(area.minX-area.maxX)*jitter_strength
    jitterY = abs(area.minY-area.maxY)*jitter_strength
    points = []
    
    for _ in range(pointsSize):
        while True:
            #generate point and jitter it
            x = np.random.uniform(area.minX, area.maxX)
            y = np.random.uniform(area.minY, area.maxY)
            
            x += np.random.uniform(-jitterX, jitterX)
            y += np.random.uniform(-jitterY, jitterY)
            
            # area check
            if area.isInArea(x, y):
                points.append([x, y])
                break
    
    return np.array(points)


#                                                                                                   TODO check!!!
#function fr semi jittering
def generateSemi_Jittering(area, pointsSize, jitter_strength):
    #5% jitter range from semi jitter strength
    semi_jitter_strength = (jitter_strength/100) * 5
    points = []
    
    for _ in range(pointsSize):
        while True:
            #generate points and jitter it
            x = np.random.uniform(area.minX, area.maxX)
            y = np.random.uniform(area.minY, area.maxY)
            
            x += np.random.uniform(-jitter_strength, jitter_strength)
            y += np.random.uniform(-jitter_strength, jitter_strength)
            
            # check if point wasnt generated in area
            if area.isInArea(x, y):
                semi_jitter_x = x + np.random.uniform(-semi_jitter_strength, semi_jitter_strength)
                semi_jitter_y = y + np.random.uniform(-semi_jitter_strength, semi_jitter_strength)
                
                # check if pooint didnt jitter out of area
                if area.isInArea(semi_jitter_x, semi_jitter_y):
                    points.append([semi_jitter_x, semi_jitter_y])
                    break
    
    return np.array(points)



#                                                                                                   TODO check!!!
#function for n rooks algorithm
def generateN_Rooks(area, pointsSize):
    
    smallSide = min(area.width, area.height)
    sizeOfTile = smallSide/(pointsSize+math.sqrt(pointsSize))

    points = []
    # used columns - rows are not needed since I am generating from one side to the other
    used_columns = []


    for i in range(pointsSize):
        while True:
            # get random column, check if it is used and if not, generate new point in i-th row
            # TODO optimalizovat tak, abych nestřílel ke konci furt do použitých - hash map?

            colNumber = random.randint(0, pointsSize-1)
            if colNumber not in used_columns:
                x=i*sizeOfTile + sizeOfTile/2 + area.minX
                y=colNumber*sizeOfTile + sizeOfTile/2 + area.minY
                used_columns.append(colNumber)
                points.append([x, y])
                #point area validation
                if area.isInArea(x,y):
                    break
                if area.type==constants.ELIPSE:
                    break

    return np.array(points)



#function for poisson algorithm
def generatePoisson(area, pointsSize):
    points=[]
    areaSize = abs(area.minX-area.maxX)* abs(area.minY-area.maxY)
    intenzity = pointsSize/areaSize
    minDistance = math.sqrt(1/(intenzity*math.pi))

    def getDist(p1,p2):
        return math.sqrt((p1[0]-p2[0])**2+(p1[1]-p2[1])**2)
    
    
    for i in range(pointsSize):
        while True:
            x = np.random.uniform(area.minX, area.maxX)
            y = np.random.uniform(area.minY, area.maxY)
            can = True
            for p in points:
                if getDist(p,[x,y]) < minDistance:
                    can = False
                    break
            if can and area.isInArea(x,y):
                points.append([x,y])
                break

    return np.array(points)



#                                                                   TODO fix - bad number of points generated
#function for mitchell algorithm
def generateMitchell(area, pointsSize):
    areaSize = abs((area.maxX - area.minX) * (area.maxY - area.minY))
    minDistance = math.sqrt(areaSize / (pointsSize * math.pi))

    points = []
    active_list = []

    # Inicializaction of grid
    cell_size = minDistance / math.sqrt(2)
    grid = {}
    
    def get_grid_coordinates(point):
        return (int(point[0] // cell_size), int(point[1] // cell_size))
    
    def add_to_grid(point, cell_coords):
        if cell_coords in grid:
            grid[cell_coords].append(point)
        else:
            grid[cell_coords] = [point]

    # first point is random and added to list
    x = np.random.uniform(area.minX, area.maxX)
    y = np.random.uniform(area.minY, area.maxY)
    points.append([x, y])
    active_list.append([x, y])
    grid_coords = get_grid_coordinates([x, y])
    add_to_grid([x, y], grid_coords)

    while active_list:
        # choose one of the points in active list
        current_point = random.choice(active_list)
        found = False

        # try to find point nearby
        for _ in range(pointsSize):
            angle = random.uniform(0, 2 * math.pi)
            distance = random.uniform(minDistance, 2 * minDistance)
            new_x = current_point[0] + distance * math.cos(angle)
            new_y = current_point[1] + distance * math.sin(angle)

            # check if new point is in area
            if area.isInArea(new_x, new_y):
                new_grid_coords = get_grid_coordinates([new_x, new_y])

                # validation that the new point is far enough from other points
                valid = True
                for i in [-1, 0, 1]:
                    for j in [-1, 0, 1]:
                        neighbor_coords = (new_grid_coords[0] + i, new_grid_coords[1] + j)
                        if neighbor_coords in grid:
                            for point in grid[neighbor_coords]:
                                dist = np.linalg.norm(np.array([new_x, new_y]) - np.array(point))
                                if dist < minDistance:
                                    valid = False
                                    break
                        if not valid:
                            break
                    if not valid:
                        break
                # append validated point
                if valid:
                    points.append([new_x, new_y])
                    active_list.append([new_x, new_y])
                    add_to_grid([new_x, new_y], new_grid_coords)
                    found = True
                    break

        # if new point cant be found, remove this point from active list
        if not found:
            active_list.remove(current_point)
    return np.array(points)



#                                                       TODO - can generate only in squares
#function for Lloyd algorithm
def generateLloyd(area, pointsSize, iterations):
    if iterations < 1:
        iterations = 100
    else:
        iterations = int(iterations)
    # point generation
    points = generateLinear(area, pointsSize)
    
    for _ in range(iterations):
        # voronoi for active points
        vor = Voronoi(points)
        new_points = []
        
        # move points to centroids of voronoi cells
        for i in range(pointsSize):
            region = vor.regions[vor.point_region[i]]
            if len(region) > 0 and -1 not in region:
                polygon = [vor.vertices[j] for j in region]
                centroid = np.mean(polygon, axis=0)
                # move points that crossed out of area, back to area
                centroid = area.clampToBoundary(centroid[0], centroid[1])
                new_points.append(centroid)
            else:
                new_points.append(area.clampToBoundary(points[i][0], points[i][1]))
        
        points = np.array(new_points)
    
    return points






#function for CCPD algorithm                            TODO - check if it is ccpd or lloyd

def generateCCPD(area, pointsSize, iterations):
    if iterations < 1:
        iterations = 100
    else:
        iterations = int(iterations)

    # Náhodná inicializace bodů
    points = generateLinear(area, pointsSize)

    for _ in range(iterations):
        # Vytvoření Voronoi diagramu
        vor = Voronoi(points)

        # Výpočet centroidů Voronoi buněk
        centroids = []
        for i in range(pointsSize):
            region = vor.regions[vor.point_region[i]]
            if len(region) > 0 and -1 not in region:
                polygon = [vor.vertices[i] for i in region]
                centroid = np.mean(polygon, axis=0)
                centroid = area.clampToBoundary(centroid[0], centroid[1])
                centroids.append(centroid)
            else:
                centroids.append(area.clampToBoundary(points[i][0], points[i][1]))

        # Pohyb bodů směrem k novým centroidům
        #print(len(points), len(centroids))
        for i in range(min(len(points), len(centroids))):
            points[i] = centroids[i]
    print(len(points), len(centroids), pointsSize)
    return points


# function called from gui deciding which function will be called and with which arguments
def generate(pointsSize, areaShape, genType, a, b, r):
    area = Area(areaShape, a, b)
    
    points = []
    if genType == constants.LINEAR:
        points = generateLinear(area, pointsSize)
    elif genType == constants.GAUSS:
        points = generateGaussCirc(area, pointsSize, r)
    elif genType == constants.REGULAR:
        points = generateUniform(area, pointsSize)
    elif genType == constants.HAMMERSLY:
        points = generateHammersley(area, pointsSize)
    elif genType == constants.LP:
        points = generateLP(area, pointsSize)
    elif genType == constants.JITTER:
        points = generateJittering(area, pointsSize, r)
    elif genType == constants.SEMI_JITTER:
        points = generateSemi_Jittering(area, pointsSize, r)
    elif genType == constants.N_ROOKS:
        points = generateN_Rooks(area, pointsSize)
    elif genType == constants.POISSON:
        points = generatePoisson(area, pointsSize)
    elif genType == constants.MITCHEL:
        points = generateMitchell(area, pointsSize)
    elif genType == constants.LLOYD:
        points = generateLloyd(area, pointsSize, r)
    elif genType == constants.CCPD:
        points = generateCCPD(area, pointsSize, r)

    else:
        return 2

    return area, points    