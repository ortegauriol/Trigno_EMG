function [syn_struct,n_syn,envelope] = global_synergy ()


%****************************************************
%               EMG INITIAL PROCESS                 %
%****************************************************
% The data, coefficients and Synergies are being normalized to the maximal activation
%or max coeficcient value, thus EMG and Synergy values are between 0- 1.

notch = 1;
demean = 1;
unitv = 1;
[Raw,filtered,envelope,t] = emg_init_(first_structure,notch,demean,unitv);drawnow;


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