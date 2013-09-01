% Nonlocal means with PCA projection. Author: Tolga Tasdizen, tolga@sci.utah.edu
% Details of the algorithm can be found at 
% T. Tasdizen, "Principal Neighborhood Dictionaries for Non-local Means
% Image Denoising," IEEE Transactions on Image Processing, vol. 18, no. 12., pp. 2649-60, December 2009. 
% Free for use and modification for any purpose other than use in a commercial application or product
%
% I_out = PND (I_in, patch_halfsize, search_window_halfsize, p_sigma, pcadim)
% I_in: input image
% patch_halfsize: use a (2xpatch_halfsize + 1)^2 window as the feature vector
% search_window_halfsize: use a (2xsearch_window_halfsize + 1)^2 window for averaging
% p_sigma: the standard deviation for the Gaussian kernel used in averaging
% pcadim: # of PCA dimensions to use
function I_out = PND (I_in, patch_halfsize, search_window_halfsize, p_sigma, pcadim)
var = p_sigma^2;
I_size = size(I_in);
width = I_size(2);
height = I_size(1);
I_out = zeros(height,width);

offset = SquareNeighborhood(patch_halfsize);
fv = ConstructNeighborhoods(I_in,offset,1);
fv = PCAbasis (fv, pcadim);

offset_x = ones(2*search_window_halfsize+1,1)*(-search_window_halfsize:search_window_halfsize);
offset_y = (-search_window_halfsize:search_window_halfsize)'*ones(1,2*search_window_halfsize+1);
offset_x = offset_x(:);
offset_y = offset_y(:);
k = 0;
for pos_x = 1:width
    for pos_y = 1:height 
        k = k + 1;
        sample_x = offset_x + pos_x;
        sample_y = offset_y + pos_y;
        if pos_x<=search_window_halfsize | pos_x>(width-search_window_halfsize) | pos_y<=search_window_halfsize | pos_y>(height-search_window_halfsize)
            index = find( (sample_x>0) & (sample_x<=width) & (sample_y>0) & (sample_y<=height));
            sample = (sample_x(index) - 1) * height + sample_y(index);
        else
            sample = (sample_x - 1)*height + sample_y;
        end;
        n_sample = length(sample);

        B = fv(:,k);
        BtB = B'*B;
        A2 = sum(fv(:,sample).^2,1);
        distSqr = A2 + BtB - 2*B'*fv(:,sample);
        
        W = exp(-distSqr/var);
        sumW = sum(W,2);
        W = W / sumW;
        
        I_out (k) = W*I_in(sample);
    end;
end;

function projfv = PCAbasis (fvs, dimb)
dim = size(fvs,1);
n = size(fvs,2);
[e,v] = eig(fvs*fvs'/n);
k = dim - dimb + 1;
basis = e(:,dim:-1:k);
projfv = basis'*fvs;
function offset = SquareNeighborhood (radius)
halfsize = ceil(radius);
fullsize = 2*halfsize + 1;
offset_x = ones(fullsize,1)*(-halfsize:halfsize);
offset_y = (-halfsize:halfsize)'*ones(1,fullsize);
offset_x = offset_x(:)';
offset_y = offset_y(:)';
offset = [offset_x; offset_y];
function fv = ConstructNeighborhoods (I, offset, flag)
width = size(I,2);
height = size(I,1);
halfsize = ceil(max(abs(offset(:))));
fullsize = 2*halfsize + 1;
padsize = 2*halfsize;
offset_x = offset(1,:)';
offset_y = offset(2,:)';
dim = size(offset,2);
Ipad = zeros(height + padsize, width + padsize);
Ipad(halfsize+1:halfsize+height,halfsize+1:halfsize+width) = I;
for k = 1:halfsize
    Ipad(k,:) = Ipad(halfsize+1,:);
    Ipad(height+padsize+1-k,:) = Ipad(halfsize+height,:);
end;
for k = 1:halfsize
    Ipad(:,k) = Ipad(:,halfsize+1);
    Ipad(:,width+padsize+1-k) = Ipad(:,halfsize+width);
end;
if (flag)
    pos_x = ones(height,1)*(1:width);
    pos_x = halfsize + bsxfun(@plus,reshape(pos_x,1,width*height),offset_x);
    pos_y = (1:height)'*ones(1,width);
    pos_y = halfsize + bsxfun(@plus,reshape(pos_y,1,width*height),offset_y);
else
    pos_x = ones(height-padsize,1)*(halfsize+1:width-halfsize);
    pos_x = halfsize + bsxfun(@plus,reshape(pos_x,1,(width-padsize)*(height-padsize)),offset_x);
    pos_y = (halfsize+1:height-halfsize)'*ones(1,width-padsize);
    pos_y = halfsize + bsxfun(@plus,reshape(pos_y,1,(width-padsize)*(height-padsize)),offset_y);
end;
temp = height + padsize;
index = pos_y + (pos_x-1)*temp;
fv = Ipad(index);