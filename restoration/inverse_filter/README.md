# Inverse Filter

# Description:
Inverse filtering is the trivial solution for restoring a degraded image when the degradation function is known. 
On the other hand, there are a number of serious handicaps with Inverse filtering. 
Let us discuss them after formulating the inverse filtering. 
A degraded image by a degradation function and additive noise can be written in the frequency domain as:

G(u,v) = H(u,v)*F(u,v) + N(u,v)

where H is the degradation transfer function and N is the noise. 

Since we know the H, we can do the Inverse filtering as follows:

Ḟ(u,v) = (G(u,v))/(H(u,v)) = F(u,v) + (N(u,v))/(H(u,v))

where  Ḟ is the restored image.

From above equations, we can see that Ḟ is not exact F, but we expect it to be close to it. 
However, since the noise is unknown, its influence on the restoration may be very big. If N has larger values compared to H, it dominates the result and we might not have a satisfactory restoration. We can cope with this problem by using the central portion of H around the origin with the help of a cutoff value. The other possibility is that problem of division by zero might occur when H has zero values.

