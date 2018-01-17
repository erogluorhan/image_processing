# HOtsu's Thresholding

# Description
Thresholding is generally the method of determination of segmentations in an image based on the assignment of intensity values to the specific segments with respect to threshold values. 
Threshold value might be predefined or can be computed with the help of an advanced method such as Otsu’s thresholding algorithm.  
Otsu’s algorithm is essentially based on the image statistics where the ratio of the between-class variance (σ_B^2) and within-class variance (σ_W^2) is maximized. 
Since σ_B^2 + σ_W^2 = 1, maximizing only σ_B^2 also works. 
The threshold value(s) that result in the maximum between-class variance is used to partition the image into segments. 
In order to compute the between-class variance, class prior probabilities, class means, and total mean are computed first.
