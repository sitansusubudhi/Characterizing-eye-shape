function mask = process_ES_region( im, mask, c, r, coffs, thresh )

% PROCESS_ES_REGION processes the Eyelash and Shadow region
% Input:
%   im: The target eye image.
%   mask: The mask processed so far.
%   c: Center of iris circle.
%   r: Radius of iris circle.
%   coffs: Cofficients of polynomial representing the eyelid.
%
% Output:
%   mask: Processed mask.


tmp_mask = mask;
tmp_mask(1:c(2), :) = 0;

[thresh_low, thresh_high] = cal_hist_two_thresh(im(tmp_mask), thresh);%[0.01, 0.8]);
%[thresh_low, thresh_high]

[rows, cols] = size(im);
[X, Y] = meshgrid(1:cols, 1:rows);

PolyValue = coffs(1)*X.^2 + coffs(2)*X + coffs(3);
ES_region = Y >= PolyValue & Y <= PolyValue + 0.3*r;

%imshow(ES_region);
%pause;

ES_region = ES_region & mask;

%figure(1);
%subplot(224);
%hist(double(im(ES_region)));

mask(ES_region) = im2bw(im(ES_region), thresh_low) & ~im2bw(im(ES_region), thresh_high);

mask(Y < PolyValue) = 0;

end

