%% parameters
extend = [0.6, 1.35];       % range of faction of radius to calculate threshold
i_radiusRange = [35, 120];    % possible range of radius of iris circle
searchRange = 10;           % search range for center of iris circle
src_type = 'jpg';          % file type of source image
hsiz = 300;                 % parameter for SSR enhancement; size of Gaussian kernel
gau_size = 7;
quality_thresh = 0.5;

%% Please end all the paths with "/" or "\"
%set-up folders
src_dir = 'D:\Research\Database\UBIRISV2\my_eye\';   % path of source images
out_dir = 'D:\Research\Database\UBIRISV2\results_generate\results\';  % path of output directory
 fail_dir = 'D:\Research\Database\UBIRISV2\results_generate\poor_results\'; % path of output directory for fail segmentation
 circle_dir = 'D:\Research\Database\UBIRISV2\results_generate\circles\'; % path for storing the detected circle position of each image

save_inter_image = true;   % save internal image or not. if yes, assign and create the following folder    
inter_dir = 'D:\Research\Database\UBIRISV2\results_generate\inter\';

segment_VW

