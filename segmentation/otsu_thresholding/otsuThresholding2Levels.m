function otsuThresholding2Levels

L = 256; % Highest intensity level
k = 2 : L-2; % Threshold level

% Open the image
imRgb = imread( 'two-levels.PNG'  );
imGray = rgb2gray(imRgb); 

% Get the size and the number of pixels
[rows, cols] = size( imGray );
numPixels = rows * cols;

% Display the original image as grayscale
figure
imshow( imGray )
title('Grayscale of the Original Image')

% Calculate histogram and intensity probabilities
[histArr] = histogram(imGray);
probArr = histArr / numPixels;

for kk = 1 : length(k)
    % Two class prior probabilities
    P1(kk) = sum( probArr( 1 : k(kk) ) );
    P2(kk) = sum( probArr( k(kk) + 1 : L ) );
    
    % Class (conditional) means
    ind1 = 0 : k(kk)-1;
    ind2 = k(kk) : L-1;
    m1(kk) = sum( ind1' .* probArr( 1 : k(kk) ) ) / P1(kk);
    m2(kk) = sum( ind2' .* probArr( k(kk) + 1 : L ) ) / P2(kk);
    mT(kk) = P1(kk) * m1(kk) + P2(kk) * m2(kk);
    
    % Between-class variance
    varB(kk) = P1(kk) * ( m1(kk) - mT(kk) )^2 + P2(kk) * ( m2(kk) - mT(kk) )^2;
end

% Find the threshold value that gives the max between-class variance (varB) 
[~, idx] = max(varB);
T = k(idx);

% Construct a new image by thresholding the original image.
% Assign 0 to intensity levels under T, 255 to levels above T.
imThresholded = imGray > T;

% Display the thresholded image
figure
imshow( imThresholded )
title('Thresholded Image with Otsu-s Algorithm')

end

