function region = get_pupil_region( im, reflection, center, radius, thresh )

% REMOVE_PUPIL removes pupil area from an eye image
% Input:
%   im: The target eye image.
%   reflection: Reflection area.
%   center: Center of pupil circle.
%   radius: Radius of pupil circle.
%   percentage: percentage of darkest pixel in the circle to be removed.
%
% Output:
%   region: The pupil region.


%parameter
reflection_thresh = 0.6;

[rows, cols] = size(im);
[X, Y] = meshgrid(1-center(1):cols-center(1), 1-center(2):rows-center(2));
circle = X.^2 + Y.^2 < (radius-2)^2;
region = circle & ~im2bw(im, min(thresh));
%region = circle;
return;
pixelList = im(region);

number = length(pixelList);

max_value = double(max(pixelList));
min_value = double(min(pixelList));
len = max_value - min_value + 1;

x = linspace(min_value, max_value, len);
y = hist(pixelList, x);

count = 0;
thresh = 0;
for i = len:-1:1
    count = count + y(i);
    if count >= (1-percentage)*number;
        thresh = min_value + i - 1;
        break;
    end
end

thresh = double(thresh)/255;

tmp = ~im2bw(im(region), thresh);
region(region) = tmp;
region = imfill(region, 'holes');

end

