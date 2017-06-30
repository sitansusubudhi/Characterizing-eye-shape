function [coffs, score] = hough_parabolic(x, y, x_ver_range, y_ver_range, a_range)
    a_num = 30;
    d1 = 40;
    d2 = 20;
    param_space = zeros(d1, d2, a_num);
    %length(x)
    
    dx = (x_ver_range(2) - x_ver_range(1)) / (d1-1);
    dy = (y_ver_range(2) - y_ver_range(1)) / (d2-1);
    da = (a_range(2)-a_range(1)) / (a_num-1);
    
    thresh = 3;
    for xi = 1:d1
        b = x_ver_range(1) + (xi-1)*dx;
        for yi = 1:d2
            cc = y_ver_range(1) + (yi-1)*dy;
            for ai = 1:a_num
                a = (ai-1)*da;
                diff = y - cc - a*(x - b).^2;
                votes = nnz(abs(diff) < thresh);
                param_space(xi, yi, ai) = param_space(xi, yi, ai) + votes;
            end
        end
    end
                

%     for i = 1:length(x)
%         xc = x(i);
%         yc = y(i);
%         % for each edge point, vote into the parameter space
%         for xi = 1 : length(x_ver_list)
%             xv = x_ver_list(xi);
%             for yi = 1 : yc - y_ver_list(1) + 1
%                 yv = y_ver_list(yi);
%                 if xv ~= xc
%                     a = (yc - yv) / (xc - xv)^2;
%                     if a <= a_max
%                         ai = round(a/a_max*a_num);
%                         ai = max(1, ai);
%                         param_space(xi, yi, ai) = param_space(xi, yi, ai) + 1;
%                     end
%                 end
%             end
%         end
%     end

    %h = ones(1, 1, 3);
    %param_space = imfilter(param_space, h);
    [mv, ind] = max(param_space(:));
    %max(param_space(:))
    ai = floor(ind/d1/d2)+1;
    tmp = rem(ind-1, d1*d2)+1;
    yi = ceil(tmp/d1);
    xi = rem(tmp-1, d1)+1;

    a = (ai-1)*da;
    b = x_ver_range(1) + (xi-1)*dx;
    cc = y_ver_range(1) + (yi-1)*dy;

    coffs(1) = a;
    coffs(2) = -2*b*a;
    coffs(3) = a*b^2 + cc;
    
    score = mv;


end