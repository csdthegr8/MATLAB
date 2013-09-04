function [p_random] = rand_normal()
p_random= pseudo_random();
end

function [p_random] = pseudo_random()
% implements a linear congruential random number generator based off the
% following formula:

% x(n+1) = (40692 * x(n)) mod  + 2^31 - 249

seed = 1321349;
persistent xnminusone;
fprintf(1,'i came here');
if isempty(xnminusone)
     xnminusone = seed;
end
xnminusone = mod ((40692 * xnminusone), (2^31 - 249));
p_random = xnminusone;
end
    