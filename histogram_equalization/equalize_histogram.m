function [ imGray_eq, histArr_eq ] = equalize_histogram( imGray )

intensityLevel = 256;

% Claculate histogram
histArr = histogram( imGray );

% Draw and save the histogram of the original grayscale image
figure
bar( (0:255)', histArr );
xlim([0 260])
title('Histogram of the Original Grayscale Image')
saveas(gcf, 'Output\Equalization\img_gray_hist', 'jpg');

% Calculate Probability Distribution
pdf = histArr / sum(histArr);

% Calculate Cumulative Distribution
cdf = zeros( intensityLevel, 1);
for ii = 1 : intensityLevel

    cdf(ii, 1) = sum( pdf( 1 : ii, 1) );
    
end

% Calculate the mapping between the old and the new intensities
intensityMapping = uint8( floor( intensityLevel * cdf ) );

% Create the new image
imGray_eq = imGray;
for ii = 1 : intensityLevel

    idx = ( imGray == ii-1 );
    imGray_eq(idx) = intensityMapping(ii);

end

histArr_eq = histogram( imGray_eq );


end

