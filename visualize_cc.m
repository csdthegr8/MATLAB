function [I_out] = visualize_cc (I, labels, start_label, end_label, colors)
% Loops through the different label values and creates a 3-channel image of
% the input label image and colors the regions by looping through 'colors'
% array
    
    I_size = size(I);
    I_out = zeros(I_size(1), I_size(2), 3);
    for l = labels
        [i,j] = ind2sub(size(I),find(I == l));
        thiscolor = colors(1);
        colors(1) = [];
        colors(end+1) = thiscolor;
        for k=1:length(i)
            I_out(i(k),j(k),1) = thiscolor.green;
            I_out(i(k),j(k),2) = thiscolor.blue;
            I_out(i(k),j(k),3) = thiscolor.red;
        end
    end
end

