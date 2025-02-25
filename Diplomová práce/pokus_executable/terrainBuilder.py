from mpl_toolkits import mplot3d
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import random
import math
import utils
import plotly.graph_objs as go
from shapely.geometry import Point, Polygon

#prepare rectangle with hole - linear random
x=list()
y=list()
for i in range(0,100):
    for j in range(0,100):
        a = random.randint(0,10000)/10000
        b = random.randint(0,10000)/10000
        if a < 0.45 or a > 0.55 or b < 0.45 or b > 0.55:
            x.append(a)
            y.append(b)
points = np.array([x,y]).T

#prepare rectangle with hole - gauss random
x1=list()
y1=list()
for i in range(0,100):
    for j in range(0,100):
        a = random.randint(0,5000)/10000+random.randint(0,5000)/10000
        b = random.randint(0,5000)/10000+random.randint(0,5000)/10000
        if a < 0.45 or a > 0.55 or b < 0.45 or b > 0.55:
            x1.append(a)
            y1.append(b)
points1 = np.array([x1,y1]).T

#rectangle with hole in middle - sparse in center and corners and more points on sides
x2=list()
y2=list()
for i in range(0,110):
    for j in range(0,110):
        if i < 25:
            a = 1.2 - (random.randint(0,3000)/10000+random.randint(0,3500)/10000)
            b = random.randint(0,5000)/10000+random.randint(0,5000)/10000
        elif i < 50:
            a = -0.2 + (random.randint(0,3000)/10000+random.randint(0,3500)/10000)
            b = random.randint(0,5000)/10000+random.randint(0,5000)/10000
        elif i < 75:
            b = 1.2 - (random.randint(0,3000)/10000+random.randint(0,3500)/10000)
            a = random.randint(0,5000)/10000+random.randint(0,5000)/10000
        else:
            b = -0.2 + (random.randint(0,3000)/10000+random.randint(0,3500)/10000)
            a = random.randint(0,5000)/10000+random.randint(0,5000)/10000
        
        if a > 1:
            a -= 2*(a-1)
        elif a < 0:
            a -= 2*a
        if b > 1:
            b -= 2*(b-1)
        elif b < 0:
            b -= 2*b
        if a < 0.45 or a > 0.55 or b < 0.45 or b > 0.55:
            
            x2.append(a)
            y2.append(b)
            
points2 = np.array([x2,y2]).T


#move points from 2D into 3D wave
c=0
z=list()
for i in y:
    a = pow(i,4)
    a += math.sin(i*2.5+a)
    z.append(a)
points3 = np.array([x,y,z]).T
utils.show(points3)
#save them
with open('custom4.txt', 'w') as file:
    file.write("{}\n".format(len(x2)))
    for a,b,c in zip(x,y,z):
        str = ("{} {} {}\n".format(a,b,c))
        file.write(str)

#move points from 2D into 3D hill
c=0
z1=list()
for i,j in zip(x,y):
    a = 0
    a += math.sin(i*math.pi)
    a += math.sin(j*math.pi)
    z1.append(a/2)
points4 = np.array([x,y,z1]).T
utils.show(points4)
#save them
with open('custom1.txt', 'w') as file:
    file.write("{}\n".format(len(x2)))
    for a,b,c in zip(x,y,z1):
        str = ("{} {} {}\n".format(a,b,c))
        file.write(str)

#move points from 2D into 3D bowl
c=0
z2=list()
for i,j in zip(x2,y2):
    a = 1
    a -= math.sin(i*math.pi)
    a -= math.sin(j*math.pi)
    z2.append(a/2)
points5 = np.array([x2,y2,z2]).T
utils.show(points5)
#save
with open('custom2.txt', 'w') as file:
    file.write("{}\n".format(len(x2)))
    for a,b,c in zip(x2,y2,z2):
        str = ("{} {} {}\n".format(a,b,c))
        file.write(str)


#prepare 2D plane with hole but give it z coordinate
x=list()
y=list()
for i in range(0,100):
    for j in range(0,100):
        a = random.randint(0,10000)/10000
        b = random.randint(0,10000)/10000
        if a < 0.45 or a > 0.55 or b < 0.45 or b > 0.55:
            x.append(a)
            y.append(b)
z3=list()
for p in x:
    z3.append(0.1)
#and save
with open('custom3.txt', 'w') as file:
    file.write("{}\n".format(len(x2)))
    for a,b,c in zip(x,y,z3):
        str = ("{} {} {}\n".format(a,b,c))
        file.write(str)

#save more different custom datasets
with open('random3d.txt', 'w') as file:
    file.write("{}\n".format(len(x)))
    for a,b,c in zip(x,y,z):
        str = ("{} {} {}\n".format(a,b,c))
        file.write(str)

with open('random2d.txt', 'w') as file:
    file.write("{}\n".format(len(x)))
    for a,b in zip(x,y):
        str = ("{} {}\n".format(a,b))
        file.write(str)
    file.close()

with open('dense3d.txt', 'w') as file:
    file.write("{}\n".format(len(x1)))
    for a,b,c in zip(x1,y1,z1):
        str = ("{} {} {}\n".format(a,b,c))
        file.write(str)

with open('dense2d.txt', 'w') as file:
    file.write("{}\n".format(len(x1)))
    for a,b in zip(x1,y1):
        str = ("{} {}\n".format(a,b))
        file.write(str)
    file.close()
    
with open('sparse3d.txt', 'w') as file:
    file.write("{}\n".format(len(x2)))
    for a,b,c in zip(x2,y2,z2):
        str = ("{} {} {}\n".format(a,b,c))
        file.write(str)

with open('sparse2d.txt', 'w') as file:
    file.write("{}\n".format(len(x2)))
    for a,b in zip(x2,y2):
        str = ("{} {}\n".format(a,b))
        file.write(str)
    file.close()
    

#prepare custom overhang
#2D plane that will be move into 3D
x=list()
y=list()
for i in range(0,100):
    for j in range(0,int(100*0.7)):
        a = random.randint(0,10000)/10000
        b = random.randint(0,7000)/10000
        x.append(a)
        y.append(b)
#wave on top and one wall
z=list()
for i in y:
    a = pow(i,4)
    a = math.sin(i*3+a)
    z.append(a)
#plane down
for i in range(0,100):
    for j in range(0,int(100*0.7)):
        a = random.randint(0,10000)/10000
        b = random.randint(3000,10000)/10000
        x.append(a)
        y.append(b)
        z.append(0)
#inner wall in overhang
for i in range(0,100):
    for j in range(0,int(100*0.4)):
        a = random.randint(0,10000)/10000
        b = random.randint(3000,7000)/10000
        #if a < 0.3 or a > 0.7 or b < 0.4 or b > 0.6:
        x.append(a)
        y.append(b)
        z.append(0.7*2.5*(b-0.3))

points6 = np.array([x,y,z]).T
#save it
with open('overhang.txt', 'w') as file:
    file.write("{}\n".format(len(x)))
    for a,b,c in zip(x,y,z):
        str = ("{} {} {}\n".format(a,b,c))
        file.write(str)



#create bigger field with sparse cells and overhang in the middle
#start with overhang
x=list()
y=list()
for i in range(0,100):
    for j in range(0,int(100*0.7)):
        a = random.randint(0,10000)/10000
        b = random.randint(0,7000)/10000
        x.append(a)
        y.append(b)


z=list()
for i in y:
    a = pow(i,4)
    a = math.sin(i*3+a)
    z.append(a+1)
    

for i in range(0,100):
    for j in range(0,int(100*0.7)):
        a = random.randint(0,10000)/10000
        b = random.randint(3000,10000)/10000
        x.append(a)
        y.append(b)
        z.append(1)

for i in range(0,100):
    for j in range(0,int(100*0.4)):
        a = random.randint(0,10000)/10000
        b = random.randint(3000,7000)/10000
        if a < 0.3 or a > 0.7 or b < 0.4 or b > 0.6:
            x.append(a)
            y.append(b)
            z.append(0.7*2.5*(b-0.3)+1)
#create some parts of field
#_____________________________________________________________--
for i in range(0,110):
    for j in range(0,110):
        if i < 25:
            a = 1.2 - (random.randint(0,3000)/10000+random.randint(0,3500)/10000)
            b = random.randint(0,5000)/10000+random.randint(0,5000)/10000
        elif i < 50:
            a = -0.2 + (random.randint(0,3000)/10000+random.randint(0,3500)/10000)
            b = random.randint(0,5000)/10000+random.randint(0,5000)/10000
        elif i < 75:
            b = 1.2 - (random.randint(0,3000)/10000+random.randint(0,3500)/10000)
            a = random.randint(0,5000)/10000+random.randint(0,5000)/10000
        else:
            b = -0.2 + (random.randint(0,3000)/10000+random.randint(0,3500)/10000)
            a = random.randint(0,5000)/10000+random.randint(0,5000)/10000
        
        if a > 1:
            a -= 2*(a-1)
        elif a < 0:
            a -= 2*a
        if b > 1:
            b -= 2*(b-1)
        elif b < 0:
            b -= 2*b
        

        x.append(a+1)
        y.append(b-1)
        z.append(1)
        x.append(a)
        y.append(b-1)
        z.append(1)
        if a < 0.45 or a > 0.55 or b < 0.45 or b > 0.55:               
            x.append(a-1)
            y.append(b)
            z.append(1)
            x.append(a+1)
            y.append(b)
            z.append(1)
#create different parts of field differently
#______________________________________________________________________________________-
for i in range(0,100):
    for j in range(0,100):
        a = random.randint(0,5000)/10000+random.randint(0,5000)/10000
        b = random.randint(0,5000)/10000+random.randint(0,5000)/10000
        x.append(a)
        y.append(b+1)            
        z.append(1)
        x.append(a+1)
        y.append(b+1)            
        z.append(1)
        x.append(a-1)
        y.append(b-1)            
        z.append(1)

for i in range(0,100):
    for j in range(0,100):
        a = random.randint(0,10000)/10000
        b = random.randint(0,10000)/10000
        x.append(a-1)
        y.append(b+1)
        z.append(1)

points7 = np.array([x,y,z]).T
utils.show(points7)
#save
with open('overhang_field.txt', 'w') as file:
    file.write("{}\n".format(len(x)))
    for a,b,c in zip(x,y,z):
        str = ("{} {} {}\n".format(a,b,c))
        file.write(str)



#geometry of 2 overhang with hole
x=list()
y=list()
for i in range(0,100):
    for j in range(0,int(100*0.7)):
        a = random.randint(0,10000)/10000
        b = random.randint(3000,7000)/10000
        x.append(a)
        y.append(b)


z=list()
for i in y:
    a = pow(i,4)
    a = math.sin(i*3+a)
    z.append(a)
    
counter = 0
for i in range(0,100):
    for j in range(0,int(100*0.7)):
        a = random.randint(0,10000)/10000
        b = random.randint(3000,7000)/10000
        counter+=1
        x.append(a)
        y.append(b)
        z.append(0)

for i in range(0,100):
    for j in range(0,int(100*0.4)):
        a = random.randint(0,10000)/10000
        b = random.randint(3000,7000)/10000
        if a < 0.3 or a > 0.7 or b < 0.4 or b > 0.6:
            x.append(a)
            y.append(b)
            z.append(0.7*2.5*(b-0.3))

points6 = np.array([x,y,z]).T
utils.showInteractive(points6)
#save it
with open('2_hole.txt', 'w') as file:
    file.write("{}\n".format(len(x)))
    for a,b,c in zip(x,y,z):
        str = ("{} {} {}\n".format(a,b,c))
        file.write(str)


#geometry of Z overhang with hole
x=list()
y=list()
z=list()
for i in range(0,100):
    for j in range(0,int(100*0.7)):
        a = random.randint(0,10000)/10000
        b = random.randint(0,7000)/10000
        x.append(a)
        y.append(b)
        z.append(1)
    

for i in range(0,100):
    for j in range(0,int(100*0.7)):
        a = random.randint(0,10000)/10000
        b = random.randint(3000,10000)/10000
        x.append(a)
        y.append(b)
        z.append(0)

for i in range(0,100):
    for j in range(0,int(100*0.4)):
        a = random.randint(0,10000)/10000
        b = random.randint(3000,7000)/10000
        if a < 0.3 or a > 0.7 or b < 0.4 or b > 0.6:
            x.append(a)
            y.append(b)
            z.append(2.5*(b)-0.75)

print(len(x))
points6 = np.array([x,y,z]).T
utils.showInteractive(points6)
#save it
with open('Z_hole.txt', 'w') as file:
    file.write("{}\n".format(len(x)))
    for a,b,c in zip(x,y,z):
        str = ("{} {} {}\n".format(a,b,c))
        file.write(str)


#create wave with polygon hole
def polygonHole():
    #5-point star polygon
    hole = Polygon([
    (0.5, 0.35), (0.55, 0.45), (0.65, 0.45), 
    (0.575, 0.55), (0.6, 0.65), 
    (0.5, 0.6), (0.4, 0.65), 
    (0.425, 0.55), (0.35, 0.45), 
    (0.45, 0.45)])
    x = []
    y = []
    for i in range(100):
        for j in range(100):
            while True:
                a = random.randint(0, 10000) / 10000
                b = random.randint(0, 10000) / 10000
                point = Point(a, b)
                if not hole.contains(point):
                    x.append(a)
                    y.append(b)
                    break

    return x, y

#create wave with polygon hole
x,y = polygonHole()
utils.show_2d(np.array([x, y]).T)

c=0
z=list()
for i in y:
    a = pow(i,4)
    a += math.sin(i*2.5+a)
    z.append(a)
points3d = np.array([x,y,z]).T
utils.show(points3d)
#save it
with open('customPolygon.txt', 'w') as file:
    file.write("{}\n".format(len(x)))
    for a,b,c in zip(x,y,z):
        str = ("{} {} {}\n".format(a,b,c))
        file.write(str)