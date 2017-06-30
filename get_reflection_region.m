function region = get_reflection_region( im, thresh )

% GET_REFLECTION_REGION gets the reflection region in the eye image
% Input:
%   im: The target eye image.
%
% Output:
%   region: The reflection region


thresh = max(thresh);
region = im2bw(im, thresh);

se = strel('disk', 2);
region = imdilate(region, se);

end

