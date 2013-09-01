function [I_out] = dual_threshold ( I, min, max )
% dual_threshold: Given an image I and the min and max thresholds (integers),
%   this function would return a binary image of pixels that fall between the range.
%   I : Input grayscale image. Use image_read for color images before calling this function.
%   min: Minimum threshold of grayscale intensities.
%   max: Maximum threshold of grayscale intensities.

I_out = ( I >= min ) & ( I < max );
end

