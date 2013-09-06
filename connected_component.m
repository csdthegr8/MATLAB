function [I_out, labels, end_label] = connected_component (I, B, label_value)
% connected_components: Returns all the connected components in the image.
% Each connected component is marked by increasing label_value.
% I : the label image.
% B : the binary image.
% label_value : starting label value to assign to the first CC.
% I_out : The output image containing the connected components.
% labels: The set of all labels in the image. length(labels) should denote
% the number of connected components in teh image 
% end_label: The last label value.

I_size = size(I);
%I = -ones(I_size(1), I_size(2));

fill_value = label_value;
indexes = find(B);
labels = [];

while ~isempty(indexes)
    this_index = indexes(1);
    indexes(1) = [];
    [i,j] = ind2sub(size(B), this_index);
    if (I(i,j) < 0) 
        I = new_flood_fill(I,i,j,B,fill_value,4);
        labels(end+1) = fill_value;
        fill_value = fill_value + 10;
    end
end

I_out = I;
end_label = fill_value-10;
end