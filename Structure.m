function [EMG] = structure(data) 

%%This allows to change the data structure when acquired from Dragonfly bin
%%to mat converter 

%****************************************************
%                Load and declare                   %
%****************************************************
load (data);
data = log.Data.TRIGNO_DATA.T;
channels = 16; % available chanels in trigno base. 
final = 1;
%****************************************************
%                Channels to Column                 %
%****************************************************
for j = 1:channels
    channel{j} = [];
end
%Columns are a 27 samples per channel
for j = 1:channels
   start = final+1; final = 27*j; 
        if j==1
            start=1;
        end
    for i = 1:size(data,2)
        channel{j} = [channel{j};data(start:final,i)];
    end
end
%Output just an array
EMG = cell2mat(channel);
S = sprintf('Data is an EMG array ordered in columns %n');
disp(S)
end 