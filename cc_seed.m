function [final_image] = cc_seed(I_in,bins)

	freq = histogram(I_in,bins,0,255)
    freq_diff = [diff(freq) >= 0];
    i = 1;
    thresholds = [];
    while i < length(freq_diff)
        if (freq_diff(i+1) ~= freq_diff(i))
            thresholds(end+1) = i * uint8(255/bins);
        end
        i = i+1;
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
    
    colors = get_colors();
    final_image = visualize_cc(I,all_labels, 10, end_label, colors);
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


% max_freq = max(freq);
% max_loc = find(freq == max_freq,1);
% freq(max_loc) = -1;
% density = max_freq;
% if max_loc > 1
%     i = 1;
% else
%     i = 0;
% end
% if max_loc < size(freq,1) - 1
%     j = 1;
% else 
%     j = 0;
% end
% while density < filter_freq
%     window = freq(max_loc-i:max_loc+j)
%     wmax = max(window);
%     wloc = find(window == wmax,1);
%     density  = density + wmax;
%     freq(max_loc -i + wloc - 1) = -1;
%     % determine position in freq 
%     if (length(window) == length(freq))
%         break;
%     end
%     if (wloc < max_loc) 
%         if max_loc - i > 0
%             i = i + 1;
%         else
%             j = j+1;
%         end
%     else
%         if max_loc + j > 0
%             j = j + 1;
%         else
%             i = i+1;
%         end
%     end
% end
% freq
% thresholds = uint8([ min(find(freq == -1)), max(find(freq==-1))] * 255/ 10);
