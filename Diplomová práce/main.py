import pointsProcessing
import utils
import config
import numpy as np
import sys
import repairData
import matplotlib.pyplot as plt
import pointsProcessing
import utils
import config
import numpy as np
import sys
import repairData

"""
function for processing result and showing statistics for comparison
params: grid size, bool if visualizations should be shown
    - filename is found in config
ret: -
"""
def showResult(sampleSize, showPlots):
    utils.printText("filename {}\nsamplesize {}".format(config.OUTPUT_FILE,sampleSize))
    minValue, maxValue, step, indexesRange, grid, points, sample, overhangs = pointsProcessing.processPoints(sampleSize, config.OUTPUT_FILE)
    if config.SHOW_INTERACTIVE and showPlots:
        utils.showInteractive(sample)
    utils.printText("dataset contains {} points".format(len(points)))
    utils.printText("step: {}".format(step))
    utils.printText("indexesRange: {}x{}={}, ".format(indexesRange[0], indexesRange[1], indexesRange[0]*indexesRange[1]))
    utils.printText("A:[{}, {}] \t B:[{}, {}]".format(minValue[0], minValue[1], maxValue[0], maxValue[1]))


    #function to analyze cells and decide which are too sparse
    #   pointsGrid = grid array but only with sizes instead of points in array; c,s = color and size for visualization; avg = average number of points in cell; sparseIndexes = indexes of sparse cells; sparsePoints = position of those sparse cells 
    pointsGrid, c, s, avg, sparseIndexes, sparsePoints = pointsProcessing.analyseGrid(indexesRange, grid)
    utils.printText("avg: {}\t {}% = {}".format(avg, config.SPARSE_PLACE_THRESHOLD*100, avg*config.SPARSE_PLACE_THRESHOLD))
    utils.printText("sparse cells: {}".format(len(sparsePoints)))
    utils.printText("overhang cells: {}".format(len(overhangs)))

    if showPlots:
        utils.showAndAdd_2d(pointsGrid, sparsePoints, c, s, "Result grid")
        utils.show(points)


"""
main function for data manipulation and whole process enclosing

params: input file path, size of grid, boolean if there should be shown visualizations
ret: -
"""
def fixData(filename=config.INPUT_FILE, sampleSize=config.SAMPLE_SIZE, showPlots=config.SHOW_PLOTS):
    """
    ----------------------------- CHECK CONFIG --------------------------------------------------
    """
    configUsable, filename, sampleSize = utils.checkConfig(filename, sampleSize)
    if not configUsable:
        utils.printText("There is an error in configuration, please correct it before running program again.")
        sys.exit()
    """
    ----------------------------- PREPARE DATA --------------------------------------------------
    """
    utils.printText("filename {}\nsamplesize {}".format(filename,sampleSize))
    #function loads points from input file, in even intervals picks points into sample array for easier processing
    #   arguments are not needed, can be changed in config.py -> giving arguments beats config (size of sample array and # grid cells, name of input file)
    #   min/maxValue = boundaries; step = size of grid cell area; indexesRange = size of grid indexes; grid = array of cells containing poins in its area; points = read points from file; sample = sampled points from each grid cell one
    minValue, maxValue, step, indexesRange, grid, points, sample, overhangs = pointsProcessing.processPoints(sampleSize, filename)
    if showPlots:
        if len(points) < 50000:
            utils.show(points, "Initial dataset")
        if config.SHOW_INTERACTIVE:
            utils.showInteractive(sample) 
        if len(points) >= 50000 and not config.SHOW_INTERACTIVE:
            utils.show(sample, "Initial dataset - sample")     
    
    utils.printText("dataset contains {} points".format(len(points)))
    utils.printText("step: {}".format(step))
    utils.printText("indexesRange: {}x{}={}, ".format(indexesRange[0], indexesRange[1], indexesRange[0]*indexesRange[1]))
    utils.printText("A:[{}, {}] \t B:[{}, {}]".format(minValue[0], minValue[1], maxValue[0], maxValue[1]))

    """
    ----------------------------- ANALYZE DATA --------------------------------------------------
    """
    #function to analyze cells and decide which are too sparse
    #   pointsGrid = grid array but only with sizes instead of points in array; c,s = color and size for visualization; avg = average number of points in cell; sparseIndexes = indexes of sparse cells; sparsePoints = position of those sparse cells 
    pointsGrid, c, s, avg, sparseIndexes, sparsePoints = pointsProcessing.analyseGrid(indexesRange, grid)
    utils.printText("avg: {}\t {}% = {}".format(avg, config.SPARSE_PLACE_THRESHOLD*100, avg*config.SPARSE_PLACE_THRESHOLD))
    utils.printText("sparse cells: {}".format(len(sparsePoints)))
    utils.printText("overhang cells: {}".format(len(overhangs)))
    if showPlots:
        utils.showAndAdd_2d(pointsGrid, sparsePoints, c, s, "Initial grid")

    """
    ----------------------------- REPAIR DATA --------------------------------------------------
    """
    repairedPoints, allVisited = repairData.repairDataset(grid, sparseIndexes, indexesRange, avg, points, overhangs, minValue)
    """
    ----------------------------- STORE REPAIRED DATA --------------------------------------------------
    """
    packedPoints = pointsProcessing.packPointsIntoOneDataset(grid, repairedPoints, allVisited, indexesRange, points)
    utils.storePoints(packedPoints, config.OUTPUT_FILE)
    utils.printText("\n--------------------------------- POINTS SAVED ----------------------------------\n")

    if config.COMPARE_RESULTS==True:
        showResult(sampleSize, showPlots)
    utils.printText("-------------------------------------------------------\nEND OF THE PROGRAM\n-------------------------------------------------------")





"""
----------------------------- MAIN --------------------------------------------------
"""


if __name__ == "__main__":
    filename = config.INPUT_FILE
    sampleSize = config.SAMPLE_SIZE
    showPlots = config.SHOW_PLOTS
    if len(sys.argv) > 1:
        filename = sys.argv[1]
    if len(sys.argv) > 2:
        sampleSize = sys.argv[2]
    if len(sys.argv) > 3:
        if sys.argv[3] == "True" or sys.argv[3] == "true" or sys.argv[3] == "t" or sys.argv[3] == "1":
            showPlots = True
        if sys.argv[3] == "False" or sys.argv[3] == "false" or sys.argv[3] == "f" or sys.argv[3] == "0":
            showPlots = False
    
    
    fixData(filename, sampleSize, showPlots)    #   "../BILO59_5g.xyz"  "./real1.txt"    "./custom4.txt"
    plt.show(block=True)
