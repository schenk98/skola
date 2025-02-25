#nacteni dat
import pandas as pd

from nltk.cluster.kmeans import KMeansClusterer
from nltk.cluster import util

import matplotlib.pyplot as plt
import numpy as np
from mpl_toolkits.mplot3d import Axes3D

from math import sqrt
import sys
import os

#print("here"+sys.argv[1])

fileName = "C:/Users/jakub/OneDrive/Plocha/bc/clustering_intro/clustering_intro/data/c"
flnm = os.path.splitext(sys.argv[0])[0]
print(flnm)
#fileName = flnm
#Square, Circle, C, Cube, Sphere, Cilinder, ...
df2 = pd.read_csv(fileName + ".txt", delimiter=" ")
#X2 = df2.sample(frac = 0.01)
X2 = df2
data2 = X2.to_numpy()
file = open(fileName + "_labels.txt", "r")
labels2 = file.read().split(" ")

labels2DF = pd.DataFrame(labels2)
#labels2 = labels2.sample(frac = 0.01)
#labels2=pd.read_csv(fileName + "_labels.txt", delimiter=" ")
centers2 = pd.read_csv(fileName + "_means.txt", delimiter=" ")
#l = labels2.to_numpy()
labels2DF.describe()
labels2 = [int(num_string) for num_string in labels2]
labels2 = np.array(labels2)



fignum2 = 1
fig2 = plt.figure(fignum2, figsize=(20,12))
ax2 = Axes3D(fig2, rect=[0, 0, .95, 1], elev=48, azim=134)

ax2.scatter(data2[:, 0], data2[:, 1], data2[:, 2], c=labels2.astype(float), edgecolor='k')
ax2.scatter(centers2.x, centers2.y, centers2.z, c="red", edgecolor='k')

ax2.w_xaxis.set_ticklabels([])
ax2.w_yaxis.set_ticklabels([])
ax2.w_zaxis.set_ticklabels([])
ax2.set_xlabel('x')
ax2.set_ylabel('y')
ax2.set_zlabel('z')
ax2.set_title('test vzdalenost')
ax2.dist = 12
fignum2 = fignum2 + 1
fig2.savefig(fileName+"_3D.png")




fig1 = plt.figure(figsize=(20, 12))
colors = ['red', 'green', 'blue', 'yellow', 'orange', 'purple', 'khaki', 'brown', 'white', 'grey']
#c=labels2.astype(np.float)      edgecolor = "k"    c=np.array(colors)[labels2]
plt.scatter(X2.x, X2.y, c=labels2.astype(float) , s=50)
plt.scatter(centers2.x, centers2.y, c="red", s=50)

plt.show()
#plt.savefig(fileName+"_2D.png")
fig1.savefig(fileName+"2_2D.png")



