function plot_synergies (structure,n_syn,envelope)
%plot_synergies (structure,n_syn)
%function plots the signifficant number of synergies (given by select_syn.m)
%In addition plot the reconstructed signal and coefficients. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              GET THE SYNERGIES                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

W_syn = structure(n_syn).W;
H_syn = structure(n_syn).H;
Reconstruct = structure(n_syn).ReconData;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              Graph Properties                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

colmap = {'Gold','GreenYellow','Teal','DarkOrange','DarkMagenta','FireBrick','Gray'};
str = 'Channel. ';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            PLOT SYNERGIES & COEFF              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

figure();
idx = [1:3:n_syn^2];

% Plot Synergies
for p=1:n_syn
    subplot(n_syn,3,idx(p))
    barh(W_syn(:,p),'FaceColor',rgb(colmap(p)),'EdgeColor',rgb(colmap(p)));
    box off
    X = ['W',num2str(p)];ntitle(X,'fontsize',14)
    ax=gca;
    ax.TickDir = 'out';
end
set(gcf,'color','w');


%Plot Coefficients
for p=1:n_syn
    subplot(n_syn,3,[idx(p)+1 idx(p)+2])
    plot(H_syn(p,:),'Color',rgb(colmap(p)),'LineWidth',2);
    if p==1
        title('Synergy Coefficient','fontsize',14);
    end
    X = ['W',num2str(p)];ntitle(X,'fontsize',14,'location','southeast')
    box off
    ax=gca;
    ax.TickDir = 'out';
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%          PLOT OG, RECONS & SYN_CONT            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

figure();ha = tight_subplot(size(structure(n_syn).ReconData,1),1,0.01,[.1 .1],[.1 .03]);
for g=1:size(structure(n_syn).ReconData,1)
    axes(ha(g));
    %Plot OG DATA ENVELOPE
    plot(envelope(:,g),'Color',rgb ('Black'),'LineWidth',2,'LineStyle','--');hold on 
        
    % Plot Reconstructed DATA
    plot(structure(n_syn).ReconData(g,:),'Color',rgb ('DarkRed'),'LineWidth',1.5,'LineStyle','-');hold on

    % Plot each synergy contribution
    for c = 1:n_syn
        plot(structure(n_syn).W(c,p)*structure(n_syn).H(c,:),'Color',rgb(colmap(c)));
    end
    
    %Plot properties
    ax = gca;
    if g == size(structure(n_syn).ReconData,1)
        ax.YColor = 'black';
        ax.XColor = 'black';
    else
        ax.YColor = 'white';
        ax.XColor = 'white';
        ax.XTick = [];
    end
    hold all;box off;
end
ylabel('Samples')
xlabel('Activation')
axes(ha(1));
linkaxes([ha(1),ha(2),ha(3),ha(4),ha(5),ha(6),ha(7),ha(8)],'y');
title('Data Reconstruction Synergies')
lgd = legend('Orignal EMG', 'Reconstruct Signal', 'W1','W2','W1','Location',...
    'northoutside','Orientation','horizontal');
set(gcf,'color','w');


end