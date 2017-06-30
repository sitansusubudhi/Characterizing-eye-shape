msk_dir = 'D:\Research\Database\UBIRISV2\results_generate\results\';
gt_dir = 'D:\Research\Database\UBIRISV2\results_generate\frgc_gt\';

files = dir([msk_dir, '*.bmp']);
n = length(files);
err_rates = zeros(n, 1);

for i = 1:n
    msk = imread([msk_dir, files(i).name]);
    gt = imread([gt_dir, files(i).name]);
    gt = gt(:, :, 1);
    
    err = nnz(xor(msk, gt))/numel(msk);
    err_rates(i) = min(err, 1-err);
end

mean(err_rates)