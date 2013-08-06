function plotnet_edgewidth(sbeG,lineweight,xy,sbeNode)
%PLOTNET_EDGEWIDTH - network plot with defined edge width

% 
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: Kranti Konganti, James Cai.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-01-07 19:35:26 -0600 (Mon, 07 Jan 2013) $
% $LastChangedRevision: 335 $
% $LastChangedBy: jcai $
%

%if ~issparse(sbeG), sbeG=sparse(sbeG); end
if nargin<4
    sbeNode=num2str((1:size(sbeG,1))');
end
if nargin<3
    %xy=random_graph_layout(sbeG);
    xy=fruchterman_reingold_force_directed_layout(double(sparse(sbeG)),...
        'iterations',100);
end
[x, y]=find(sbeG>0);
colors_bars=[-1.0 -0.9 -0.8 -0.7 -0.6 0.6 0.7 0.8 0.9 1.0+eps];
colors_width=[2 1.5 1.0 0.5 0.5 0.5 1.0 1.5 2];
colors=[8 81 156; 49 130 189; 107 174 214; 189 215 231; 200 200 200; 252 174 145; 251 106 74; 222 45 38; 165 15 21];
colors=colors/255;

for i=1:length(x)
    if x(i)<y(i) continue; end
    temp_r=lineweight(x(i),y(i));
    
    if temp_r==0
        line([xy(x(i),1) xy(y(i),1)],[xy(x(i),2) xy(y(i),2)],'color',[0.6 0.6 0.6],'linewidth',0.5,'LineSmoothing','on');
    else
        temp_n=sum(temp_r>=colors_bars);
        line([xy(x(i),1) xy(y(i),1)],[xy(x(i),2) xy(y(i),2)],'color',colors(temp_n,:),'linewidth',colors_width(temp_n),'LineSmoothing','on');
    end
end
    
    
hold on;
%5z=ones(size(xy(:,1)));
plot(xy(:,1), xy(:,2), 'r.');
text(xy(:,1), xy(:,2), sbeNode);
%text(xy(:,1), xy(:,2), sbeNode);
set(gcf,'Color',[1,1,1]);

%set(gca,'XTick',[]);
%set(gca,'YTick',[]);
%axis off;
axis square

end
