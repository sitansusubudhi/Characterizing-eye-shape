function u = rtv_l1_smooth2(im, lambda, theta, sigma, ep, maxIter)

% As indicated in the paper, a part of the solution from this function comes from following reference.
% L. Xu, Q. Yan, Y. Xia, J. Jia, "Structure extraction from texture via relative total variation"
% ACM Trans. Graphics, vol. 31, no. 6(139), 2012. http://www.cse.cuhk.edu.hk/leojia/projects/texturesep/index.html

    [row, col, c] = size(im);
    if (c>1)
        im = rgb2gray(im);
    end
    im = im2double(im);
    k = row*col;

    if nargin < 6
        maxIter = 5;
    end
    if nargin < 5
        ep = 0.001;
    end
    if nargin < 4
        sigma = 5;
    end
    if nargin < 3
        theta = 0.01;
    end
    if nargin < 2
        lambda = 0.005;
    end

    f = im;
    u = im;
    v = zeros(row, col);

    % figure(1); imagesc(im); colormap(gray);

    for iter = 1:maxIter

        u = computeU(u, v, f, sigma);
        v = computeV(u, f);

        %figure(2); imagesc(u); colormap(gray);
        %figure(3); imagesc(v); colormap(gray);

        %cal_energy(u, im, lambda, G)

        %pause
        sigma = max(sigma/2, 0.5);

    end
    
    function out = gau_filter(in, g)
        out = conv2(in, g, 'same');
        out = conv2(out, g', 'same');
    end
   
    
    function u = computeU(u, v, f, sigma)
        
        fin = u;
        fx = diff(fin,1,2);
        fx = padarray(fx, [0 1 0], 'post');
        fy = diff(fin,1,1);
        fy = padarray(fy, [1 0 0], 'post');

        vareps_s = ep;
        %vareps = 0.001;
        vareps = ep;

        wto = max(sum(sqrt(fx.^2+fy.^2),3)/size(fin,3),vareps_s).^(-1); 
        G = fspecial('gaussian', [1, bitor(1, round(5*sigma))], sigma);
        fbin = gau_filter(fin, G);
        gfx = diff(fbin,1,2);
        gfx = padarray(gfx, [0 1], 'post');
        gfy = diff(fbin,1,1);
        gfy = padarray(gfy, [1 0], 'post');     
        wtbx = max(sum(abs(gfx),3)/size(fin,3),vareps).^(-1); 
        wtby = max(sum(abs(gfy),3)/size(fin,3),vareps).^(-1);   
        wx = wtbx.*wto;
        wy = wtby.*wto;

        wx(:,end) = 0;
        wy(end,:) = 0;
        
        dx = -lambda*theta*2*wx(:);
        dy = -lambda*theta*2*wy(:);
        B(:,1) = dx;
        B(:,2) = dy;
        d = [-row,-1];
        A = spdiags(B,d,k,k);
        e = dx;
        w = padarray(dx, row, 'pre'); w = w(1:end-row);
        s = dy;
        n = padarray(dy, 1, 'pre'); n = n(1:end-1);
        D = 1-(e+w+s+n);
        A = A + A' + spdiags(D, 0, k, k); 
        if exist('ichol','builtin')
            L = ichol(A,struct('michol','on'));    
            tin = f - v;
            [tout, flag] = pcg(A, tin(:),0.1,100, L, L'); 
            u = reshape(tout, row, col);    
        end
        
        return;
        
        G = fspecial('gaussian', [1, bitor(1, round(5*sigma))], sigma);
        
        i = f - v;
        [dx, dy] = gradient(u);
        u_x = 1 ./ max(abs(gau_filter(dx, G)), ep);
        %u_x = gau_filter(u_x, G);
        u_y = 1 ./ max(abs(gau_filter(dy, G)), ep);
        %u_y = gau_filter(u_y, G);

        w_x = 1 ./ max(abs(dx), ep);
        w_y = 1 ./ max(abs(dy), ep);

        uw_x = u_x(:) .* w_x(:);
        uw_y = u_y(:) .* w_y(:);

        tmp = -[uw_x uw_y];
        M = spdiags(tmp, [-row, -1], k, k);

        tmp = uw_x + uw_y;
        tmp(row+1:end) = tmp(row+1:end) + uw_x(1:k-row);
        tmp(2:end) = tmp(2:end) + uw_y(1:k-1);

        L = M + M' + spdiags(tmp, 0, k, k);

        A = spdiags(ones(k, 1), 0, k, k) + L * (lambda * theta * 2);

        L = ichol(A,struct('michol','on'));

        [u, flag] = pcg(A, i(:),0.1,100, L, L');
        
        u = reshape(u, row, col);
    end

    function v = computeV(u, f)
        v = f - u;
        a1 = v > theta;
        a2 = v < -theta;
        a3 = ~(a1 | a2);
        v(a1) = v(a1) - theta;
        v(a2) = v(a2) + theta;
        v(a3) = 0;
    end

    function rtv_e = cal_energy(im_s, im, lambda, G)
        [dx, dy] = gradient(im_s);
        ux = abs(conv2(dx, G, 'same')) + ep;
        ux = conv2(1./ux, G, 'same');
        uy = abs(conv2(dy, G, 'same')) + ep;
        uy = conv2(1./uy, G, 'same');

        wx = 1 ./ (abs(dx) + ep);
        wy = 1 ./ (abs(dy) + ep);

        uwx = ux(:) .* wx(:);
        uwy = uy(:) .* wy(:);
        
        rtv = sum(uwx .* (dx(:).^2) + uwy .* (dy(:).^2));
        diff = im_s(:)-im(:);
        rtv_e = lambda * rtv + sum(abs(diff));
    end
end



