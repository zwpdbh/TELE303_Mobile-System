#!/usr/bin/python

import scipy
import matplotlib.pyplot as pl
import numpy as np
from matplotlib.widgets import Slider, Button, RadioButtons

# generate the first subplot - signal
ax = pl.subplot(111)
pl.subplots_adjust(left=0.15, bottom=0.35)
t = np.arange(0.0, 1.0, 0.001)

a0 = 5
f0 = 3
p0 = 0
s = a0*np.sin(2*np.pi*f0*t)
l, = pl.plot(t,s,lw=2,color='red')
pl.axis([0,1,-10,10])

axColor = 'lightgoldenrodyellow'
axFreq = pl.axes([0.15, 0.2, 0.65, 0.03], axisbg=axColor)
axAmp = pl.axes([0.15, 0.15, 0.65, 0.03], axisbg=axColor)
axPh = pl.axes([0.15, 0.1, 0.65, 0.03], axisbg=axColor)

sFreq = Slider(axFreq, 'Fred', 0.1, 30.0, valinit=f0)
sAmp = Slider(axAmp, 'Amp', 0.1, 10.0, valinit=a0)
sPh = Slider(axPh, 'Phase', -180, 180.0, valinit=p0)

def update(val):
    amp = sAmp.val
    freq = sFreq.val
    ph = sPh.val
    l.set_ydata(amp*np.sin(2*np.pi*freq*t + ph/180.0*np.pi))
    pl.draw()

sFreq.on_changed(update)
sAmp.on_changed(update)
sPh.on_changed(update)

resetax = pl.axes([0.8, 0025, 0.1, 0.04])
button = Button(resetax, 'Reset', color=axColor, hovercolor='0.975')
def reset(event):
    sFreq.reset()
    sAmp.reset()
    sPh.reset()
button.on_clicked(reset)
pl.show()