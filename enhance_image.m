function im_en = enhance_image( im, hsiz, gau_size, c )

% ENHANCE_IMAGE enhances image using SSR
% Input:
%   im: source image
%   hsiz: size of Gaussian kernel
%   med_siz: size of median filter
%   c: number of channels to enhance
%
% Output:
%   im_en: enhanced image

if nargin < 4
    c = 1;
end

h = fspecial('gaussian',gau_size,1.5);

for i = 1:c
    %im(:, :, i) = single_scale_retinex(im(:, :, i), hsiz);
    im(:, :, i) = SSR_enhance(im(:, :, i), hsiz);
    im(:, :, i) = imfilter(im(:, :, i), h, 'symmetric');
    im(:, :, i) = medfilt2(im(:, :, i), [3, 3]);
    im_en(:, :, i) = uint8(im(:, :, i));
end

end

