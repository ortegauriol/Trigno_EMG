function [Recon_W, W_Contr] = plot_synergies (structure,n_syn,envelope)
%plot_synergies (structure,n_syn)
%function plots the signifficant number of synergies (given by select_syn.m)
%In addition plot the reconstructed signal and coefficients. 
% Created; September 27, 2016
% ortegauriol@gmail.com

str = 'Channel. ';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              GET THE SYNERGIES                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

W_syn = structure(n_syn).W;
H_syn = structure(n_syn).H;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      RECON Individual Synergy Contribution     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
W_Contr = zeros(1,n_syn);
for c = 1:n_syn
    Recon_W{c} = structure(n_syn).W(:,c)*structure(n_syn).H(c,:); %Same as musc_VAF.
%Synergy individual variabilaty % respect to reconstr data
    W_Contr(c) = 100*sum(sum(Recon_W{c}))/sum(sum(structure(n_syn).ReconData));
end


%     matx_VAF=(sum(sum(prod(X,3))))^2/(sum(sum(data.^2))*sum(sum(ReconData.^2)));



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
    X = ['W',num2str(p)];ntitle(X,'fontsize',14,'location','northeast')
    ax=gca;
    ax.TickDir = 'out';
    if n_syn>4
    ax.YLim = [0.5 min(size(envelope))-.5];
    end
    ax.XLim = [0 1];
    if p<n_syn
      ax.XColor = 'white';
    end
    
    %Plot Synergy individual variabilaty % respect to reconstr data
    Str = ['',num2str(W_Contr(p),2),'%'];
    text(.86*max(xlim),max(ylim)-3 ,Str);
    hold all;box off;
    
    
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
    if p<n_syn
        ax.XTick = [];
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%          PLOT OG, RECONS & SYN_CONT            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
X = {1:n_syn};
fig = figure();title('Data Reconstruction Synergies');set(gcf,'color','w');
ax=gca;ax.YColor = 'white'; ax.XColor = 'white';
ha = tight_subplot(ceil(size(structure(n_syn).ReconData,1)/2),2,0.05,[.1 .1],[.1 .03]);
ax=gca;ax.YColor = 'white'; ax.XColor = 'white';
tic;
for g=1:size(structure(n_syn).ReconData,1)
    axes(ha(g));
    %Plot OG DATA ENVELOPE
    plot(envelope(:,g),'Color',rgb ('Black'),'LineWidth',2,'LineStyle','--');hold on 
         title(strcat(str ,num2str(g)));hold on;
    % Plot Reconstructed DATA
    plot(structure(n_syn).ReconData(g,:),'Color',rgb ('DarkRed'),'LineWidth',1.5,'LineStyle','-');hold on

    % Plot each synergy contribution
    for c = 1:n_syn
        plot(Recon_W{c}(g,:),'Color',rgb(colmap(c)));hold on
        X{c}= ['W',num2str(c)];
    end
    %Plot properties
    ax = gca; ylim([0 inf])
    if g == size(structure(n_syn).ReconData,1)
        ax.YColor = 'black';
        ax.XColor = 'black';
    else
        ax.YColor = 'white';
        ax.XColor = 'white';
%         ax.XTick = [];
    end
% Include values of interest. 
    % Linear correlation reconstructed vs envelope
    B = ['R^2 = ',num2str(structure(n_syn).ReconR2(g),2)];
    x = 0.25*max(xlim);
    y = max(envelope(:,g));
    text(x,y ,B);
    % Individual Muscle VAF %
    Str = ['VAF= ',num2str(structure(n_syn).mus_VAF(g),3),'%'];
    text(x,y*0.80 ,Str);
    hold all;box off;
end
toc;
xlabel('Samples')
ylabel('Activation')
% linkaxes([ha(1),ha(2),ha(3),ha(4),ha(5),ha(6),ha(7),ha(8)],'y');
X = ['Orignal EMG', 'Reconstruct Signal',X];
hl = legend(X,'Location','northoutside','Orientation','horizontal');
hl.Position = [0.4 0.88 0.2 0.2];
end