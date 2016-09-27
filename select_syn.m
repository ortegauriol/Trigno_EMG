function [n_synergies] = select_syn(syn_struct)
%[n_synergies] = select_syn() 
%Calculate a sygnificant number of synergies based on VAF>90 && VAFmus>80
% Created; September 29, 2016
% ortegauriol@gmail.com


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            Extract from structure              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%get global and mus_VAF
    for i=1:length(syn_struct)
        global_VAF(i)=syn_struct(1,i).matx_VAF;
        musc_VAF(i,:)=syn_struct(1,i).mus_VAF;
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             MET the CONDITIONS                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% get the index where two conditions are applied    
    mus_vaf_thrs=min(musc_VAF,[],2);
    I=find(global_VAF(:)>=90 & mus_vaf_thrs(:)>=80);
    n_synergies=I(1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             PLOT Global VAF SELECTION          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      

global_VAF = [0 global_VAF];
syn_vec = [0:length(syn_struct)];
figure();plot(syn_vec,global_VAF,'Color',rgb('Gold'),'LineWidth',2,'MarkerSize',200,'MarkerFaceColor',[0.5,0.5,0.5]);
set(gcf,'color','w');
ax=gca;
ax.XTick = [0:length(syn_struct)];
xlim(ax, [0 length(syn_struct)+1]);
xlabel('\fontsize{18} Number of Synergies');
ylim(ax, [0 115]);
ylabel('\fontsize{18} Global VAF (%)');
str = ['    VAF = ', num2str(round(syn_struct(n_synergies).matx_VAF)),'%'];
ah = annotation('textarrow','String',str);
     set(ah,'parent',gca);
     set(ah,'position',[n_synergies-1 60 1 round(syn_struct(n_synergies).matx_VAF)-59]);
     ah.HeadStyle = 'astroid';
     grid on
hold all;
X = ['Signifficant number of synergies == ',num2str(n_synergies)];
disp(X)
end
