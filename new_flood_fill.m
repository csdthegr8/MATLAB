function [I_out] = new_flood_fill (I, seed_i,seed_j, B, fill_value, adj_scheme)

%  usage:  I_out = flood_fill (I, B, fill_value)
%  I_out : Flood fill of image I will fill_value.
%  B     : Input binary image.
%  adj_scheme: 4 or 8 representing the adjacency of pixels.
%  Process any image with the dual_threshold to get the binary image
%  I is a nXn matrix which will be filled with the value of fill_value
%  Can be called with flood_driver
    
    assert(adj_scheme == 4 || adj_scheme == 8, ['The adjacency has be ' ...
                        'either 4 or 8']);
    
    neighbors = [-1,1,size(I,1),-size(I,1)];
    if (adj_scheme == 8) 
        neighbors = [neighbors [size(I,1)-1 ,-size(I,1)-1,size(I,1)+1,-size(I,1)+1]];
    end
    
    seed = sub2ind(size(I), seed_i, seed_j);
    if(B(seed) == 1)
        to_visit = [seed];
        I(seed) = fill_value;
        while ~isempty(to_visit)
            cur_pos = to_visit(1);
            to_visit(1) = [];
            if I(cur_pos) == fill_value
                pos_neighbors = bsxfun(@plus, neighbors, cur_pos);
                pos_neighbors = pos_neighbors(pos_neighbors > 0 & pos_neighbors ...
                                              <= size(I,1)*size(I,2)) ;

                connected_neighbors = pos_neighbors(B(pos_neighbors)> 0);
                unvisited_neighbors = connected_neighbors(I(connected_neighbors) < 0);
                to_visit = [to_visit unvisited_neighbors];
                I(pos_neighbors(I(pos_neighbors)~=fill_value)) = 0;
                I(connected_neighbors) = fill_value;
            end
        end
    end
    I_out = I;
end