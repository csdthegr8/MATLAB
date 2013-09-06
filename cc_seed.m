function [final_image] = cc_seed(I_in,nbins,thresholds,noise_threshold)
    if isempty(thresholds)
        freq = histogram(I_in,nbins,0,255)
        freq_diff = [diff(freq) >= 0];
        i = 1;
        thresholds = [];
        while i < length(freq_diff)
            if (freq_diff(i+1) ~= freq_diff(i))
                thresholds(end+1) = i * uint8(255/nbins);
            end
            i = i+1;
        end
    end
    ranges = split_threshold(thresholds)
    end_label = 10;
    all_labels = [];
    I=-ones(size(I_in,1),size(I_in,2));
    for i= 1:length(ranges)
        B=dual_threshold(I_in,ranges(i,1),ranges(i,2));
        [I,labels,end_label] = connected_component(I,B,end_label);
        all_labels = [all_labels labels];
        I(I==0) = -1;
    end
    figure
    colors = get_colors();
    final_image = visualize_cc(I,all_labels, 10, end_label, colors);
    imshow(final_image);
    I = topo_denoise(I,noise_threshold);
    final_image = visualize_cc(I,all_labels, 10, end_label, colors);
    figure;
    imshow(final_image);
end

function [colors] = get_colors()
    colors = color.empty();
    color_map = hsv(24);
    for i=1:length(color_map)
        thiscolor = color();
        thiscolor.red = uint8(color_map(i,1)*255);
        thiscolor.green = uint8(color_map(i,2)*255);
        thiscolor.blue = uint8(color_map(i,3)*255);
        colors(end+1) = thiscolor;
    end
    
end
function [ranges] = split_threshold(thresholds)
	min_intensity = 0;
    max_intensity = 255;
    
    thresholds = unique(sort(thresholds));
    ranges = zeros(length(thresholds) + 1,2);
    last_value = min_intensity;
    
    for i=1:length(thresholds)
        ranges(i,:) = [last_value+1,thresholds(i)];
        last_value = thresholds(i);
    end
    ranges(end,:) = [thresholds(end), 255];
end

