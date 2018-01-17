# Histogram Specification

# Description:
Image histogram equalization is not always the solution for specific cases; instead, a desired histogram is aimed. For such problems, a different mapping between the old intensities and the desired ones is performed instead of making the histogram as uniform as possible. Desire for a specific histogram may be for highlighting specific intensity ranges in the image.
To perform this method, histogram equalization is first applied. The desired histogram is determined, and its probability and cumulative distributions are calculated. The cdf of the desired histogram is rescaled. In order to obtain a mapping between the equalized histogram and the desired one, the smallest value of the original intensity so that the rescaled-desired intensity is closest to the equalized intensity should be found for each intensity level. If this mapping is applied to the original image, the image with the desired histogram can be acquired. 
