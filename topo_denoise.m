function [I_out] = topo_denoise (I_in,noise_threshold)
	I = I_in;
    connect_mat = zeros(size(I_in,1), size(I_in,2), 4);
    
    regions = unique(I(:,:));
    neighbors = [-1 1 size(I,1) -size(I,1)]
    indexes = [];
    for i=1:length(regions)
        region = regions(i);
        indexes = find(I == region);
        % check if the size of this is less than the threshold
        if (indexes < noise_threshold)
            % Get all the neighborhood components and pick the largest.
            % and change the value of this region to match the larger
            % component.
            connected_indexes = bsxfun(@plus, indexes, neighbors);
            connected_indexes = connected_indexes(connected_indexes > 0 & ...
                                                  connected_indexes <= size(I,1)*size(I,2)) ;
            connected_regions = I(connected_indexes)
            connected_regions = connected_regions(connected_regions ~= ...
                                                  region & connected_regions ...
                                                  ~= -1)

            I(indexes) = mode(connected_regions);
        end
    end
    I_out = I;
end
