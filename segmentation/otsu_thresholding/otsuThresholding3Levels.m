function otsuThresholding3Levels

L = 256; % Highest intensity level
k1 = 2 : L-3; % Threshold level

% Open the image
imRgb = imread( 'three-levels.png'  );
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

for kk = 1 : length(k1)
    
    k2 = k1 + 1 : L-2; % Threshold level
    
    for mm = 1 : length(k2)
        
        % Two class prior probabilities
        P1(kk,mm) = sum( probArr( 1 : k1(kk) ) );
        P2(kk,mm) = sum( probArr( k1(kk) + 1 : k2(mm) ) );
        P3(kk,mm) = sum( probArr( k2(mm) + 1 : L ) );

        % Class (conditional) means
        ind1 = 0 : k1(kk) - 1;
        ind2 = k1(kk) : k2(mm) - 1;
        ind3 = k2(mm) : L-1;
        
        m1(kk,mm) = sum( ind1' .* probArr( 1 : k1(kk) ) ) / P1(kk,mm);
        m2(kk,mm) = sum( ind2' .* probArr( k1(kk) + 1 : k2(mm) ) ) / P2(kk,mm);
        m3(kk,mm) = sum( ind3' .* probArr( k2(mm) + 1 : L ) ) / P3(kk,mm);
        mT(kk,mm) = P1(kk,mm) * m1(kk,mm) + P2(kk,mm) * m2(kk,mm) + P3(kk,mm) * m3(kk,mm);

        % Between-class variance
        varB(kk,mm) = P1(kk,mm) * ( m1(kk,mm) - mT(kk,mm) )^2 ... 
                    + P2(kk,mm) * ( m2(kk,mm) - mT(kk,mm) )^2 ...
                    + P3(kk,mm) * ( m3(kk,mm) - mT(kk,mm) )^2;
    
    end
    
end

% Find the threshold value that gives the max between-class variance (varB) 
[val, idx] = max(varB(:));
[ind_k1, ind_k2] = ind2sub(size(varB),idx)

T1 = ind_k1 + 1;
T2 = ind_k2 + 2;

% Construct a new image by thresholding the original image by thresholds T1 and T2.
% Assign 0 to intensity levels under T1, 
%        127 to levels between T1 and T2, and 
%        255 to levels above T2.
indA = imGray > T2;
indB = imGray <= T2 & imGray > T1;
indC = imGray <= T1;

imThresholded = imGray;
imThresholded(indA) = 255;
imThresholded(indB) = 127;
imThresholded(indC) = 0; 

% Display the thresholded image
figure
imshow( imThresholded )
title('Thresholded Image with Otsu-s Algorithm')

end

