#pre req
#pip install numpy
#python -m pip install -U pip
#python -m pip install -U matplotlib

import numpy as np
import matplotlib.pyplot as plt
from matplotlib.transforms import Affine2D

#define function = def
def get_transform_2pts(q1, q2, p1, p2):
    """ create transform to transform from q to p, 
        such that q1 will point to p1, and q2 to p2 """
    ang = np.arctan((p2-p1)[1] /(p2-p1)[0])-np.arctan((q2-q1)[1] /(q2-q1)[0])
    s = np.abs(np.sqrt(np.sum((p2-p1)**2))/np.sqrt(np.sum((q2-q1)**2)))
    trans = Affine2D().translate(*-q1).rotate(ang).scale(s).translate(*p1)
    return trans

#define box
plt.title = "test"

image = plt.imread("https://i.stack.imgur.com/ue5oH.png")
#image = plt.imread("C:\Users\marcel\Desktop\StarCitizen Tools\Projekt Jericho (3D Navigation)_V6\maps\Microtech.jpg")
y0 = image.shape[0]
waypoints = [[0, -1, -4, -6, -6], [0, 0, 4, 4, 3]]

# Coordinates for transformation.
lc1 = np.array([0,0])
ic1 = np.array([475, y0-187])

lc2 = np.array([-1, 0])
ic2 = np.array([437, y0-194])

trans = get_transform_2pts(lc1, lc2, ic1, ic2)

fig, ax = plt.subplots()

ax.imshow(np.flipud(image), origin="lower")

plt.plot(waypoints[0], waypoints[1], 'o-', transform=trans+ax.transData)

ax.set_aspect("equal")
plt.show()