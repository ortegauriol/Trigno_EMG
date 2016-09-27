function [ursqr] = rsqr_uncentered(data,data_rec)
% Function that calculates VAF as the
%regression sum of squares/total sum of squares
% Output
%    - ursqr; uncentered VAF calculation stills needs *100.

% Created; September 29, 2016
% ortegauriol@gmail.com

data = data';
data_rec = data_rec';
ursqr = zeros(1,size(data,2));
% Zar page 334
dim_data = size(data);
for i = 1:dim_data(2)
    X = [data(:,i) data_rec(:,i)];
    ursqr(i) = sum(prod(X,2))^2 / (sum(data(:,i).^2)*sum(data_rec(:,i).^2));
end
ursqr = ursqr';

end