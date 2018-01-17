function run_inverseFilter(degradation, k)
% Applies inverse filtering.
% Can be run without any parameter input.
% Inputs: degradation - 'motion' or 'atmospheric'
%         k - the turbulance severity coeff if degradation is 'atmospheric'  


if nargin == 0  % If no input is given, apply Motion blur before Inverse filtering
    
    degradation = 'atmospheric';
    
    k = 0.005;  % turbulance

elseif nargin == 1 % If Atmospheric turbulence is given with no k, apply mild turbulence before Inverse filtering

    if strcmp(degradation, 'atmospheric')
    
        k = 0.001;  % Mild turbulance
    
    end
    
end

% Read image
f = imread( 'bookcover.bmp'  );
f = rgb2gray(f);
[rows, cols] = size(f);

% Convert the image to double in [0,1]
if( max( f(:) ) > 1 )
	f = double(f) ./ 255; 
end

% Zero-padding and display
f_padded = zeros( size(f,1) * 2, size(f,2) * 2 );
f_padded( 1 : rows, 1 : cols )= f;

[rows_padded, cols_padded, ~] = size(f_padded);

% Multiply the image by (-1)^(x+y) and show
f_padded = performNegation( f_padded );

%Generate and Display 2D frequency spectrum
F = fft2( double(f_padded) );

% Add the selected degradation (Default is Motion blur) and display it
[U, V] = dftuv( rows_padded, cols_padded );

if strcmp(degradation, 'motion')
    %Motion blur
    a = 0.05;
    b = 0.05;
    T = 1;
    
    xx = ( U * a + V  * b ) * T;   % Input to the sinc function
    H = T * sinc( xx ) .* exp( (-1i) * pi * xx );  % The formula for H is written in sinc form
    
    degradationFunc = sprintf( 'Motion Blur - a=%.2f, b=%.2f, T=%.2f', a, b, T );
elseif strcmp(degradation, 'atmospheric' )
    %Atmospheric turbulance
    H = exp( -k * power( (U .* U + V .* V), 5/6 ) );
    
    degradationFunc = sprintf( 'Atmospheric Turbulance' );
end

H = fftshift(H);

% Display degradation transfer function - Freq. Domain
figure; 
subplot(2,2,1),imshow( log( abs( (H) ) ), [] )
title( sprintf('%s Degradation Transfer Function - Freq. Domain', degradationFunc) )

% Multiply spatial frequency with degradation function
G = H .* F;

subplot(2,2,3), imshow( log( abs(G) ), [] )
title('Degraded Image - Frequency Domain')

% Convert the resulting spatial frequency to the output image
g = real(ifft2( G ));

% Multiply the output image again by (-1)^(x+y) and show
g = performNegation( g );

% % Add gaussiian random noise to degraded image
% gMean = 0.02;
% gVar = 0.001;
% gn = imnoise( g, 'gaussian', gMean, gVar );
gn = g;  % Do not add Gaussian noise

% %Zero-pad the noisy degraded image
gn_padded = gn;

% Multiply the noisy degraded image by (-1)^(x+y) and show
gn_padded = performNegation( gn_padded );

% Convert to freq. domain
GN = fft2( double(gn_padded) );

subplot(2,2,4), imshow( log( abs(GN) ), [] )
title('Noisy Degraded Image - Frequency Domain')

% Inverse Filter: Divide the FFT of noisy degraded image by the known degradation function
H_CUT = H;
nnn = 0.001;
ind = abs(H_CUT) < nnn;
H_CUT( ind ) = nnn;
F_HAT = GN ./ H_CUT;

% Convert the resulting spatial frequency to the output image
f_hat = real(ifft2( F_HAT ));

% Multiply the output image again by (-1)^(x+y) and show
f_hat = performNegation( f_hat );

% f_hat = f_hat - min(min(f_hat));
% f_hat = f_hat ./ max(max(f_hat));

% Display original image
figure; 
subplot(2,2,1), imshow( f );
title('Original Image')

% Display degraded image without zero-padding
subplot(2,2,2), imshow( g( 1 : rows, 1 : cols ) );
title( sprintf( 'Degraded Image by %s', degradationFunc ))

subplot(2,2,3), imshow( gn( 1 : rows, 1 : cols ) );
title( 'Degraded Image plus Additive Gaussian Random Noise')

% Eliminate zero-padding and display result
f_hat = f_hat( 1 : rows, 1 : cols );
subplot(2,2,4), imshow( f_hat );
title( sprintf('Restored Image by Inverse Filter - Full') )

end

