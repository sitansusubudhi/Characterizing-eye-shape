% The iris segmentation program also provides the detected iris and pupil circle information and saved in the "circle_dir" specified in the caller script.
% For researchers who are interested in using our generated iris masks for iris matching, the circle information can be used to normalize (unwrap) the original iris images.
% Following sample code shows how to use our generated circle information to normalize iris image using Masek's iris matching implementation:

d = load('XXX_circle.mat'); % locate the circle information MAT file generated and saved in the "circle_dir" folder
im = imread('XXX.jpg');     % Original eye image
global DIAGPATH             % Global variable that is needed in the following
DIAGPATH = '.';

% The following function "normaliseiris" is originally available in Masek's implementation: http://www.peterkovesi.com/studentprojects/libor/
% We also provide it in this folder for convenience.
[im_normalized, ~] = normaliseiris(double(im), d.center(1), d.center(2), d.radius, ...
		d.center_p(1), d.center_p(2), d.radius_p, 'output_image', 64, 512);
imshow(im_normalized);


