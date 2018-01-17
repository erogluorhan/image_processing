function run_histogram_equalization_rgb

if ~exist( 'Output\Equalization\RGB', 'dir')
    mkdir('Output\Equalization\RGB')
end

imRgb = imread( 'Lena.png'  );
[rows, cols, ~] = size(imRgb);

imR = imRgb( :, :, 1 ); 
imG = imRgb( :, :, 2 ); 
imB = imRgb( :, :, 3 );  


% Draw and save the R, G, and B channels of the RGB image
figure
imshow( imR )
title('R-channel of the RGB Image')
saveas(gcf, 'Output\Equalization\RGB\img_R', 'jpg');

figure
imshow( imG )
title('G-channel of the RGB Image')
saveas(gcf, 'Output\Equalization\RGB\img_G', 'jpg');

figure
imshow( imB )
title('B-channel of the RGB Image')
saveas(gcf, 'Output\Equalization\RGB\img_B', 'jpg');

[ imR_eq, histArrR_eq ] = equalize_histogram( imR );
[ imG_eq, histArrG_eq ] = equalize_histogram( imG );
[ imB_eq, histArrB_eq ] = equalize_histogram( imB );

% Draw and save the equalized R, G, and B channels of the RGB image
figure
imshow( imR_eq )
title('Equalized R-channel of the RGB Image')
saveas(gcf, 'Output\Equalization\RGB\img_R_eq', 'jpg');

figure
imshow( imG_eq )
title('Equalized G-channel of the RGB Image')
saveas(gcf, 'Output\Equalization\RGB\img_G_eq', 'jpg');

figure
imshow( imB_eq )
title('Equalized B-channel of the RGB Image')
saveas(gcf, 'Output\Equalization\RGB\img_B_eq', 'jpg');

% Draw and save the equalized histogram of R, G, and B channels of RGB image
figure
bar( (0:255)', histArrR_eq );
xlim([0 260])
title('Equalized Histogram of the R-Channel of RGB Image')
saveas(gcf, 'Output\Equalization\RGB\imR_hist_eq', 'jpg');

figure
bar( (0:255)', histArrG_eq );
xlim([0 260])
title('Equalized Histogram of the G-Channel of RGB Image')
saveas(gcf, 'Output\Equalization\RGB\imG_hist_eq', 'jpg');

figure
bar( (0:255)', histArrB_eq );
xlim([0 260])
title('Equalized Histogram of the B-Channel of RGB Image')
saveas(gcf, 'Output\Equalization\RGB\imB_hist_eq', 'jpg');


imRgb_eq = uint8( zeros(rows, cols, 3) );
imRgb_eq(:, :, 1) = imR_eq;
imRgb_eq(:, :, 2) = imG_eq;
imRgb_eq(:, :, 3) = imB_eq;

% imRgb_eq=cat(3,imR_eq,imG_eq,imB_eq);
% Draw and save the equalized R, G, and B channels of the RGB image
figure
imshow( imRgb_eq );
title('Channel-wise Histogram Equalized RGB Image')
saveas(gcf, 'Output\Equalization\RGB\imRGB_eq', 'jpg');

end

