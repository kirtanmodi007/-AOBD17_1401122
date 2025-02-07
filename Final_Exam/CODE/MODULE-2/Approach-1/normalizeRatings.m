function [Ynorm, Ymean] = normalizeRatings(Y, R)
%NORMALIZERATINGS Preprocess data by subtracting mean rating for every 
%skill (every row)

[m, n] = size(Y);
Ymean = zeros(m, 1);
Ynorm = zeros(size(Y));
for i = 1:m
    idx = find(R(i, :) == 1);
    Ymean(i) = mean(Y(i, idx));
    Ynorm(i, idx) = Y(i, idx) - Ymean(i);
end
end
