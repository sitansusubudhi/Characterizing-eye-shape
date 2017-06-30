function [ center, radius ] = find_radius( im, c, rRange, sRange, option )

% FIND_RADIUS Find iris circle based on a given initial center
% Input:
%   im: Edge skeleton binary image;
%   c: Initail guess of center.
%   rRange: Radius range to be detected.
%   sRange: Search range around the center guess.
%
% Output:
%   center: Center of circle found in [x, y] format;
%   radius: Radius of circle found.


% Filter the points above initial center because they are usually eyebrow
% and eyelid.

if nargin < 5
    option = 'total';
end

rRange = round(rRange);

upper_bound = max([1, c(2)-sRange-2]);
im(1:upper_bound, :) = 0;

% outputs
center = [0, 0];
radius = 0;
grade = 0;

%edgemap = edge(im);
[Y, X] = find(im);
n = length(X);

r = zeros(n, 1);

for x = c(1)-sRange : c(1)+sRange
    for y = c(2)-sRange : c(2)+sRange
        for i = 1:n
            r(i) = sqrt((x-X(i))^2 + (y-Y(i))^2);
        end
        
%        interval = r>=rRange(1) & r<=rRange(2);
%        [radius_cur, grade_cur] = mode(r(interval));
        
        len = rRange(2) - rRange(1) + 3;
        x_axis = linspace(rRange(1)-1, rRange(2)+1, len);
        y_axis = hist(r, x_axis);
        y_axis(1) = 0;
        y_axis(len) = 0;
        y_axis = smooth(y_axis, 3);
         
        [grade_cur, index] = max(y_axis);
        if strcmp(option, 'average')
            grade_cur = grade_cur/(rRange(1) + index(1) - 2);
        end
        if grade_cur > grade
            %index = find(y_axis == g_cur);
            radius = rRange(1) + index(1) - 2;
            center = [x, y];
            grade = grade_cur;
        end
    end
end

radius = radius(ceil(length(radius)/2));

end

