function [ res ] = draw_circle( im, x, y, radius, draw_center )

% Draw a circle on a specified image
% Input arguments:
%   im: source image, both rgb and intensity are acceptable
%   x: x coordinate of center
%   y: y coordinate of center
%   r: radius of the circle
% Output:
%   res: result image

if nargin < 5
    draw_center = true;
end

[height, width, c] = size(im);
imr = im(:, :, 1);
if c == 1
    img = im;
    imb = im;
else
    img = im(:, :, 2);
    imb = im(:, :, 3);
end

if isa(im, 'uint8')
    max = uint8(255);
else
    max = 1;
end

[X, Y] = meshgrid(1-x:width-x, 1-y:height-y);

if draw_center
    center = X>=-3 & X<=3 & Y >=-3 & Y<=3;
    imr(center) = max;
    img(center) = 0;
    imb(center) = 0;
end

r = round(sqrt(X.^2 + Y.^2));
circle = r >= radius & r <= radius+1;
imr(circle) = 0;
img(circle) = max;
imb(circle) = 0;

res = cat(3, imr, img, imb);

end

