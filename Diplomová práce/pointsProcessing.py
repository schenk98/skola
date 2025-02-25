import utils
import sys
import math
import numpy as np
import config
import random
from collections import defaultdict
from scipy.spatial import Delaunay
from shapely.geometry import Polygon
from scipy.interpolate import LinearNDInterpolator
import pointFlatter
import matplotlib.pyplot as plt



class gridMember:
    def __init__(self):
        members = list()


#get interesting metadata of given points
#load points, get extreams, prepare grid
#params: grid size, input file
#ret: mins, maxs, size of grid cell, size of grid (#cells), points, sample (1 point for each cell), overhang candidates
def processPoints(sample_size = config.SAMPLE_SIZE, inputFile = config.INPUT_FILE):
    #load dataset
    points3d = utils.load(inputFile)
    #find extreams, range of dataset etc.
    minX = sys.float_info.max
    maxX = -sys.float_info.max
    minY = sys.float_info.max
    maxY = -sys.float_info.max
    minZ = sys.float_info.max
    maxZ = -sys.float_info.max
    for p in points3d:
        if minX > p[0]:
            minX = p[0]
        elif maxX < p[0]:
            maxX = p[0]

        if minY > p[1]:
            minY = p[1]
        elif maxY < p[1]:
            maxY = p[1]

        if minZ > p[2]:
            minZ = p[2]
        elif maxZ < p[2]:
            maxZ = p[2]

    range = [maxX-minX,maxY-minY,maxZ-minZ]


    #how many points in new simplyfied array
    newSize = sample_size
    #how many points in one row of array [] + example
    #ratio = Y/X -> 2500/2000 = 0.8 -> x*(ratio*x)=len(array) -> math.sqrt(newSize/ratio) = x -> y = x * ratio
    ratio = range[1]/range[0]
    newX = math.sqrt(newSize/ratio)
    dimensionSize = [max(1,int(newX)), max(1,int(newX * ratio))]

    #how far appart I can have points
    step = [range[0]/(dimensionSize[0]+1), range[1]/(dimensionSize[1]+1)]

    #new arrays for sample and for "reservation system" (like in file system in OS)
    grid = defaultdict(lambda : defaultdict(list))
    sample = np.zeros(((int(range[0]/step[0])+1)*(int(range[1]/step[1])+1), 3))
    bitmap = np.zeros((int(range[0]/step[0])+1)*(int(range[1]/step[1])+1))
    if newSize == 1:
        bitmap = np.zeros(1)
    overhangs = list()

    #new point knows his location so check bitmap, if there is point from his sector prezent in sample. If not, block bitmap and append to sample
    counterWritten = 0
    #points should be chosen in random order so there is no bias caused by scanning them 
    np.random.shuffle(points3d)

    maxZDiff = range[2]*config.Z_THRESHOLD
    counter = 0
    for p in points3d:
        #position in arrays
        x = int((p[0]-minX)/step[0])
        y = int((p[1]-minY)/step[1])
        if newSize == 1:
            x = 0
            y = 0
        grid[x][y].append(counter)
        counter+=1
        index = y*(dimensionSize[0])+x
        if newSize == 1:
            index = 0
        if bitmap[index] !=0:
            #continue           #overhang switch
            diff = abs(bitmap[index] - p[2])
            if diff>maxZDiff:
                #overhang found - need to switch function
                if index not in overhangs:
                    overhangs.append(index)        #index of cell with overhang is saved
            elif bitmap[index]<p[2]:
                bitmap[index]=p[2]
        else:
            bitmap[index] = p[2]
            sample[index] = p
            counterWritten +=1
        #at the beggining I made array of XY size, but there are holes in data, so there will be some zeros, making array not entirely full (there is space, there is zero)

        #for visualization delete zeros from "sample" - for onward processing it is better not to have more zeros there, but it could be useful for holes localization
    condition = np.all(sample != [0, 0, 0], axis=1)

        # use condition to filter only points that are not [0,0,0]
    filtered_sample = sample[condition]
    if not newSize == 1:
        dimensionSize[0]+=1
        dimensionSize[1]+=1
    return [minX,minY,minZ],[maxX, maxY, maxZ], step, dimensionSize, grid, points3d, filtered_sample, overhangs #filtered_sample, sample


#function to analyze cells and decide which are too sparse
#param: grid and size of grid
#ret: x,y = grid array but only with sizes instead of points in array; c,s = color and size for visualization; avg = average number of points in cell; sparseIndexes = indexes of sparse cells; sparsePoints = position of those sparse cells 
def analyseGrid(indexesRange, grid):
    x = list()
    y = list()
    c = list()
    s = list()
    avg = 0
    min=float('inf')
    max = -float('inf')
    minPoint = [0,0]
    maxPoint = [0,0]
    for i in range(indexesRange[0]):
        for j in range(indexesRange[1]):
            length = len(grid[i][j])
            x.append(i) 
            y.append(j)       
            c.append(length)
            s.append(length/50)
            if min > length:
                min = length
                minPoint = [i,j]
            if max < length:
                max = length
                maxPoint = [i,j]
            avg+=length
    avg/=indexesRange[0]*indexesRange[1]
    sparseIndexes = list()
    sparsePointsX = list()
    sparsePointsY = list()
    for i in range(indexesRange[0]):
        for j in range(indexesRange[1]):
            if len(grid[i][j])<avg*config.SPARSE_PLACE_THRESHOLD:
                sparseIndexes.append(i+j*indexesRange[0])
                sparsePointsX.append(i)
                sparsePointsY.append(j)
    sparsePoints = np.array([sparsePointsX, sparsePointsY]).T

    utils.printText("min # of points in cell = {} in cell: {}".format(min,minPoint))
    utils.printText("max # of points in cell = {} in cell: {}".format(max,maxPoint))
    return np.array([x, y]).T, c, s, avg, sparseIndexes, sparsePoints


#function that takes sparse cells and connect them with sparse neighbours
#after that connect it with vicinity and then bigger rectangular area
#this function works recursively
#params: grid, position of sparse cell (x,y) in question, radius for checking, threshold - for when is cell undersampled, size of grid (xRange, yRange), list of visited and sparse visited cells for recursion
#ret: list of visited and sparse visited cells for recursion
def checkAround(grid, x, y, checkRadius, threshold, xRange, yRange, depth, sparseVisited=list(),visited=list()):
    checkAroundDepth = [4,10,25]
    if depth == 0:
        sparseVisited=list()
        visited=list()
        sparseVisited.append(x+y*xRange)
        
    if (x+y*xRange) not in visited and checkRadius > 0 and x in grid and y in grid[x]:
        visited.append(x+y*xRange)
        delta = checkRadius
        if depth > checkAroundDepth[2]:
            delta-=1
        if depth > checkAroundDepth[1]:
            delta -=1
        if depth > checkAroundDepth[0]:
            delta -=1
        for dx in range(-delta,delta+1):
            for dy in range(-delta,delta+1):
                if not (dx == 0 and dy == 0):
                    new_x = x + dx
                    new_y = y + dy #neighbours
                    if new_x > 0 and new_x < xRange and new_y > 0 and new_y < yRange:
                        if len(grid[new_x][new_y]) < threshold:
                            sparseVisited.append(new_x+new_y*xRange)
                            visited1, sparseVisited1 = checkAround(grid, new_x, new_y, delta, threshold, xRange, yRange, depth+1,sparseVisited, visited)
                            for v in visited1:
                                if v not in visited:
                                    visited.append(v)
                            for s in sparseVisited1:
                                if s not in sparseVisited:
                                    sparseVisited.append(s)
                        else:
                            if (new_x+new_y*xRange) not in visited:
                                visited.append(new_x+new_y*xRange) 
    return visited, sparseVisited


#get fit plane and return its normal vector
#param: set of points in question
#ret: normal vector of those points
def getNormalOfBestFitPlane(criticalPoints):
    points = getPointsForPlaneConstruction(criticalPoints)
    # Ensure points is a NumPy array
    points = np.array(points)
    # Centroid of the points
    centroid = np.mean(points, axis=0)
    # Subtract the centroid to center the points
    centered_points = points - centroid
    # Use Singular Value Decomposition (SVD)
    _, _, v = np.linalg.svd(centered_points)
    # The normal vector of the plane is the last column of v
    normal_vector = v[-1, :]
    return normal_vector


#get corner points of set for fit plane construction
#param: set of points
#ret: corner points
def getPointsForPlaneConstruction(criticalPoints):
    resultX, resultY, resultZ = list(), list(), list()
    minP = [float('inf'), float('inf'), 0]
    maxP = [-float('inf'), -float('inf'), 0]
    minMaxP = criticalPoints[0]
    maxMinP = criticalPoints[0]

    for p in criticalPoints:
        if minP[0] + minP[1] > p[0] + p[1]:
            minP = p
        if maxP[0] + maxP[1] < p[0] + p[1]:
            maxP = p
        xDiff1 = minMaxP[0] - p[0]
        yDiff1 = p[1] - minMaxP[1]
        if xDiff1 + yDiff1 > 0:
            minMaxP = p
        xDiff2 = p[0] - maxMinP[0]
        yDiff2 = maxMinP[1] -  p[1]
        if xDiff2 + yDiff2 > 0:
            maxMinP = p
        
    resultX.append(minP[0])
    resultX.append(maxP[0])
    resultX.append(minMaxP[0])
    resultX.append(maxMinP[0])
    resultY.append(minP[1])
    resultY.append(maxP[1])
    resultY.append(minMaxP[1])
    resultY.append(maxMinP[1])
    resultZ.append(minP[2])
    resultZ.append(maxP[2])
    resultZ.append(minMaxP[2])
    resultZ.append(maxMinP[2])
    result = np.array([resultX, resultY, resultZ]).T
    return result

#construct triangular mesh over given 2D points, locates too big triangles and generate point in every one of them
#param: 2D points or points to be flattened
#ret: fixed 2D points
def fix2dWithMeans(criticalPoints):
    points2d = criticalPoints[:, :2]
    iter = 0
    repeat = True
    average_area = 0
    counter = 0
    while(repeat):
        repeat=False
        triangulation = Delaunay(points2d)
        triangles = points2d[triangulation.simplices]

        # for many points its better to work with polygons than only with triangles
        polygons = [Polygon(triangle) for triangle in triangles]
        if average_area == 0:
            average_area = np.mean([polygon.area for polygon in polygons])
        selected_triangles = []
        for i, polygon in enumerate(polygons):
            #if area of triangle is too big, save the triangle for reparation
            if polygon.area > config.TRIANGLE_SIZE_THRESHOLD * average_area:
                selected_triangles.append(triangles[i])

        centroids = np.zeros((len(selected_triangles), 2)) 

        for triangle_index, triangle in enumerate(selected_triangles):
            centroid = np.mean(triangle, axis=0)
            # adding points
            points2d = np.vstack([points2d, centroid])
            centroids[triangle_index] = centroid
            repeat = True
            iter += 1  
        #you can show your triangles and big triangles and new points here



        counter+=1  

    utils.printText("Number of generated points in working set: {}".format(iter))
    return points2d




def sign(p1, p2, p3):
    return (p1[0] - p3[0]) * (p2[1] - p3[1]) - (p2[0] - p3[0]) * (p1[1] - p3[1])


def point_in_triangle(pt, triangle):
    v1, v2, v3 = triangle[0], triangle[1], triangle[2]
    d1 = sign(pt, v1, v2)
    d2 = sign(pt, v2, v3)
    d3 = sign(pt, v3, v1)

    has_neg = (d1 < 0) or (d2 < 0) or (d3 < 0)
    has_pos = (d1 > 0) or (d2 > 0) or (d3 > 0)

    return not (has_neg and has_pos)

#another function like fix with means - experimental
def fix2dWithGeneratedData(criticalPoints):                             
    resultListX, resultListY, resultListZ = zip(*criticalPoints)
    points = criticalPoints
    minX = sys.float_info.max
    maxX = -sys.float_info.max
    minY = sys.float_info.max
    maxY = -sys.float_info.max
    for p in points:
        if minX > p[0]:
            minX = p[0]
        elif maxX < p[0]:
            maxX = p[0]

        if minY > p[1]:
            minY = p[1]
        elif maxY < p[1]:
            maxY = p[1]

    extreams = [minX, minY, maxX, maxY]
    rangeXY = [(maxX-minX), (maxY-minY)]
    ratio = rangeXY[1]/rangeXY[0]
    newX = math.sqrt(len(criticalPoints)/ratio)
    dimensionSize = [int(newX), int(newX * ratio)]
    utils.printText(dimensionSize)
    
    x=list()
    y=list()      
    for i in range(0, dimensionSize[0]+1):
        for j in range(0, dimensionSize[1]+1):
            x.append(i*rangeXY[0]/dimensionSize[0]+minX)
            y.append(j*rangeXY[1]/dimensionSize[1]+minY)

    patternData = np.array([x,y]).T
    utils.showAndAdd_2d(criticalPoints, patternData, "blue", 2)

    #------------------------------------------------filter------------------------------------------------
    points2d = criticalPoints[:, :2]
    iter = 0
    average_area = 0
    triangulation = Delaunay(points2d)
    triangles = points2d[triangulation.simplices]

    # polygons are better for more and close points
    polygons = [Polygon(triangle) for triangle in triangles]
    if average_area == 0:
        average_area = np.mean([polygon.area for polygon in polygons])

    #Too big trangles are stored for reparation later
    selected_triangles = []
    for i, polygon in enumerate(polygons):
        if polygon.area > config.TRIANGLE_SIZE_THRESHOLD * average_area:
            selected_triangles.append(triangles[i])

    for p in patternData:        
        for triangle in selected_triangles:
            if point_in_triangle(p,triangle):
                utils.printText(p)
                resultListX.append(p[0])
                resultListY.append(p[1])
                resultListZ.append(p[2])
                break
            continue

    result = np.array([resultListX, resultListY, resultListZ]).T
    return result


#takes points and mesh of the old geometry and interpolates new points 
#param: old geometry structure, new repaired 2D points
#ret: repaired points describing old geometry
def move_points_to_surface(surface_points_3d, plane_points_2d):
    # Triangulate the surface points
    tri = Delaunay(surface_points_3d[:, :2])
    
    # Create an interpolator for the Z coordinate
    interpolator = LinearNDInterpolator(tri, surface_points_3d[:, 2])
    
    # Add a Z coordinate to the plane points
    plane_points_3d = np.zeros((plane_points_2d.shape[0], 3))
    plane_points_3d[:, :2] = plane_points_2d
    plane_points_3d[:, 2] = interpolator(plane_points_2d)
    
    return plane_points_3d


#function merges repaired points and "not touched" points
#params: grid, list of repaired cells, list of all visited cells, size of grid and all points
#ret: whole repaired dataset as one "package"
def packPointsIntoOneDataset(grid, repairedPoints, allVisited, indexesRange, points):
    mergedPoints = list()
    allVisited = sorted(allVisited)
    for x in range(0,indexesRange[0]):
        for y in range(0,indexesRange[1]):
            index = x + indexesRange[0] * y
            if index not in allVisited:                
                for p in grid[x][y]:
                    if math.isnan(points[p][0]) or  math.isnan(points[p][2]) or  math.isnan(points[p][2]):
                        continue
                    mergedPoints.append(points[p])
    

    for r in repairedPoints:
        for p in r:
            if math.isnan(p[0]) or  math.isnan(p[2]) or  math.isnan(p[2]):
                continue
            mergedPoints.append(p)

    utils.printText("points in dataset: {}".format(len(mergedPoints)))
    return mergedPoints


#function that will sequentally fix undersampled points
# -> move points to [0,0,0] -> rotate them, project them into 2D and save 3D mesh of old geometry -> repair 2D -> aproximate new points into old geometry -> rotate and return points back to original location and angle
#main function for reparation of found flaud dataset
#param: flaud points, position from [0,0,0]
def resolveFlatArray(criticalPoints, minValue):
    movedCritical = pointFlatter.moveToZero(criticalPoints, minValue)
    flatPoints = pointFlatter.projectPoints(criticalPoints.copy())
    normal = pointFlatter.getNormal(flatPoints.copy())
    if np.isnan(normal).any():
        normal=[0,0,1]
    rotatedFlat = pointFlatter.rotatePlane(flatPoints.copy(),normal, [0,0,1])
    rotatedCritical = pointFlatter.rotatePlane(movedCritical.copy(),normal, [0,0,1])
    fixedFlat2d = fix2dWithMeans(rotatedFlat.copy())
    reconstructedPoints = move_points_to_surface(rotatedCritical, fixedFlat2d.copy()) 
    rotatedFixedReconstructedPoints = pointFlatter.rotatePlane(reconstructedPoints.copy(),[0,0,1], normal)
    movedResult = pointFlatter.moveBackToMin(rotatedFixedReconstructedPoints, minValue)
    return movedResult