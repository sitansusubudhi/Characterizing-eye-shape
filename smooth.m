function [ output ] = smooth( input, span )
%SMOOTH2 Summary of this function goes here
%   Detailed explanation goes here

output = input(:);
l = length(input);
s = floor(span/2);

for i = s+1:l-s
    output(i) = mean(input(i-s:i+s));
end

