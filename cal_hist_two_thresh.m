function [thresh_low, thresh_high] = cal_hist_two_thresh( pixelList, rate )

% CAL_HIST_TWO_THRESH calculates two thresholds that retains certain
% number of pixels in the list.
% Input:
%   pixelList: pixels to calculate.
%   rate: pertentage of pixels to retain
%
% Output:
%   thresh_low: low bound threshold
%   thresh_high: high bound threshold


if any(rate<0 | rate>1) || isempty(pixelList)
    disp('rate must be between 0 and 1!');
    thresh_low = 0;
    thresh_high = 1;
    return;
end

thresh_low_num = rate(1) * length(pixelList);
thresh_high_num = (1-rate(2)) * length(pixelList);

x = linspace(0, 255, 256);
y = hist(pixelList, x);

y = smooth(y, 25);

thresh_low = 1;
thresh_high = 256;

low_sum = 0;
high_sum = 0;

while high_sum <= thresh_high_num
    high_sum = high_sum + y(thresh_high);
    thresh_high = thresh_high - 1;
end

while low_sum <= thresh_low_num
    low_sum = low_sum + y(thresh_low);
    thresh_low = thresh_low + 1;
end

thresh_low = (thresh_low - 1)/255;
thresh_high = (thresh_high - 1)/255;

end

