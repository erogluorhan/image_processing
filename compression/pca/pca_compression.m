function pca_compression
% Image compression with patch-based PCA
% Patches of size patchSize x patchSize are used
% NOTE: Currently works for square images only!

clear;
clc; 

% Patch size and number of PCs for compression
patchSize = 8;
num_principle_components = 4; 
  
% Read image and display it
im = imread('bookcover.bmp');
if size(im,3) == 3
    im = rgb2gray(im);       
end
im = im2double(im);   
[rows, cols] = size(im);  

figure
imshow(im)   
title('Original Image')

% Extract patches from image  
numPatchRow = floor( rows / patchSize );
numPatchCol = floor( cols / patchSize );
patches = [];

for ii = 1 : numPatchRow

    for jj = 1 : numPatchCol
        patch = im( (ii-1) * patchSize + 1 : ii * patchSize, (jj-1) * patchSize + 1 : jj * patchSize  );
        patch = patch(:);
        
        patches = [ patches, patch ];
    end

end

% Normalize patches to zero mean
patches_mean = mean(patches); 
patches_mean_rep = repmat(patches_mean, patchSize^2, 1);
patches_N = patches - patches_mean_rep; 

% Patches covariance and eigen decomposition
C = cov(patches_N');   
[V, D] = eig(C); 
  
  
% Image compression                                                        
V_compress = V( :, end - num_principle_components + 1 : end );

Y = V_compress' * patches_N;
patches_compress = V_compress * Y;                                           
patches_compress = patches_compress + patches_mean_rep; 

% Reconstruct the compressed image from selected number of PCs 
im_compress = zeros(rows, cols);
for ii = 1 : numPatchRow

    for jj = 1 : numPatchCol
        
        patch_compress = patches_compress(:, (ii-1) * numPatchRow + jj );
        patch_compress = reshape( patch_compress, patchSize, patchSize );
        
        im_compress( (ii-1) * patchSize + 1 : ii * patchSize, (jj-1) * patchSize + 1 : jj * patchSize  ) = patch_compress;
    end

end

% Display compressed image
figure                   
imshow(im_compress)                           
title('Compressed Image') 

% Calculate compression rate and RMSE 
fprintf( sprintf('The compression rate is: %.1f\n', patchSize^2/num_principle_components));

e = ( im - im_compress );   % Error
se = e.^2;                  % Squared-error
mse = mean( se(:) );         % Mean-squared error
rmse = sqrt( mse );         % Root Mean Squared Error 

fprintf('The RMSE is: %.4f\n', rmse);

end

