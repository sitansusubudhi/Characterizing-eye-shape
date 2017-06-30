function mask = mask_upper_region(im, mask, c, r, thresh)
    mask = segment_angle_range(im, mask, c, r, [-0.5*pi, 0], thresh(1));
    mask = segment_angle_range(im, mask, c, r, [pi, -0.4*pi], thresh(3));
end