function [ x, y ] = find_center_v3( bw, rRange, d )

% FIND_ACRS finds center of incomplete arcs on the iris boundary using hough
% transform.
% Input:
%   bw: Binary image where to find arcs. Edge or binary image expected.
%   rRange: 1 by 2 vector to identify range of radii to search.

%im = imfill(bw, 'holes');

% Parameter
if nargin < 3
    d = 10; % distance of adjancent points to calculate edge orientation
end

[rows, cols] = size(bw);

B = bwboundaries(bw);
n = length(B);

votes_left = ones(rows, cols);
votes_right = ones(rows, cols);
mark_mat = false(rows, cols);

for i = 1:n
    Idx = B{i};
    len = size(Idx, 1);
    if len < 30
        continue;
    end
    for j = d+1:len-d
        y = Idx(j, 1);
        x = Idx(j, 2);
        if mark_mat(y, x);
            continue;
        end
        mark_mat(y, x) = 1;
        P1 = Idx(j-d, :);
        P2 = Idx(j+d, :);
        
        if P1(2) == P2(2) 
            if P1(1) == P2(1)
                continue;
            elseif P1(1) > P2(1)
                if x < P1(2)
                    tmp = P1;
                    P1 = P2;
                    P2 = tmp;
                end
            end
        else
            if P1(2) > P2(2)
                tmp = P1;
                P1 = P2;
                P2 = tmp;
            end
            slope1 = (y-P1(1)) / (x-P1(2));
            slope2 = (P1(1)-P2(1)) / (P1(2)-P2(2));
            if slope1 <= slope2
                continue;
            %else
                %fprintf('[%d, %d], [%d, %d], [%d, %d]\n', x, y, P1(2), P1(1), P2(2), P2(1));
                %pause
            end
            
            
            
            
        end
        
        dx = P2(2) - P1(2);
        dy = P2(1) - P1(1);
        distance = sqrt(dx^2 + dy^2);
        cosine = dx/distance;
        sine = dy/distance;
        cosine2 = sine;
        sine2 = -cosine;
        
        if cosine2 > 0.15
        
            for r = rRange(1):rRange(2)
                xc = round(x + cosine2 * r);
                yc = round(y + sine2 * r);
                if xc < 1 || xc > cols || yc < 1 || yc > rows
                    break;
                else
                    votes_left(yc, xc) = votes_left(yc, xc) + 1;
                end
            end
        
        elseif cosine2 < -0.15
            
            for r = rRange(1):rRange(2)
                xc = round(x + cosine2 * r);
                yc = round(y + sine2 * r);
                if xc < 1 || xc > cols || yc < 1 || yc > rows
                    break;
                else
                    votes_right(yc, xc) = votes_right(yc, xc) + 1;
                end
            end
            
        end
    end
end

h = fspecial('average', 3);
votes_left = imfilter(votes_left, h);
votes_right = imfilter(votes_right, h);
votes = votes_left .* votes_right - 1;

%votes = imfilter(votes, h);
[Y, X]= find(votes == max(votes(:)));
y = Y(1);
x = X(1);
%return;
%figure;
votes = votes/max(votes(:));
imvotes = votes;
imvotes(bw) = 1;
imvotes(:, :, 2) = votes;
imvotes(:, :, 3) = votes;

%imshow(imvotes);
%hold on
if x > 3 && y > 3
    imvotes(y-3:y+3, x-3:x+3, 2) = 1;
    imvotes(y-3:y+3, x-3:x+3, 1) = 0;
    imvotes(y-3:y+3, x-3:x+3, 3) = 0;
end

%scatter(x, y, 5, 'green', 'filled');


end

