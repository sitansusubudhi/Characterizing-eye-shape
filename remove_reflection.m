function [im, reflection] = remove_reflection(im, thresh, area)

reflection = im2bw(im, thresh);
big_region = bwareaopen(reflection, round(area));
reflection(big_region) = 0;

se = strel('disk', 7); %% 8
reflection = imdilate(reflection, se);

im = roifill(im, reflection);

end