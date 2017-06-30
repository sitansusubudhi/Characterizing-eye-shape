function mask = segment_angle_range(im, mask, center, radius, angles, thresh, radius_range)

    if nargin < 7
        radius_range = [0, 1];
    end
    region = get_sector_region(center, radius*radius_range, angles, size(im));
    bw = ~im2bw(im(region), thresh);

    if nnz(bw) < 0.2 * nnz(region)
        mask(region) = 1;
    else
        mask(region) = bw;
    end

end