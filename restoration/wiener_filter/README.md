# Wiener Filter

# Description:
Wiener filter can handle the problems of the Inverse filtering since it introduces a K constant that is for tackling the Signal-to-Noise ratio (SNR). 
However, in order to use this K, Wiener filter assumes the image and noise are not correlated and they are random. 
Therefore, it can optimally restore a degraded image if the noise is stationary Gaussian. In other words, Wiener filter might fail to restore real world noisy images. 

Let us just write the final Wiener restoration function L(u,v) in the frequency domain:

L(u,v)=〖H(u,v)〗* / (|H(u,v)|^2 + K)

where  〖H(u,v)〗*  is the complex conjugate and K is the constant that is equal to 1/(SNR). Then, in order to get the restored image, we should multiply the degraded image G(u,v) with L(u,v) in frequency domain.

Ḟ(u,v)= G(u,v) * L(u,v)
