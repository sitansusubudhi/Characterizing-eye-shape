function [thresh, thresh_low, quality] = thresh_angle_range(im, center, radius_range, angles)

    % parameter

    region = get_sector_region(center, radius_range, angles, size(im));

    %figure(3);
    %show_mask(im, region, 1);
    %pause

    [thresh, thresh_low, quality] = cal_hist_thresh(im(region));
end