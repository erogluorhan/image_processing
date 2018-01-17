function [histArr] = histogram(imGray)

[row, col, ~] = size(imGray);

histArr = zeros(256,1);
for ii = 1 : row

    for jj = 1 : col
    
        histArr( imGray(ii, jj) + 1 ) = histArr( imGray(ii, jj) + 1 ) + 1;
    
    end
    
end

end

