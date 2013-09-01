function [I] = imageread (path)
% imageread : returns a 2D array of the image. Uses imread internally.

% Determine type of image.
imageinfo = imfinfo(path);
if (strcmp(imageinfo.ColorType, 'grayscale'))
    I = imread(path);
elseif (strcmp(imageinfo.ColorType, 'truecolor'))
    % convert it to our representation of a 2D array.
    I_color = imread(path);
    I = 0.21 * I_color(:,:,1) + 0.71 * I_color(:,:,2) + 0.07 * I_color(:,:,3);
else
    fprintf(1,'\nUnable to handle image file!\n');
    return;
end
end
