function [ edgemap, im_smooth ] = get_rtv_l1_contour( im, lambda, theta, sigma, ep )


im_smooth = rtv_l1_smooth2(im, lambda, theta, sigma, ep, 5);
edgemap = edge(im_smooth);
%edgemap = edge(im, 'sobel', [], 'vertical');


end

