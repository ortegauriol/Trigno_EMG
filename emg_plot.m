function [Raw,filtered,envelope,t] = emg_plot(data,notch)
%%EMG plot function for the EMG trigno data visualization. 
%The EMG channels need to be in a column order and each channel will be
%assign to the corresponding column number. If a notch filter (49-51 2nd butter)
%wants to be applied a second variable should be declared.
%The function gives 3 outputs Raw, filtered, and the envelope data...

%Pablo Ortega Auriol 29/07/2016
%****************************************************
%               INITIALIZE & CHECK                  %
%****************************************************
EMG =[];cwd = [];Raw =[];filtered=[];envelope=[];lim=[];

sfreq = 2000;%constant in trigno
if ischar(data)==1
    disp ('Load Data')
    data = load (data);
else 
    disp('input data is an array')
end
t=0:1/sfreq:size(data,1)/sfreq-1/sfreq; %nice way to create time variable.
%****************************************************
%            REMOVE CHANNELS W/ NO DATA             %
%****************************************************
%Get indexes first 
[row column] =find(data(1,:));
% Remove data withot channels
i=1;
for k=1:size(data,2)    
    if mean(data(:,k))~=0
        cwd(:,i)=data(:,k);
        i=i+1;
    end
end
data = cwd;
Raw = cwd;
%%
%****************************************************
%        SIGNAL PROCESSING & INIT ANALYSIS          %
%****************************************************
%DETREND
    data = detrend (data,'constant');
    
%FILTERING
    [b,a] = butter(2,5/(sfreq/2),'high');             
    DataDifFil = filtfilt (b,a,double(data));   
if exist('notch','var')==1
    %Filter to remove, first the 50 hz.
    [b,a] = butter(2,[49,51]/(sfreq/2),'stop');
    DataDifFil= filtfilt(b,a,double(DataDifFil));
else
    disp('No 50 Hz filter was applied')
end
% Low pass filter
    [b,a] = butter(2, 400/(sfreq/2),'low'); 
    DataDifFil = filtfilt(b,a,double(DataDifFil)); 
%Plot frequency analysis spectrum. 
for n = 1:size(DataDifFil,2);
    fig=figure(2);set(fig,'units','normalized','outerposition',[0 0 0.5 1])
    [p,f] = pwelch (DataDifFil(:,n),sfreq,round(0.9*sfreq),sfreq,sfreq);
    subplot(ceil(size(DataDifFil,2)/2),2,n)
    plot(f,p,'color','r'); 
    ax = gca; ax.XColor = 'white'; ax.YColor = 'white'; box off
    if n ==1
        ax.XColor = 'black';ax.YColor = 'black';
    end
    limit(n,:) = ylim;
    xlim([0 500]);
    xlabel('Frequency');ylabel('Power');
    axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
    text(0.5, 1,'\bf Welch Spectral Frequency Analysis of Raw Signal','HorizontalAlignment' ,'center','VerticalAlignment', 'top')
    drawnow
end
    %Plot properties
    set(gcf,'color','w');
    filtered = DataDifFil;
%%
%****************************************************
%                SIGNAL PROCESSING                  %
%****************************************************
%Rectify
data=DataDifFil;
data = abs(data);
figure(3);set(fig,'units','normalized','outerposition',[0 0 0.5 1]);
str = 'Channel. ';
for i=1:size(DataDifFil,2)
    subplot(ceil(size(DataDifFil,2)/2),2,i)
    plot(t,data(:,i),'Color',rgb('Teal'));
        title(strcat(str ,num2str(column(i))))
    hold all
end

%Envelope
[b,a] = butter(2, 6/(sfreq/2),'low'); 
data = filtfilt(b,a,double(data)); 
for i=1:size(DataDifFil,2)
    subplot(ceil(size(DataDifFil,2)/2),2,i)
    plot(t,data(:,i),'r','LineWidth',2);
        ax = gca; ax.XColor = 'white'; ax.YColor = 'white'; box off;
        ylim([0 5*10^-3]);
    if i ==1
        ax.XColor = 'black';ax.YColor = 'Black';
    end
    if i ==2
        legend('Filt.& Rect.','Linear envelope','Location','best');
    end
    xlabel('Time');ylabel('Amplitude (mV)');
    axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
    text(0.5, 1,'\bf Filtered Signal & Envelope','HorizontalAlignment' ,'center','VerticalAlignment', 'top')
    hold all
    
end
set(gcf,'color','w'); 
envelope=data; 
end



