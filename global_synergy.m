function [syn_struct,n_syn,envelope] = global_synergy (data)
% Created; September 29, 2016
% ortegauriol@gmail.com
disp('Initializing EMG Synergies...')
% Declare initial variables
notch = 1;  % To apply notch filter == 1
demean = 1; % Substract the Data mean == 1
unitv = 1;  % To apply unit variance ==1
%****************************************************
%                   DATA LOADER                     %
%****************************************************
if ~exist('data','var')
    [data] = uigetfile('*.mat','Multiselect','off');
end

% If specified data is a file in the workspace take it into an array. 
if ischar(data)
    try
    data = cell2mat(struct2cell(load(data))); 
    catch
        disp('error in load, trying something else')
    end
end

if ischar(data)
    load(data)
end

%Check if data is from diran files
if isfield(data,'Data')
    data = first_structure(data);
end

% If data is in workspace as variable, check file orientation and EMG processing
if exist('data', 'var') 
    if size(data,2) > size(data,1)
        data = data'
        [Raw,filtered,envelope,t] = emg_init_(data,notch,demean,unitv);drawnow;
    else
        [Raw,filtered,envelope,t] = emg_init_(data,notch,demean,unitv);drawnow;
    end   
end

%****************************************************
%               Synergies                 %
%****************************************************
nmus = min(size(data));
for m = 1:nmus-1
   X = ['CALC. FOR SYNERGY ',num2str(m)];
   disp(X);
   syn_struct(m).synergy = m;
   [syn_struct(m).W,syn_struct(m).H,syn_struct(m).D] = synergies(envelope,m,nmus,1);
   [syn_struct(m).mus_VAF, syn_struct(m).matx_VAF, syn_struct(m).ReconData,...
        syn_struct(m).trial_VAF]= synergy_vaf(envelope,syn_struct(m).W,syn_struct(m).H);     
end

n_syn = select_syn(syn_struct);
plot_synergies(syn_struct,n_syn,envelope);
end