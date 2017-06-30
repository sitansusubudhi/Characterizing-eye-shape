function bw = filter_region(bw)
    %bw = ~bwareaopen(bw, 400);
    %se = strel('disk', 5);
    %bw = imclose(~bw, se);
    label = bwlabel(bw);

    stat = regionprops(bw, 'basic');
    %cens = cat(1, stat.Centroid);
    areas = cat(1, stat.Area);

    %len = size(areas, 1);

    [ma, idx] = max(areas);

    if isempty(idx)
        return;
    end

    bw = (label == idx);

end