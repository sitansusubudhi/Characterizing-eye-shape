function region = get_sector_region(center, radii, angles, size)

    [X, Y] = meshgrid(1-center(1):size(2)-center(1), 1-center(2):size(1)-center(2));
    D = sqrt(X.^2 + Y.^2);

    if angles(1) <= pi/2
        region1 = Y >= tan(angles(1))*X;
    else
        region1 = Y <= tan(angles(1))*X;
    end

    if angles(2) <= pi/2
        region2 = Y <= tan(angles(2))*X;
    else
        region2 = Y >= tan(angles(2))*X;
    end

    region = region1 & region2 & (D>=radii(1)) & (D<=radii(2));

end