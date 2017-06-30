function im_en = SSR_enhance( im, hsiz )

% SSR_ENHANCE reimplements single scale retinex enhancement by making use of Matlab's built-in features to improve speed
% Reference: V. Struc, INface toolbox, http://luks.fe.uni-lj.si/sl/osebje/vitomir/face_tools/INFace/index.html
% Input:
%   im: source image. single channel expected
%   hsiz: size of Gaussian kernel
% Output:
%   im_en: enhanced image

im = double(im);

maxv = max(im(:));
minv = min(im(:));
im = ceil((im - minv)/(maxv - minv)*255) + 0.01;

[rows, cols] = size(im);
half = ceil(rows/2);
[X, Y] = meshgrid(1-half:cols-half, 1-half:rows-half);
G = exp(-(X.^2 + Y.^2)/hsiz^2);
G = G / sum(G(:));

im2 = ceil(imfilter(im, G, 'replicate', 'same'));

im_en = log(im) - log(im2);
im_en = histtruncate(im_en, 0.2, 0.2);

maxv = max(im_en(:));
minv = min(im_en(:));

im_en = ceil((im_en - minv) / (maxv - minv) * 255);

end

