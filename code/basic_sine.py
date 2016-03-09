#!/usr/bin/python

#import numpy, scipy, matplotlib

import numpy as np
import pylab as pl
import matplotlib.pyplot as plt

t = np.arange(0.0, 1.0, 0.001)
#s = 3*np.sin(2*np.pi*2*t)
#plt.plot(t, s, lw=2, color='red')
#plt.show()

t = np.arange(0.0, 2, 0.001)

s1 = 3*np.sin(2*np.pi*2*t)
s2 = 2*np.sin(2*np.pi*5*t)
s3 = s1 + s2;
plt.plot(t, s3, lw=1, color='blue')
plt.show()

#unique, counts = np.unique(s3, return_counts=True)
#print np.asarray((unique, counts)).T
