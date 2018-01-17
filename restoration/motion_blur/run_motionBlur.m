function run_motionBlur( a, b, T )
% Applies Motion Blur on an image
% Inputs: a, b: Velocities in x and y directions, respectively
%            T: Exposure time

% If no parameter value is given, use the below defaults
if nargin == 0

    a = 0.1;
    b = 0.1;
    T = 1;
    
end

% Read image
imRgb = imread( 'bookcover.bmp'  );
im = rgb2gray( imRgb );
[rows, cols] = size(im);

% Take R channel and display it
if( max( im(:) ) > 1 )
	im = double(im) ./ 255; 
end

% Zero-padding and display
im_padded = zeros( rows * 2, cols * 2 );
im_padded( 1 : rows, 1 : cols )= im;
figure; 
subplot(1, 2, 1), imshow( im_padded );
title('Original Image - Zero-Padded')

[rows_padded, cols_padded, ~] = size(im_padded);

% Multiply the image by (-1)^(x+y) and show
for ii = 1 : rows_padded
    for jj = 1 : cols_padded
        im_padded(ii, jj)  = im_padded(ii, jj) * power( -1, ii + jj );
    end
end
%figure; 
subplot(1,2,2), imshow( im_padded );
title('Original Image - Zero-Padded - multiplied by power(-1, x+y)')

%Generate and Display 2D frequency spectrum
F = fft2( double(im_padded) );
figure; 
subplot(1,2,1), imshow( log( abs( (F) ) ), [] )
title('Original Image - Zero-Padded - Freq. Domain')


% Construct Motion blur degradation function and display
[U, V] = dftuv( rows_padded, cols_padded );

xx = ( U * a + V  * b ) * T;   % Input to the sinc function

H = T * sinc( xx ) .* exp( (-1i) * pi * xx );  % The formula for H is written in sinc form

H = fftshift(H);

%figure; 
subplot(1,2,2), imshow( log( abs( (H) ) ), [] )
title('Motion Blur Degradation Function - Freq. Domain')

% Multiply saptial frequency with degradation function
G = H .* F;

% Convert the resulting spatial frequency to the output image
g = real(ifft2( G ));

% Multiply the output image again by (-1)^(x+y) and show
for ii = 1 : rows_padded
    for jj = 1 : cols_padded
        g(ii, jj)  = g(ii, jj) * power( -1, ii + jj );
    end
end

figure; 
subplot(1,2,1), subimage( im );
title('Original Image')

% Eliminate zero-padding and display result
g = g( 1 : rows, 1 : cols );
%figure; 
subplot(1,2,2), imshow( g );
title( sprintf('Motion Blurred Image - a=%.2f, b=%.2f, T=%.2f', a, b, T) )

end

