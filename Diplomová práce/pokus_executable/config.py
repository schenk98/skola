#name of input file - file with all the points ready to be processed
INPUT_FILE = "./custom4.txt"
#name of output file - file to where there should be results saved
OUTPUT_FILE = "result.txt"
#number of points for reduced array - for triangular mesh and function fit
SAMPLE_SIZE = 2000
#the order of function for best fit
#functionOrder = 15
#maximal Z difference tolerated before switching function for having overhang
Z_THRESHOLD = 0.5

#treshold for what is sparse and what is ok - #points < avg*SPARSE_PLACE_THRESHOLD
SPARSE_PLACE_THRESHOLD = 0.1

#radius in which is searched for undersampled cells (from one of them) - localization of hole
SPARSE_SURROUNDINGS_RADIUS = 3

#how big triangle is too big triangle
TRIANGLE_SIZE_THRESHOLD = 4

#how much smaller can be part of overhang proportionally for part size (0,1)
OVERHANG_SPARSE_TRESHOLD = 0.05 

#separation planes for overhang splitting
OVERHANG_SPLIT_TOP = 0.95
OVERHANG_SPLIT_BOT = 0.05

#overhangs processsed
OVERHANGS_PROCESSED = False

#show plots - with more points the program is stopped while plots are oppened
SHOW_PLOTS = True

#are results shown for comparison
COMPARE_RESULTS = True

#show interactive plots in browser
SHOW_INTERACTIVE = False

#output into console (True) or into file "output_"+OUTPUT_FILE
CONSOLE_OUTPUT = True