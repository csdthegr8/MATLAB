function [ rel_freq ] = histogram ( I, n, min, max )
% function histogram, created as part of first project in CS6640.
%   Implement a function or routine, for instance in matlab
%   histogram(I, n, min, max)
%   that takes a 2D array (image) I as input (integers or floats) 
%   and returns a 1D array of floats (length n) that give the relative
%   frequency of the occurance of greyscale values in each of the n bins
%   that equally (to within integer round off) divide the range of (integer)
%   values between min and max. 


% Create a array of size n.

r_incr = (max - min)/n;
freq = zeros(1,n);
r_start = min;
r_end = min + r_incr;
for i=1:n,
    pixels = (I >= r_start ) & (I < r_end);
    freq(i) = sum(sum(pixels));
    r_start = r_end;
    r_end = r_end + r_incr;
end 
% calculate the relative frequency by dividing by the number of pixels.
I_size = size(I);
pixel_count = I_size(1) * I_size(2);
rel_freq =  freq * (1/pixel_count);
end

