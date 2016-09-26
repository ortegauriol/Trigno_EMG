
function  [data] = first_structure()

fid = ('pptr01115');
Nmus=8; %ncond=12; % ntrials=5; nbins=4;
NSyn = 7;
sfreq= 1000;
Data = load (fid);
Emg = Data.data.Data.DAQ_DATA.buffer; 
[r k]=size(Emg);
srt=1:Nmus:r*k; %sort EMGdata by muscle
N=k*r/Nmus; 
t=0:1/sfreq:N/sfreq-1/sfreq; %nice way to create time variable.

%****************************************************
%               SORT & PLOT RAW DATA                %
%****************************************************  
EMG=[];
    figure();
    for i=1:Nmus
        EMG=[EMG;Emg(srt+i-1)];
        subplot(ceil(Nmus/2),2,i)
            plot(t',EMG(i,:))
        xlabel('time')
        hold all
    end

    
data = EMG';  

end


