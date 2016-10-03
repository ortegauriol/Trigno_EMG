function [mus_VAF, matx_VAF, ReconData,trial_VAF,RHO]= synergy_vaf(data,W,H)
%[mus_VAF, matx_VAF, ReconData,trial_VAF]= synergy_vaf(data,W,H)
% This function calculates uncentered correlation coefficients of data and
% reconstructed data = W*H
% determines the mean error in the overall reconstruction as matx_VAF
% Also the errorof each muscle reconstruction (URmus) 
% And for each trial
% Output
%  - URcond   matrix with error % for each condition(e.g., error= [pert_dir error])
%  - URmus    matrix with error % for each muscle (e.g., error= [mus error])
%  - UR       matrix with overall error

% Created; September 29, 2016
% ortegauriol@gmail.com

disp('CALCULATING VAF...');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               DATA ORIENTATION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if size(data,1) > size(data,2)
    data = data';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               RECONSTRUCT DATA                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ReconData=W*H;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               Reconstruction R2                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RHO = zeros(min(size(data),1));
for i = 1:min(size(data))
RHO(i) = (corr(data(i,:)',ReconData(i,:)'))^2;% 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               TRIAL/DIRECTION VAF              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculate error in the reconstruction of each direction
%URcond(1 x nconditions)
[trial_VAF]=rsqr_uncentered(data',ReconData');
trial_VAF=100*(trial_VAF);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  MUSCLE VAF                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculate error in the reconstruction of each muscle activity level
%URmus(nmus x 1)
[mus_VAF]=rsqr_uncentered(data,ReconData);    
mus_VAF=100*(mus_VAF);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 MATRIX VAF                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Overall VAF(scalar)
X=cat(3,data,ReconData);    
matx_VAF=(sum(sum(prod(X,3))))^2/(sum(sum(data.^2))*sum(sum(ReconData.^2)));
matx_VAF=100*matx_VAF;




end