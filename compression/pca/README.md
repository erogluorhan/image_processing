# Image Compression with Principal Component Analysis (PCA)

# Description
PCA is the method of converting data points into linearly uncorrelated, orthogonal new point sets, i.e. principal components (PCs), based on the statistics of the data. 
The good thing with PCA is that the first principal component (PC) has the largest variance, so it represents the most variability of the data.  
The second PC has a lower variance than the first one, and so on. 
This property can be used for different dimensionality reduction problems such as reducing the required channels in multispectral imagery in order to represent the scene perfectly. 
It can also be used for describing the boundaries and regions in a single image.

PCA can be also used within a grayscale image (Assume of size 256x256) itself to compress the image. 
Grayscale image compression with PCA can be performed by defining fully sliding (without overlap) patches of square shape (Assume a size of 8x8) on an image. 
The pixels covered in each patch position are converted into column vectors (Should be 64x1 for patch of size 8x8) that has a length of the square of the patch size, and these column vectors are sequentially kept for the whole image (should have the size of 64x1024 for above image and patch sizes). 
In fact, since PCA is sensitive to the data point values (relative scaling of them), images should be preprocessed to have zero mean before starting PCA. 
In the patch-based compression approach, pixels of each patch can be made have zero mean themselves. 

PCA algorithm is based on finding the correct covariance matrix (should have the size of 64x64 for the example case detailed above) and performing the eigen value decomposition for it, which gives us the eigen values and the corresponding eigen vectors. 
Then, the main image compression phase follows: the transpose of selected eigen vectors are multiplied with the normalized sequence of patches that are obtained from the original image. 
The result of this multiplication is multiplied with the selected eigen vectors. 
At the end, we should add mean of each patch to itself again, which we subtracted before. 
Final resulting image should be obtained by reshaping the output to the original image size since it is achieved from the sequence of patches.
The compression rate and the root mean squared error (RMSE) as a measure of the compression can be easily computed. 
Compression rate is the ratio of total number of PCs, which depends on the patch size, to the number of selected PCs for compression. 
RMSE can be computed between the original and the compressed images.
