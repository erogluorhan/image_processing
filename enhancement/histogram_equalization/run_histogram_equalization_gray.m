function run_histogram_equalization_gray

if ~exist( 'Output\Equalization', 'dir')
    mkdir('Output\Equalization')
end

imRgb = imread( 'Lena.png'  );

% Draw and save the original RGB image
figure
imshow(imRgb);
title('Original RGB Image')
saveas(gcf, 'Output\Equalization\img_rgb', 'jpg');

imGray = rgb2gray(imRgb); 

% Draw and save the original grayscale image
figure
imshow( imGray )
title('Original Grayscale of the RGB Image')
saveas(gcf, 'Output\Equalization\img_gray', 'jpg');

[ imGray_eq, histArr_eq ] = equalize_histogram( imGray );

% Draw and save the equalized grayscale image
figure
imshow( imGray_eq )
title('Histogram-Equalized Grayscale Image')
saveas(gcf, 'Output\Equalization\img_gray_eq', 'jpg');

% Draw and save the histogram of the equalized grayscale image
figure
bar( (0:255)', histArr_eq );
xlim([0 260])
title('Equalized Histogram of the Grayscale Image')
saveas(gcf, 'Output\Equalization\img_gray_hist_eq', 'jpg');

end

