# Motion Blur

# Description:
Linear motion blur degradation on an image results from the relative motion between the scene and the imaging device.  
We can simulate this motion as a planar motion, i.e. the distance between the scene and the device remains constant, by taking constant horizontal and vertical velocities a and b, and the exposure time T. 
Thus, we can write the linear motion blur degradation function in the frequency domain as follows:

H(u,v) = (sin⁡(π(ua+vb)T)) / (π(ua+vb)) e^(-jπ(ua+vb)T)

where u and v are frequency domain coordinates after fftshifting the frequency domain image. 

A tricky case exists here. The equation of degradation function may cause division by zero problems; thus, converting it to a sinc function is an easy and guaranteed method to get rid of this issue.  
In conclusion, multiplying an image’s frequency domain representation F by this degradation function H, we can simulate the linear motion blur effect.
