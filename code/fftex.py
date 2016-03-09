# import scipy
import matplotlib.pyplot as pl
# import numpy as np
# from matplotlib.widgets import Slider, Button, RadioButtons

import numpy as np

PI = np.pi

sampleRate = 1000
nsec = 1.0
t=np.arange(0, nsec, 1.0/sampleRate)

signal = np.sin(2*PI*10*t)
pl.figure(1)
pl.plot(signal)
pl.title("Original_signal")

# conduct FFT
fftOut = np.fft.fft(signal)
powerSpectrum = np.abs(fftOut)
# the rest is for visualization
pl.figure(2)
pl.plot(powerSpectrum)
pl.xlabel('n')
pl.ylabel('Amplitude')

f2 = np.fft.ifft(fftOut)
pl.figure(3)
pl.plot(f2)
pl.title("Signal from inverse Fourier transform")

# Task 3
# f1 = 697Hz f2 = 1477Hz
# According to the Nyquist theorem, the sampling rate must be
# at least 2 times the highest frequency contained in the signal.
f1 = 697
f2 = 1477
sampleRate = 1500 * 2
nsec = 1.0
t=np.arange(0, nsec, 1.0/sampleRate)
signal1 = np.sin(2*PI*f1*t)
signal2 = np.sin(2*PI*f2*t)

signal3 = signal1 + signal2
pl.figure(4)
pl.plot(signal3)
pl.title("Signal for key 3")

fftOut = np.fft.fft(signal3)
powerSpectrum = np.abs(fftOut)
pl.figure(5)
pl.plot(powerSpectrum)
pl.xlabel('n')
pl.ylabel('Amplitude')

pl.show()