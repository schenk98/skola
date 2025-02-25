import sys
import constants
import math
import random

class Area:
    # object area constructed by 2 points and shape
    def __init__(self, type,a,b, minX=sys.float_info.max, minY=sys.float_info.max, maxX=-sys.float_info.max, maxY=sys.float_info.max):    
        self.a = a
        self.b = b
        #if area not init - init extreams, if recieved, no need to calculate
        if minX == sys.float_info.max or minY == sys.float_info.max or maxX == -sys.float_info.max or maxY == -sys.float_info.max:
            self.minX, self.minY, self.maxX, self.maxY = self.getExtreams(a,b)
        else:
            self.minX = minX
            self.minY = minY
            self.maxX = maxX
            self.maxY = maxY
        self.type = type
        self.width= abs(self.minX-self.maxX)
        self.height = abs(self.minY-self.maxY)

    #stop x,y from moving out of area stoping point on boundry "bouncing" it back
    def clampToBoundary(self, x, y):    
        while x < self.minX or x > self.maxX or y < self.minY or y > self.maxY:
            if x < self.minX:
                x = self.minX + abs(random.randrange(self.minX, self.maxX)/100)
            elif x > self.maxX:
                x = self.maxX - abs(random.randrange(self.minX, self.maxX)/100)
            if y < self.minY:
                y = self.minY + abs(random.randrange(self.minY, self.maxY)/100)
            elif y > self.maxY:
                y = self.maxY - abs(random.randrange(self.minY, self.maxY)/100)
        """
        while x < self.minX or x > self.maxX or y < self.minY or y > self.maxY:
            if x < self.minX:
                x = 2 * self.minX - (x)  # Odraz zpět na stranu minX
            elif x > self.maxX:
                x = 2 * self.maxX - (x)  # Odraz zpět na stranu maxX
            if y < self.minY:
                y = 2 * self.minY - (y)  # Odraz zpět na stranu minY
            elif y > self.maxY:
                y = 2 * self.maxY - (y)  # Odraz zpět na stranu maxY
        """
        return x, y

    # convinient getters
    def getArea(self):
        return self.type, self.a, self.b, self.minX, self.minY, self.maX, self.maxY
    
    def getMin(self):
        return self.minX, self.minY
    
    def getMax(self):
        return self.maxX, self.maxY
    
    #get extreams from corner points of plane
    def getExtreams(self, a,b):
        if a[0]>b[0]:
            minX = b[0]
            maxX = a[0]
        else:
            minX = a[0]
            maxX = b[0] 

        if a[1] > b[1]:
            minY = b[1]
            maxY = a[1]
        else:
            minY = a[1]
            maxY = b[1]
        return minX, minY, maxX, maxY
    

    # function that checks if given point is in given area
    def isInArea(self, x,y):
        if self.type == constants.ELIPSE:
            # get center and axis
            a = (self.maxX - self.minX)/2
            b = (self.maxY - self.minY)/2
            s1 = self.minX + (self.maxX-self.minX)/2
            s2 = self.minY + (self.maxY-self.minY)/2
            # get distance of the point from center with weight of axis making it 0-1 inside elipse
            res = ((x-s1)*(x-s1))/(a*a)+((y-s2)*(y-s2))/(b*b)
            if res<=1:
                return True
            else:
                return False
        
        # only rectangle is used and its trivial
        elif self.type == constants.RECTANGLE:
            if self.minX <= x and self.minY <= y and self.maxX >= x and self.maxY >= y:
                return True
            else:
                return False

        return True
  