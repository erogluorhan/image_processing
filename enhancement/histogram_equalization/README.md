# Histogram Equalization

# Description:
Image equalization is a global image enhancement technique, and it is the method of making the image histogram as uniform as possible. By doing so, image has a more uniform distribution of intensities, i.e. higher contrast, in most cases, thus visual and intensity-related enhancement are obtained. 
To perform this method, first image histogram is acquired, then the probability and cumulative distributions of the intensities are calculated. After that, a mapping between the old intensities and the equalized intensities (i.e. histograms) can be simply calculated by multiplying the cumulative distributions with the highest intensity level, and then flooring the results. This mapping is known as rescaling, and is applied to the original grayscale image to convert old intensities to the new ones. The resulting image is the histogram-equalized image.

# Note that:
Channel-wise equalization for RGB images is performed in order to show that its resulting colors are somewhow defective. 
Thus, equalization for color images should be performed in HSV!
