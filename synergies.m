function [W,H,D,data] = synergies (data,nsyn,nmus,unitv)

% Function to calculate muscle modes or synergies. 
% [W,H,D] = synergies (data,nsyn,nmus)
% INPUT: EMG data in rows

% Created; September 19, 2016
% ortegauriol@gmail.com

%****************************************************
%               SYNERGY THROUGH NNMF                %
%****************************************************

%%%%addon%%%% Check for negative values. 


disp('CALCULATING SYNERGIES...')
%****************************************************
%                    UNIT VARIANCE                  %
%****************************************************   
% 
% for each channel (column at this point) if you have unit variance 
% the synergies calculation will not be drive or influenced by muscles 
% with higher variance. 
%
if exist('unitv','var')==1
    stdv = std(data);
    for i= 1:size(data,2)
        data(:,i) = data(:,i)./std(data(:,i));
    end
    disp('Unit Variance ON')
else
    disp('Unit Variance OFF')
end
data = data'; % From column to row.

%Options set for synergies
opt = statset('Display','final','tolx',1e-3,'MaxIter', 1000,'TolFun',1e-6);
%Minor Variables and memory allocation. 
rep = 20;
W= zeros(nmus,nsyn,rep);
H= zeros(nsyn,size(data,2),rep);
D= zeros(1,rep);

%****************************************************
%                      NMF                         %
%****************************************************

[W,H,D] = nnmf (data,nsyn,'algorithm','mult','rep',rep,'options',opt);
data = data'; % From row to column. 

%****************************************************
%                    UNIT VARIANCE                  %
%**************************************************** 
% Unit variance has to be retrieved to convert data into the original data
% set. This has to be applied as linear transformation to the modes. 

if exist('unitv','var')==1
for i= 1:size(data,2)
        data(:,i) = data(:,i).*stdv(i);
end
W= diag(stdv)*W;
else
    disp('Data no longer in unit variance')
end

%****************************************************
%                VECTOR NORMALIZATION               %
%****************************************************   
% EMG must be normalized to apply this, normalize to maximal activation
% through all muscles. 

m=max(W);
for i=1:nsyn
    H(i,:)=H(i,:)*m(i);
    W(:,i)=W(:,i)/m(i);
end


end