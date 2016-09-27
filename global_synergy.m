function [syn_struct,n_syn,envelope] = global_synergy (data)
% Created; September 29, 2016
% ortegauriol@gmail.com


disp('Initializing EMG Synergies...')

notch = 1;
demean = 1;
unitv = 1;

if exist('data', 'var')
    if size(data,2) > size(data,1)
    data = data'
    else
    [Raw,filtered,envelope,t] = emg_init_(data,notch,demean,unitv);drawnow;
    end
elseif ~exist('data','var')
    [Raw,filtered,envelope,t] = emg_init_(first_structure('Megan9.8.0.bin.mat'),notch,demean,unitv);drawnow;
end

%****************************************************
%               EMG INITIAL PROCESS                 %
%****************************************************




nmus = min(size(Raw));
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