function run_histogram_specification_gray

if ~exist( 'Output\Specification', 'dir')
    mkdir('Output\Specification')
end

intensityLevel = 256;

imRgb = imread( 'Lena.png'  );
[rows, cols, ~] = size(imRgb);

% Draw and save the original RGB image
figure
imshow(imRgb);
title('Original RGB Image')
saveas(gcf, 'Output\Specification\img_rgb', 'jpg');

% Convert RGB image to GrayScale
imGray = rgb2gray(imRgb); 

% Draw and save the original grayscale image
figure
imshow( imGray )
title('Original Grayscale of the RGB Image')
saveas(gcf, 'Output\Specification\img_gray', 'jpg');

% Calculate histogram
histArr = histogram( imGray );

% Draw and save the histogram of the original grayscale image
figure
bar( (0:255)', histArr );
xlim([0 260])
title('Histogram of the Original Grayscale Image')
saveas(gcf, 'Output\Specification\img_gray_hist', 'jpg');

% Calculate Probability Distribution
pdf_current = histArr / sum(histArr);

% Calculate Cumulative Distribution
cdf = zeros( intensityLevel, 1);
for ii = 1 : intensityLevel

    cdf(ii, 1) = sum( pdf_current( 1 : ii, 1) );
    
end

% Calculate the mapping between the old and the new intensities
z_q = (0 : 255)';
s_k = uint8( floor( intensityLevel * cdf ) );

% Determine desired pdf
pdf_desired = zeros(intensityLevel, 1);

highestLevelDark = 2 * 0.3 / intensityLevel;
step = 4 * highestLevelDark / intensityLevel; 
pdf_desired( 1 : intensityLevel / 4, 1 ) = step : step : highestLevelDark;
pdf_desired( intensityLevel / 4 : intensityLevel / 2, 1 ) = highestLevelDark : -step : 0;

highestLevelBright = 2 * 0.7 / intensityLevel;
step = 4 * highestLevelBright / intensityLevel; 
xx = step : step : highestLevelBright;
pdf_desired( intensityLevel / 2 + 1 : 3 * intensityLevel / 4, 1 ) = step : step : highestLevelBright;
pdf_desired( 3 * intensityLevel / 4 : end, 1 ) = highestLevelBright : -step : 0;
pdf_desired = 2 * pdf_desired;

% Draw and save the desired histogram
figure
bar( (0:255)', rows * cols * pdf_desired );
xlim([0 260])
title('Desired Histogram')
saveas(gcf, 'Output\Specification\hist_desired', 'jpg');

% Calculate Cumulative Distribution of the Specified pdf
cdf_desired = zeros( intensityLevel, 1);
for ii = 1 : intensityLevel

    cdf_desired(ii, 1) = sum( pdf_desired( 1 : ii, 1) );
    
end

% Calculate the specified mapping between the old and the new intensities
Gz_q = uint8( floor( double(intensityLevel) * cdf_desired ) );

sdf = [];

% Create the new image via mapping old intensities to new desired ones
imGray_specified = imGray;
for ii = 1 : intensityLevel
    
    s_k_val = s_k(ii);
    
    diff = 1000; % just for the sake of beginning with a large number
    ind = 257; % just for the sake of beginning with a nonexistent index
    for jj = 1 : intensityLevel       
        if abs( s_k_val - Gz_q(jj) ) < diff 
            ind = jj;
            diff = abs( s_k_val - Gz_q(jj) );
        end        
    end
        
    idx = ( imGray == ii-1 );
    imGray_specified(idx) = z_q(ind);
    
    sdf = [sdf; z_q(ind)];
    
end

% Calculate the histogram of the Histogram-Specified Image
histArr_specified = histogram( imGray_specified );

% Draw and save the equalized grayscale image
figure
imshow( imGray_specified )
title('Resulting Grayscale Image After Histogram Specification')
saveas(gcf, 'Output\Specification\img_gray_specified', 'jpg');

% Draw and save the histogram of the equalized grayscale image
figure
bar( (0:255)', histArr_specified );
xlim([0 260])
title('Resulting Histogram After Histogram Specification')
saveas(gcf, 'Output\Specification\img_gray_hist_specified', 'jpg');

end

