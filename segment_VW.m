%% Create folders if not existing
if ~exist(out_dir, 'dir')
    mkdir(out_dir);
end
if ~exist(fail_dir, 'dir')
    mkdir(fail_dir);
end
if ~exist(circle_dir, 'dir')
    mkdir(circle_dir);
end

if save_inter_image
    if ~exist(inter_dir, 'dir')
        mkdir(inter_dir);
    end
end

delete([out_dir, '*']);
delete([fail_dir, '*']);

%%
files = dir([src_dir, '*.', src_type]);
n = length(files);

err_rates = zeros(n, 1);
circles = struct([]);
num_pass = 0;
num_fail = 0;

for i = 1:n %n
    %close all;
    [filename, type] = strtok(files(i).name, '.');
    
    im_src = imread([src_dir, files(i).name]);
    
    % want to see enhanced color image, set last parameter to 3
    %figure;
    %imshow(im_src);
    if hsiz ~= 0
        im_en = enhance_image(im_src, hsiz, gau_size);
    else
        im_en = medfilt2(im_src, [3, 3]);
    end
    if save_inter_image
       imwrite(im_en, [inter_dir, filename, '-enhance.bmp']);
    end
%     im_en = imread([inter_dir, filename, '-enhance.bmp']);
%     im_en = im_en(:, :, 1);
    
    [col, row] = size(im_en);
    
    % get the structure map using local total variation
    im_ad = imadjust(im_en, [0.4, 1], [0, 1]);
    % im_ad = im_en;
    %imshow(im_ad);
    
    % roughly remove obvious reflection
    [im_ad, reflection_region] = remove_reflection(im_ad, 0.8, row*col*0.01);
    
    % RTV-L1
    [edgemap, im_smooth] = get_rtv_l1_contour(im_ad, 0.2, 0.05, 3, 0.005); %0.02, 0.15, 3, 0.005
    if save_inter_image
        imwrite(im_smooth, [inter_dir, filename, '-smooth.bmp']);
    end
%     im_smooth = imread([inter_dir, filename, '-smooth.bmp']);
%     im_smooth = im_smooth(:, :, 1);
%     edgemap = edge(im_smooth);
    
    % find iris and pupil circles based on the structure map
    %[center, radius, center_p, radius_p] = find_circles_UBIRIS(im_en, edgemap, radiusRange, searchRange);
	[center, radius, center_p, radius_p] = find_circles_VW(im_en, edgemap, i_radiusRange, searchRange);

    circles(i).center = center;
    circles(i).center_p = center_p;
    circles(i).radius = radius;
    circles(i).radius_p = radius_p;
    r = radius;
    xc = center(1);
    yc = center(2);

    theta = linspace(0,2*pi);
    x_circle = r*cos(theta) + xc;
    y_circle = r*sin(theta) + yc;
    circles(i).x_circle = x_circle;
    circles(i).y_circle = y_circle;
    
    if save_inter_image
        im_circle = draw_circle(im_src(:,:,1), center(1), center(2), radius);
        fig1 = figure('visible', 'off');
        %imshow(im_circle);
        im_circle = draw_circle(im_circle, center_p(1), center_p(2), radius_p);
        imshow(im_circle);
        %size(im_circle);
        imwrite(im_circle, [inter_dir, filename, '-circle.jpg']);
    end
    
    % process lower half region
    [mask, thresh_high, thresh_low, cir_correct] = mask_lower_region(im_en, center, radius, extend);
        
    % mask upper_region roughly
    mask = mask_upper_region(im_en, mask, center, radius, thresh_high);
    mask = imfill(mask, 'holes');
    
    reflection = get_reflection_region(im_en, thresh_high);    
    pupil_region = get_pupil_region(im_en, reflection, center_p, radius_p, thresh_low);
    
    % remove pupil and reflection
    mask(pupil_region) = 0;
    mask(reflection) = 0;
    
    
    [coffs_u, range_xu, im_eyelid] = fit_eyelid(im_en, center, radius, center_p, radius_p, [0.3, 1], 'upper', 0, save_inter_image);
    if save_inter_image
        imwrite(im_eyelid, [inter_dir, filename, '-eyelidupper.jpg']);
    end
    %imshow(im_eyelid);
    hold on;
    circles(i).coffs_u = coffs_u;
    %collect range of x for eyelids in range_x variable and find the x and
    %y coordinates using the coffecients from the polyfit function
   x_upper = linspace(range_xu(1),range_xu(2));
   y_upper = coffs_u(1)*x_upper.^2 + coffs_u(2)*x_upper + coffs_u(3);
   plot(x_upper,y_upper,'b','LineWidth',2);
%     if hsiz ~= 0
%         im_eni = enhance_image(im_eyelid, hsiz, gau_size);
%     else
%         im_eni = medfilt2(im_eyelid, [3, 3]);
%     end
    [coffs_l, range_xl, im_eyelidLo] = fit_eyelid(im_en, center, radius, center_p, radius_p, [0.8, 1], 'lower', 0, save_inter_image);
    if save_inter_image
        imwrite(im_eyelidLo, [inter_dir, filename, '-eyelidlower.jpg']);
    end
    %imshow(im_eyelidLo);
    circles(i).coffs_l = coffs_l;
   x_lower = linspace(range_xl(1),range_xl(2));
   y_lower = coffs_l(1)*x_lower.^2 + coffs_l(2)*x_lower + coffs_l(3);
   plot(x_lower,y_lower,'k','LineWidth',2);
   
   X0 = [];
   %Find coordinates of intersection 
%    c1_c2 = InterX([x_circle;y_circle],[x_upper;y_upper]);
%    c3_c4 = InterX([x_circle;y_circle],[x_lower;y_lower]);
    [X0,Y0] = intersections(x_circle,y_circle,x_upper,y_upper);
    [X1,Y1] = intersections(x_circle,y_circle,x_lower,y_lower);
    if isempty(X0)
        X0(1) = 0;
        X0(2) = 0;
        Y0(1) = 0;
        Y0(2) = 0;
    end
    if isempty(X1)
        X1(1) = 0;
        X1(2) = 0;
        Y1(1) = 0;
        Y1(2) = 0;
    end
   circles(i).c1 = [X0(1) Y0(1)];
   circles(i).c2 = [X0(2) Y0(2)];
   circles(i).c3 = [X1(1) Y1(1)];
   circles(i).c4 = [X1(2) Y1(2)];
   plot(circles(i).c1(1),circles(i).c1(2),'-r*','MarkerSize',8);
   plot(circles(i).c2(1),circles(i).c2(2),'-r*','MarkerSize',8);
   plot(circles(i).c3(1),circles(i).c3(2),'-r*','MarkerSize',8);
   h = plot(circles(i).c4(1),circles(i).c4(2),'-r*','MarkerSize',8);
   hold off;
   %saveas(h(i),sprintf('figure_%d.jpg',i));
  baseFileName = sprintf('%s.jpg',filename);
    %Specify some particular, specific folder:
 fullFileName = fullfile('D:\Research\Database\UBIRISV2\myPlots', baseFileName);  
  figure(i); % Activate the figure again.
 export_fig(fullFileName); % Using export_fig instead of saveas.
    %fig = figure;
    %hold all;
    %plot(x_circle,y_circle,x_upper,y_upper,P1(1,:),P1(2,:));
    %plot(x_circle, y_circle, x_lower, y_lower, P2(1,:), P2(2,:));
    %print(fig,'-dpng','D:\Research\Database\UBIRISV2\results_generate\inter\');
    %f = cellstr(num2str(i, 'f%d'));
   % str_res = 'D:\Research\Database\UBIRISV2\results_generate\inter\';
    %str_res = strcat(str_res,f);
    %print(fig,'-dpng','D:\Research\Database\UBIRISV2\results_generate\inter\str_res');
    %plot(x_circle,y_circle,x_lower,y_lower,P2(1,:),P2(2,:),'ro')
    
    % process eyelash and shadow
%     mask = process_ES_region(im_en, mask, center, radius, coffs_l, [0.02, 0.8]);
%     
%     % eliminate isolated pixels by "open" operation
%     se = strel('disk', 4);
%     mask = imerode(mask, se);
%     
%     mask = filter_region(mask);
%     
%     se = strel('disk', 3); % 3
%     mask = imdilate(mask, se);
%     
%     score = quality(mask, im_en, center, radius, center_p, radius_p);
%     if(score > quality_thresh)
%         imwrite(mask, [out_dir, filename, '.bmp']);
%         num_pass = num_pass + 1;
%     else
%         imwrite(mask, [fail_dir, filename, '.bmp']);
%         num_fail = num_fail + 1;
%     end
    
    fprintf('Processed image #%d/%d.\n', i, n);
    
end


for i = 1:n
    center = circles(i).center;
    center_p = circles(i).center_p;
    radius = circles(i).radius;
    radius_p = circles(i).radius_p;
    coffs_u = circles(i).coffs_u;
    coffs_l = circles(i).coffs_l;
    c1 = circles(i).c1;
    c2 = circles(i).c2;
    c3 = circles(i).c3;
    c4 = circles(i).c4;
    filename = strtok(files(i).name, '.');
    save([circle_dir, filename, '-circle.mat'], 'center', 'center_p', 'radius', 'radius_p','coffs_u', 'coffs_l', 'c1', 'c2', 'c3', 'c4');
end
