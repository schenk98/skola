import matplotlib.pyplot as plt
from scipy.spatial import Delaunay
from mpl_toolkits.mplot3d import Axes3D
import pointsProcessing
import utils
import numpy as np
import config

#function for overhang separation - split into 3 parts - with old code in comment
#params: points in question
#ret: 3 lists of points
def separateOverhang(criticalPoints):
    listTop, listMid, listBot = list(), list(), list()
    
    for p in criticalPoints:
        if p[2]>config.OVERHANG_SPLIT_TOP:
            listTop.append(p)
        elif p[2]<config.OVERHANG_SPLIT_BOT:
            listBot.append(p)
        else:
            listMid.append(p)
    
    """
    triangles = generate_filtered_mesh(criticalPoints, 0.0001)

    normals = calculate_triangle_normals(criticalPoints, triangles)
    # Set the threshold angle for classification
    threshold_angle = np.pi / 6  # 30 degrees in radians


    angle_cosine = np.dot(normals, [0, 0, 1])
    angles = np.arccos(angle_cosine)  # Angle between normal and [0, 0, 1] in radians
    angles = np.mod(angles, np.pi/2)

    # Classify points based on angle
    category_1_indices = np.where(np.abs(angles) <= threshold_angle)[0]
    category_2_indices = np.where(angles > np.pi - threshold_angle)[0]
    category_3_indices = np.where((angles > threshold_angle) & (angles <= np.pi - threshold_angle))[0]

    for i in range(len(criticalPoints)):
        if i in category_1_indices:
            listMid.append(criticalPoints[i])
        elif i in category_2_indices:
            listTop.append(criticalPoints[i])
        elif i in category_3_indices:
            listBot.append(criticalPoints[i])
        else:
            print("here")

    utils.show(np.array(listTop))
    utils.show(np.array(listMid))
    utils.show(np.array(listBot))
"""

    return listTop, listMid, listBot


#calculates normals of triangles
#param: points and triangles
#ret: normals of triangles
def calculate_triangle_normals(points, triangles):
    # Calculate normals of triangles
    a = points[triangles[:, 0]]
    b = points[triangles[:, 1]]
    c = points[triangles[:, 2]]

    normals = np.cross(b - a, c - a)
    norms = np.linalg.norm(normals, axis=1)
    normals /= norms[:, None]  # Normalize normals

    return normals

#filter big triangles from points - experimental
#param: points in question
#ret: big triangles
def generate_filtered_mesh(points):
    # Perform Delaunay triangulation
    tri = Delaunay(points)

    # Calculate areas of all triangles
    areas = calculate_triangle_areas(points, tri.simplices)

    # Filter out triangles larger than max_triangle_area
    filtered_triangles = tri.simplices[areas <= np.average(areas)]
    return filtered_triangles


#function for calculation of areas of points
#param: points in question and triangles for them
#ret: set of areas of triangles
def calculate_triangle_areas(points, triangles):
    # Calculate areas of triangles
    a = points[triangles[:, 0]]
    b = points[triangles[:, 1]]
    c = points[triangles[:, 2]]

    cross_product = np.cross(b - a, c - a)
    areas = 0.5 * np.linalg.norm(cross_product, axis=1)

    return areas


#one of main functions - preprocess sparse cells and overgangs in order to run repair function on them
#in case of overhangs separate them into 3 sets, repair them if needed individually and merge them afterwards
#in case of sparse cells find sparse neighbours and general area - box it into rectangular dataset and run repair function on that
#params: grid, list of sparse cells, size of grid, average of points for cell, all points from dataset, overgang candidates and position of dataset from [0,0,0]
#ret: repaired set of points and list of used cells
def repairDataset(grid, sparseIndexes, indexesRange, avg, points, overhangs, minValue):
    if len(sparseIndexes)==0 and len(overhangs)==0:
        return list(), list()
    visitedIndexes = list()
    sparseVisited = list()
    repairedPoints = list()
    counter = 0
    overhangCounter = 0
    allVisited = list()

    #resolve overhangs with higher priority
    if config.OVERHANGS_PROCESSED:
        for index in overhangs:
            if index in sparseIndexes:
                np.delete(sparseIndexes,np.where(sparseIndexes==index)[0])
                #only overhangs here and sparse in next part
            overhangCounter += 1
            x=index%indexesRange[0]            
            y=int(index/indexesRange[0])
            
            visitedIndexes, sparseVisited = pointsProcessing.checkAround(grid.copy(), x, y, config.SPARSE_SURROUNDINGS_RADIUS, avg*config.SPARSE_PLACE_THRESHOLD, indexesRange[0], indexesRange[1], 0)
            criticalPoints, _, _, _ = utils.getBoxesForVisualization(sparseVisited, indexesRange, visitedIndexes, grid, points)
            
            for v in visitedIndexes:
                if v not in allVisited:
                    allVisited.append(v)

            #separate overhangs to 3 lists of points
            listTop, listMid, listBot = separateOverhang(criticalPoints)
            overhangResult = list()

            topArea, midArea, botArea = utils.calculate_area(listTop), utils.calculate_area(listMid), utils.calculate_area(listBot)
            topRatio = len(listTop)/(topArea/(topArea + midArea + botArea))
            midRatio = len(listMid)/(midArea/(topArea + midArea + botArea))
            botRatio = len(listBot)/(botArea/(topArea + midArea + botArea))
            ratioSum = topRatio + midRatio + botRatio
            topPart = topRatio/ratioSum
            midPart = midRatio/ratioSum
            botPart = botRatio/ratioSum
            #repair individually all parts (if needed)
            if topPart < midPart - config.OVERHANG_SPARSE_TRESHOLD and topPart < botPart - config.OVERHANG_SPARSE_TRESHOLD:
                overhangResult.extend(pointsProcessing.resolveFlatArray(np.array(listTop), minValue))
            else:
                overhangResult.extend(np.array(listTop))
            if midPart < topPart - config.OVERHANG_SPARSE_TRESHOLD and midPart < botPart - config.OVERHANG_SPARSE_TRESHOLD:
                overhangResult.extend(pointsProcessing.resolveFlatArray(np.array(listMid), minValue))
            else:
                overhangResult.extend(np.array(listMid))
            if botPart < midPart - config.OVERHANG_SPARSE_TRESHOLD and botPart < topPart - config.OVERHANG_SPARSE_TRESHOLD:
                overhangResult.extend(pointsProcessing.resolveFlatArray(np.array(listBot), minValue))
            else:
                overhangResult.extend(np.array(listBot))

            repairedPoints.append(np.array(overhangResult))        
            movedResult = np.array(overhangResult)


    #sparse cells from here
    for index in sparseIndexes:
        if index in sparseVisited:
            continue
        counter+=1
        x=index%indexesRange[0]
        y=int(index/indexesRange[0])
        visitedIndexes, sparseVisited = pointsProcessing.checkAround(grid.copy(), x, y, config.SPARSE_SURROUNDINGS_RADIUS, avg*config.SPARSE_PLACE_THRESHOLD, indexesRange[0], indexesRange[1], 0)
        criticalPoints, boxSparse, boxPoints, boxWhole = utils.getBoxesForVisualization(sparseVisited, indexesRange, visitedIndexes, grid, points)
        

        for v in visitedIndexes:
            if v not in allVisited:
                allVisited.append(v)

        #function will resolve points step by step - move, rotate, flatten, fix, back to 3D, rotate back, move back
        movedResult = pointsProcessing.resolveFlatArray(criticalPoints, minValue)
        repairedPoints.append(movedResult)
        
    utils.printText("fixed {} sparse cells in {} iterations (batches)".format(len(sparseIndexes), counter))
    
    return repairedPoints, allVisited


