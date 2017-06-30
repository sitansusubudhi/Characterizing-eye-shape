function [ center, radius, center_p, radius_p ] = find_circles_VW( im, edgemap, radiusRange, searchRange )

%   FIND_CIRCLES_UBIRIS Summary of this function goes here
%   Detailed explanation goes here

%[cx, cy] = find_center_v4(edgemap, im, radiusRange);
[cx, cy] = find_center_v3(edgemap, radiusRange);
[center, radius] = find_radius(edgemap, [cx, cy], radiusRange, searchRange);


edgemap = edge(im, 'canny', 0.2);
[center_p, radius_p] = find_radius(edgemap, center, radius*[0.2, 0.4], searchRange);


end

