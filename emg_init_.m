function [raw,filtered,envelope,t] = emg_init_(data,notch,det,unitv,sfreq)
%%  [Raw,filtered,envelope,t] = emg_plot(data,notch,detrend,sfreq)
%
% notch, if true 50 Hz filter is on. 
% detrend, if TRUE data is detrended before filter application 
%
%EMG plot function for the EMG trigno data visualization. 
%The EMG channels need to be in a column order and each channel will be
%assign to the corresponding column number. If a notch filter (49-51 2nd butter)
%wants to be applied a second variable should be declared.
%The function gives 3 outputs Raw, filtered, and the envelope data...

% Created; September 29, 2016
% ortegauriol@gmail.com

disp('PROCESSING EMG...')
%%
%****************************************************
%               INITIALIZE & CHECK                  %
%****************************************************
EMG =[];cwd = [];Raw =[];filtered=[];envelope=[];lim=[];
str = 'Channel. '; 

if ~exist('sfreq', 'var')
sfreq = 2000;%constant in trigno
end

if ischar(data)==1
    disp ('Load Data')
    data = load (data);
else 
    disp('Data from workspace')
end
t=0:1/sfreq:size(data,1)/sfreq-1/sfreq; %nice way to create time variable.
%****************************************************
%            REMOVE CHANNELS W/ NO DATA             %
%****************************************************

%Get indexes first 
[row, column] = find(data(2,:));
% Remove data withot channels
i=1;
for k=1:size(data,2)    
    if mean(data(:,k))~=0
        cwd(:,i)=data(:,k);
        i=i+1;
    end
end
Raw = cwd;
raw=cwd;

%%
%****************************************************
%                SIGNAL PROCESSING                  %
%****************************************************
%****************************************************
%                    DETREND                        %
%**************************************************** 

if exist('det','var')==1
    data = detrend (Raw,'constant');
    disp('Data mean substracted');
else
    disp('Not detrended') 
end

%****************************************************
%                  FILTERING                        %
%**************************************************** 

%HIGH PASS FILTER%%
    [b,a] = butter(2,5/(sfreq/2),'high');             
    DataDifFil = filtfilt (b,a,double(data));   
if exist('notch','var')==1
    %Filter to remove, first the 50 hz.
    [b,a] = butter(2,[49,51]/(sfreq/2),'stop');
    DataDifFil= filtfilt(b,a,double(DataDifFil));
    disp('50 Hz filter ON')
else
    disp('50 Hz filter OFF')
end

% LOW PASS FILTER
    [b,a] = butter(2, 400/(sfreq/2),'low'); 
    DataDifFil = filtfilt(b,a,double(DataDifFil)); 
    
%PLOT FREQUEMCY ANALYSIS
%Case that data points is less than a second
if size(DataDifFil,1)<sfreq
   window =  size(DataDifFil,1);
else
    window = sfreq;
end
    
for n = 1:size(DataDifFil,2);
    fig=figure(2);set(fig,'units','normalized','outerposition',[0 0 0.5 1])
    [p,f] = pwelch (DataDifFil(:,n),window,round(0.25*window),sfreq,sfreq);
    handle(column(n)) = subplot(ceil(size(DataDifFil,2)/2),2,n); plot(f,p,'color','r'); 
    title(strcat(str ,num2str(column(n))))
    ax = gca; ax.XColor = 'white'; ax.YColor = 'white'; box off;
    if n ==size(DataDifFil,2)
        ax.XColor = 'black';ax.YColor = 'black';
    end
    limit(n,:) = ylim;
    xlim([0 600]);
    xlabel('Frequency');ylabel('Power');
    axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
    text(0.5, 1,'\bf Welch Spectral Frequency Analysis of Raw Signal','HorizontalAlignment' ,'center','VerticalAlignment', 'top');
    drawnow;
end
%     Same limit for all plots y axis
%     for p = column
%         ylim(handle(p),[0 max(limit(:))])
%     end
    set(gcf,'color','w');
    
%****************************************************
%                    RECTIFY                        %
%**************************************************** 
data=DataDifFil;
data = abs(data);
filtered = data;

%%
%****************************************************
%                 NORMALIZE DATA                    %
%**************************************************** 
%Intro MVC normalization of the data
%Normalize to max activation of one muscle.

normal = max(data(:));
data = data./normal;

%Norm to max activation of each muscle 
%Norm to baseline

%%

%****************************************************
%               PLOT FILTERED DATA                  %
%**************************************************** 
figure(3);set(fig,'units','normalized','outerposition',[0 0 0.5 1]);
% ha= tight_subplot(ceil(size(DataDifFil,2)/2),2,0.05,[.1 .1],[.1 .03]);
ax = gca; ax.XColor = 'white';
for i=1:size(DataDifFil,2)
    subplot(ceil(size(DataDifFil,2)/2),2,i)
%     axes(ha(i))
    plot(t,data(:,i),'Color',rgb('Teal'));
    
        title(strcat(str ,num2str(column(i))))
    hold all
end


%****************************************************
%                   ENVELOPE                        %
%**************************************************** 
[b,a] = butter(2, 6/(sfreq/2),'low'); 
data = filtfilt(b,a,double(data)); 
for i=1:size(DataDifFil,2)
    subplot(ceil(size(DataDifFil,2)/2),2,i);
    plot(t,data(:,i),'r','LineWidth',2);
    ax = gca; ax.XColor = 'white'; ax.YColor = 'white'; box off;
    ylim([0 inf]);
    lim(i,:) = ylim;
    if i ==size(DataDifFil,2)
        ax.XColor = 'black';ax.YColor = 'Black';
    end 
hl=legend('Filt.& Rect.','Linear envelope','Location','north','Orientation','horizontal');
hl.Position = [0.4 0.84 0.2 0.2];
    xlabel('Time');ylabel('Amplitude (mV-Unit STD)');
    axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
    text(0.5, 1,'\bf Filtered Signal & Envelope','HorizontalAlignment' ,'center','VerticalAlignment', 'top')
    hold all
end
set(gcf,'color','w'); 
envelope=data; 
     
disp('To synergies!! >>>>')
    
%%    
%****************************************************
%        AVERAGE THE DATA OR SELECT A WINDOW        %
%****************************************************
    
    
%****************************************************
%        CONCATENATE THE DATA FOR INPUT             %
%****************************************************
    

end



