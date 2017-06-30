%% parameters
extend = [0.7, 1.3];       % faction of radius to be collect to calculate threshold
p_radiusRange = [20, 60];    % possible range of radius of pupil circle
i_radiusRatio = [1.5, 3.5];  % possible ratio of iris circle radius to the pupil circle radius
i_radiusRange = [61, 100];   % possible range of radius of iris circle
searchRange = 10;           % search range for center of iris circle
src_type = 'jpg';          % file type of source image
hsiz = 350;                 % parameter for SSR enhancement; size of Gaussian kernel
gau_size = 7;
quality_thresh = 0.45;

%% Please end all the paths with "/" or "\"
src_dir = 'D:\Research\Database\CASIAV4\casiav4\';   % path of source images
out_dir = 'D:\Research\Database\CASIAV4\generate_results\results\'; % path of output directory
fail_dir = 'D:\Research\Database\CASIAV4\generate_results\poor_results\';
circle_dir = 'D:\Research\Database\CASIAV4\generate_results\circles/';

save_inter_image = true;   % save internal results or not. if yes, assign following
                            % folder values.

inter_dir = 'D:\Research\Database\CASIAV4\generate_results\inter\';

segment_NIR