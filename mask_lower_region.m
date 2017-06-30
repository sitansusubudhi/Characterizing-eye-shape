function [mask, thresh_high, thresh_low, cir_correct] = mask_lower_region(im, c, r, extend)
    %class(im)
    %imshow(im);
    %pause
    [rows, cols] = size(im);

    mask = false(rows, cols);

    %t_angles = [0, 0.33*pi, 0.25*pi, 0.75*pi, 0.67*pi, pi];
    angles = [0, 0.25*pi, 0.75*pi, pi];

    thresh_high = zeros(3, 1);
    thresh_low = zeros(3, 1);
    quality = zeros(3, 1);
    
    r_range = extend * r;

    [thresh_high(1), thresh_low(1), quality(1)] = thresh_angle_range(im, c, r_range, angles(1:2));
    [thresh_high(2), thresh_low(2), quality(2)] = thresh_angle_range(im, c, r_range, angles(2:3));
    [thresh_high(3), thresh_low(3), quality(3)] = thresh_angle_range(im, c, r_range, angles(3:4));

    cir_correct = 0;
% 
%     for j = [1, 3]
%         if quality(j) < 0.3
%             [th1, tl1, q1] = thresh_angle_range(im, c, r_range+10, angles(j:j+1));
%             [th2, tl2, q2] = thresh_angle_range(im, c, r_range-10, angles(j:j+1));
%             if q1 > q2 && q1 > quality(j)
%                 %'big'
%                 cir_correct = 1;
% 
%             elseif q2 > q1 && q2 > quality(j)
% 
%                 if th2 < mean(thresh_high) - 0.15 && q2 > 0.15
%                     cir_correct = 1;
% 
%                 elseif cir_correct == 0
%                 %   'small'
%                     cir_correct = -1;
%                 end
%             end
%         else
%             %idx = [1, 2, 3] ~= j;
%             if thresh_high(j) < mean(thresh_high) - 0.15
%                 cir_correct = 1;
%             end
%         end
%     end


    for j = 1:length(angles) - 1
        mask = segment_angle_range(im, mask, c, r, angles(j:j+1), thresh_high(j));
    end
    

    %figure(5);
    %show_mask(im, mask, 1);

end

