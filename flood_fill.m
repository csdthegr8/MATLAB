function [I_out] = flood_fill (I, seed_i,seed_j, B, fill_value, adj_scheme)

%  usage:  I_out = flood_fill (I, B, fill_value)
%  I_out : Flood fill of image I will fill_value.
%  B     : Input binary image.
%  adj_scheme: 4 or 8 representing the adjacency of pixels.
%  Process any image with the dual_threshold to get the binary image
%  I is a nXn matrix which will be filled with the value of fill_value
%  Can be called with flood_driver
    
    assert(adj_scheme == 4 || adj_scheme == 8, ['The adjacency has be ' ...
                        'either 4 or 8']);
    
    I_size = size(I);
    I_rows = I_size(1);
    I_cols = I_size(2);
    
    if B(seed_i,seed_j) == 1
        to_visit = [seed_i,seed_j];
        I(seed_i,seed_j) = fill_value;
        while ~isempty(to_visit)
            cur_pos = to_visit(1,:);
            to_visit(1,:) = [];
            x = cur_pos(1);
            y = cur_pos(2);
            if I(x,y) == fill_value
                pos_neighbors = find_neighbors(I_rows,I_cols, x, y, adj_scheme);
                for i = 1:length(pos_neighbors)
                    next_x = pos_neighbors(i,1);
                    next_y = pos_neighbors(i,2);
                    % Add a previously unvisited neighboring pixel to the
                    % list and mark the pixels as visited (setting to zero)
                    if B(next_x,next_y) == 1 && I(next_x,next_y) <= 0
                        to_visit(end+1,:) = [next_x, next_y];
                        I(next_x,next_y) = fill_value;
                    elseif I(next_x,next_y) ~= fill_value
                        I(next_x,next_y) = 0;
                    end
                end
            end
            
        end
    end
    I_out = I;
end
    
function [pos_neighbors] = find_neighbors (I_rows,I_cols, x, y, adj_scheme) 
% Add the top, bottom, right and left pixels.
    % top
    pos_neighbors = [];
    if x > 1
        pos_neighbors(end+1,:) = [x-1,y];
    end
    
    % left
    if y > 1
        pos_neighbors(end+1,:) = [x,y-1];
    end

    % bottom
    if x < I_rows 
        pos_neighbors(end+1,:) = [x+1,y];
    end

    % right
    if y < I_cols 
        pos_neighbors(end+1,:) = [x,y+1];
    end
    
    if adj_scheme == 8
        if x > 1 && y > 1
            pos_neighbors(end+1,:) = [x-1,y-1];
        end
        if x > 1 && y < I_cols
            pos_neighbors(end+1,:) = [x-1,y+1];
        end
        if x < I_rows  && y > 1
            pos_neighbors(end+1,:) = [x+1,y-1];
        end
        if x < I_rows && y < I_cols
            pos_neighbors(end+1,:) = [x+1,y+1];
        end
    end
end
