function [shfl_data] = shuffle_data(data)

disp('Everyday I''m SHUFFLING!!')

if size(data,1)>size(data,2)
    data=data';
end

[rows, columns] = size(data);
shfl_data = zeros(size(data));
ind=zeros(size(data));
for n = 1:rows
    ind(n,:)=randperm(columns);
    shfl_data(n,:)=data(n,ind(n,:));
end

end