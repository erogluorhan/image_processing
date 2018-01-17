function run_wienerFilter(K, degradation, k)
% Applies Wiener filtering.
% Can be run without any parameter input.
% Inputs: degradation - 'motion' or 'atmospheric'
%         k - the turbulance severity coeff if degradation is 'atmospheric' 
%         K - Wiener filter constant: 1 / (Signal-to-noise ratio)

if nargin == 0   % If no input is given, apply Motion blur before Wiener
    
    K = 0.0000000001;
    degradation = 'motion';
    
elseif nargin == 1 % If only K is given, apply Motion blur before Wiener
    
    degradation = 'motion';
    
elseif nargin == 2 % If Atmospheric turbulence is given with no k, apply mild turbulence before Wiener
    
    if strcmp(degradation, 'atmospheric')
         k = 0.001;
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
    
    degradationFunc = sprintf( 'Motion Blur - a=%.2f, b=%.2f, T=%.1f', a, b, T );
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
% gVar  = 0.001;
% gn = imnoise( g,'gaussian', gMean, gVar);
gn = g;  % Do not add Gaussian noise

% %Zero-pad the noisy degraded image
gn_padded = gn;

% Multiply the noisy degraded image by (-1)^(x+y) and show
gn_padded = performNegation( gn_padded );

% Convert to freq. domain
GN = fft2( double(gn_padded) );

subplot(2,2,4), imshow( log( abs(GN) ), [] )
title('Noisy Degraded Image - Frequency Domain')

% Wiener Filter
L = conj(H) ./ ( abs(H).^2 + K );
F_HAT = GN .* L;

% Convert the resulting spatial frequency to the output image
f_hat = real(ifft2( F_HAT ));

% Multiply the output image again by (-1)^(x+y) and show
f_hat = performNegation( f_hat );

% Display original image
figure; 
subplot(2,2,1), imshow( f );
title('Original Image')

% Display degraded image without zero-padding
subplot(2,2,2), imshow( g( 1 : rows, 1 : cols ) );
title( sprintf( 'Degraded Image by %s', degradationFunc ))

subplot(2,2,3), imshow( gn( 1 : rows, 1 : cols ) );
title('Degraded Image plus Gaussian Random Noise')

% Eliminate zero-padding and display result
f_hat = f_hat( 1 : rows, 1 : cols );
subplot(2,2,4), imshow( f_hat );
title('Restored Image by Wiener Filter')

end

