function [ score ] = quality( mask, im, center, radius, center_p, radius_p )
%   QUALITY Summary of this function goes here
%   Detailed explanation goes here
[row, col] = size(mask);
[X, Y] = meshgrid(1:col, 1:row);

pupil_region = (X - center_p(1)).^2 + (Y - center_p(2)).^2 <= radius_p^2;
mask(pupil_region) = 0;

mask_area = nnz(mask);
ideal_area = pi * (radius^2 - radius_p^2);

area_score = mask_area / ideal_area;

if isa(im, 'uint8')
    im = double(im)/255;
end

std_score = 1 / (1 + 10*std(im(mask)));

score = 0.7*area_score + 0.3*std_score;

end

