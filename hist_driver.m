function [ ] = hist_driver ( path, varargin )
% hist_driver : Driver function for histogram.
%   path: Path to the image file.
%     n : number of bins, passed to histogram(). Defaults to 256
%         as the images are converted to unint8 grayscale representation.
% min,max: Specifies the minimum and maximum values for the bins. Defaults
% to 0, 255

min = 0;
max = 255;
n = 256;
if (length(varargin) ~= 0 && length(varargin) ~= 3)
    usage();
    return;
end
inputargs = cell2mat(varargin);
if (length(inputargs) == 3)
    n = inputargs(1);
    min = inputargs(2);
    max = inputargs(3);
end
I=imageread(path);

% Call the image histogram function with the values.

bins = histogram(I,n,min,max);
disp(bins);
figure
bar(1:n, bins);
end



function [] = usage ()
fprintf(1,'hist_driver : Driver function for histogram.\npath: Path to the image file. [REQUIRED]\nn : number of bins, passed to histogram(). Defaults to 256\nas the images are converted to unint8 grayscale representation.[optional] [use with min,max]\nmin,max: Specifies the minimum and maximum values for the bins. Defaults to 0, 255 [optional] [use with n]\n');
return;
end
