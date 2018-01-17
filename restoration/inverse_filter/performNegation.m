function [img] = performNegation( img )

[rows, cols] = size(img);

for ii = 1 : rows
    for jj = 1 : cols
        img(ii, jj)  = img(ii, jj) * power( -1, ii + jj );
    end
end

end