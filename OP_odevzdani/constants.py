#generate type constants
LINEAR = 0
GAUSS = 1
REGULAR = 2
HAMMERSLY = 3
LP = 4
JITTER = 5
SEMI_JITTER=6
N_ROOKS=7
POISSON=8
MITCHEL=9
LLOYD=10
CCPD=11

# generate type dictinoary
generateType = dict()
generateType["Linear random"]=LINEAR
generateType["Gaussian random"]=GAUSS
generateType["Regular"]=REGULAR
generateType["Hammersly"]=HAMMERSLY
generateType["Larcher-Pillichshammer"]=LP
generateType["Jittering"]=JITTER
generateType["Semi-Jittering"]=SEMI_JITTER
generateType["N-Rooks"]=N_ROOKS
generateType["Poisson-disc"]=POISSON
generateType["Mitchel"]=MITCHEL
generateType["Lloyd"]=LLOYD
generateType["Simple CCPD"]=CCPD

#shape constants
RECTANGLE = 0
ELIPSE = 1


#consts
MAX_ITER_BUTTON_COLOR = 50   #max iter for lloyd and ccpd when button turns orange