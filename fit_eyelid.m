function [coffs, x_range, im_eyelid] = fit_eyelid(im, ci, ri, cp, rp, range, position, offset, save_image)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% position: 'upper' or 'lower'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 9
    save_image = false;
end

if nargin < 8
    offset = 0;
end

if ci == 0
    coffs = [0, 0, 0];
    im_eyelid = im;
    return;
end

[r, c] = size(im);
[X, Y] = meshgrid(1:c, 1:r);

pts = edge(im);

%dymap = zeros(rows, cols);
%dymap(1:rows-1, :) = struct_map(1:rows-1, :) - struct_map(2:rows, :);

%pts(dymap <=0) = 0;

dis = sqrt((X - cp(1)).^2 + (Y - cp(2)).^2) - rp;

pupil = abs(dis) < 4;
if strcmp(position, 'upper') == 1 %% equal
    rect = Y>=ci(2)-range(2)*ri & Y<=ci(2)-range(1)*ri & X>=ci(1)-ri & X<=ci(1)+ri;
else
    rect = Y>=ci(2)+range(1)*ri & Y<=ci(2)+range(2)*ri & X>=ci(1)-ri & X<=ci(1)+ri;
end
region = rect & ~pupil;

pts(~region) = 0;

%[region] = search_max_Haar_region(im, mask, ci, ri, cp, rp, range);

%im_r = im(y:y+h, x:x+w);
%th = graythresh(im(region));
%mask(region) = im2bw(im(region), th);
%mask(~region) = 0;
%pts = mask(1:end-1, :) < mask(2:end, :);
%pts = padarray(pts, [1, 0], 0, 'post');
[yy, xx] = find(pts);
[~,x_range] = get_default_coff(ci, ri, position);
%coffs = polyfit(xx, yy, 2);
if length(yy) < ri*0.3
    [coffs, x_range] = get_default_coff(ci, ri, position);
   % fprintf('%d %d',x_range(1),x_range(2));
else
    xv_range = [ci(1)-2*ri, ci(1)+2*ri];
    if strcmp(position, 'upper') == 1 % equal
        yv_range = [ci(2)-round(1.5*ri), max(yy)];
        a_range = [0, 1/ri];
    else
        yv_range = [ci(2)+round(1.5*ri), min(yy)];
        a_range = [0, -1/ri];
    end
    [coffs, score] = hough_parabolic(xx, yy, xv_range, yv_range, a_range); 
    coffs(3) = coffs(3) + offset;
    if score < ri*0.3
        [coffs, x_range] = get_default_coff(ci, ri, position);
    end
   
end
if strcmp(position,'upper') == 1
    fprintf('\nUpper eyelid %d %d %d %d %d\n\n',x_range(1),x_range(2), coffs(1),coffs(2),coffs(3));
else
    fprintf('\nLower eyelid %d %d %d %d %d\n\n',x_range(1),x_range(2), coffs(1),coffs(2),coffs(3));
end
%If the polynomial is too sharp
% if (coffs(1) > 1/ri || coffs(1) < -1/20/ri)
%     x = [ci(1) - 2*ri, ci(1), ci(1) + 2*ri];
%     y = [ci(2), ci(2) - ri, ci(2)];
%     coffs = polyfit(x, y, 2);
%     %figure(3), plot(x, y), figure(4);
% end

%im_bw = im2bw(im_r, th);
%eyelid_pts = im_bw(1:end-1, :) > im_bw(2:end, :);

% eyelid_pts = edge(im_r);

%cc = bwconncomp(im_bw);
%pp = regionprops(cc, 'Area');
%idx = find([pp.Area] == max([pp.Area]));
%eyelid_pts2 = ismember(labelmatrix(cc), idx);

%mask(y:y+h, x:x+w) = mask(y:y+h, x:x+w) & eyelid_pts2;
%mask(1:y-1, :) = 0;

if save_image
    region = abs(coffs(1)*X.^2 + coffs(2)*X + coffs(3) - Y) < 1.5;

    imr = im;
    img = im;
    imb = im;
    
    imr(region) = 0;
    imr(pts) = 255;
    img(region) = 255;
    img(pts) = 0;
    imb(region | pts) = 0;
    im_eyelid = cat(3, imr, img, imb);
else
    im_eyelid = 0;
end

    function [coffs,x_range] = get_default_coff(ci, ri, position)
        if strcmp(position, 'upper') == 1 % equal
            xt = [ci(1) - 2*ri, ci(1), ci(1) + 2*ri];
            yt = [ci(2), ci(2) - ri, ci(2)];
        else
            xt = [ci(1) - 2*ri, ci(1), ci(1) + 2*ri];
            yt = [ci(2), ci(2) + ri, ci(2)];
        end
        coffs = polyfit(xt, yt, 2);
        x_range = [xt(1), xt(end)];
       % fprintf('%d %d',x_range(1),x_range(2));
       %yt 
    end



end