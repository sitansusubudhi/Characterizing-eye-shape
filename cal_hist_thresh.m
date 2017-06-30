function [thresh_high, thresh_low, quality] = cal_hist_thresh( pixelList, i )

% GET_HIST_THRESH Calculate the threshold value according to the histogram
% Input:
%   pixelList: The list of pixel values to be calculate.
%
% Output
%   thresh: The threshold calculated.

global hist_index

x = linspace(0, 255, 256);
y = hist(pixelList(:), x);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

thresh_high = graythresh(pixelList);

if thresh_high == 0
    thresh_low = 0.2;
    thresh_high = 0.6;
    idx = round(thresh_high*255);
    quality = sum(y(1:idx)) / sum(y(idx:256));
    if quality > 1
        quality = 1/quality;
    end
    return;
end
thresh_high = round(thresh_high * 255);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


thresh_low = min(pixelList);

quality = sum(y(1:thresh_high)) / sum(y(thresh_high:256));
if quality > 1
    quality = 1/quality;
end

thresh_high = double(thresh_high) / 255;
thresh_low = double(thresh_low) / 255;

%thresh_high * 255
%thresh_low * 255
%s1 = sum(y(1:thresh));
%s2 = sum(y(thresh+1:255));

%thresh = thresh - min([thresh, 256-thresh]) * atan(s1/s2 - 1)/(pi/2);

end
