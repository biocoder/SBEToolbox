function plotnet(sbeG,xy,sbeNode,alwaysView)
% This function will plot the graph
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2012-12-28 19:01:43 -0600 (Fri, 28 Dec 2012) $
% $LastChangedRevision: 278 $
% $LastChangedBy: konganti $
%

%if ~issparse(sbeG), sbeG=sparse(sbeG); end
if nargin<4
    alwaysView=false;
end
if nargin<3 || isempty(sbeNode)
    sbeNode=cellfun(@num2str,num2cell(1:size(sbeG,1)),'Uniform',false);
end
if nargin<2
    %xy=random_graph_layout(sbeG);
    xy=fruchterman_reingold_force_directed_layout(double(sparse(sbeG)),...
        'iterations',100);
end

sbeNodetext=strrep(sbeNode,'_','\_');
sbeNodetext=strrep(sbeNodetext,'^','\^');
[X, Y] = gplot(sbeG,xy,'-');

% Using overviewplot from Dan Sternberg of MathWorks
if (alwaysView)
    overviewplot(X, Y);
    text(xy(:,1), xy(:,2), sbeNodetext, 'Clipping', 'On');
    zoom(2);
else
    fig = figure;
    box off;
    mainAxes = axes('Parent', fig);
    graph = plot(mainAxes, X, Y, '-o', 'LineSmoothing', 'On');
    set(graph, 'color', [.6 .6 .6], 'MarkerEdgeColor','r',...
        'MarkerFaceColor', 'r', 'MarkerSize', 4);
    box(mainAxes, 'off');
    text(xy(:,1), xy(:,2), sbeNodetext, 'Clipping', 'On');
    axis off;
end





function plotnet2(sbeG,sbeNode,sbePartition,xy)

    if ~issparse(sbeG), sbeG=sparse(sbeG); end
if nargin<2
    sbeNode=num2str((1:size(sbeG,1))');
end
if nargin<4
    %xy=random_graph_layout(sbeG);
    xy=fruchterman_reingold_force_directed_layout(double(sbeG),'iterations',100);
end


gplot(sbeG,xy);
hold on; 
%plot(xy(:,1), xy(:,2),'r.','MarkerSize',24); hold off;
plot(xy(sbePartition,1), xy(sbePartition,2),'r.');
plot(xy(~sbePartition,1), xy(~sbePartition,2),'g.');

text(xy(:,1)+0.1, xy(:,2)+0.1, sbeNode);

set(gcf,'Color',[1,1,1]);
set(gca,'XTick',[]);
set(gca,'YTick',[]);
%xlim([-1,10]);
%ylim([-2,7]);
axis off;
end
end
