function plotnet_treering(sbeG,sbeNode,ncenter,alwaysView)
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2012-12-28 19:01:43 -0600 (Fri, 28 Dec 2012) $
% $LastChangedRevision: 278 $
% $LastChangedBy: konganti $
%


[xy]=treering_layout(sbeG,ncenter);
[X, Y] = gplot(sbeG,xy,'-');

if (alwaysView)
    overviewplot(X,Y);
    zoom(2);
else
    fig = figure;
    box off;
    mainAxes = axes('Parent', fig);
    graph = plot(mainAxes, X, Y, '-o', 'LineSmoothing', 'On');
    set(graph, 'color', [.6 .6 .6], 'MarkerEdgeColor','r',...
        'MarkerFaceColor', 'r', 'MarkerSize', 4);
    box(mainAxes, 'off');
    set(findall(fig, 'Type', 'text'), 'FontSize', 5);
end

idx=find(sum(abs(xy)<=1,2)==2);   % centeral nodes

c=1;
num = length(sbeNode)-ncenter;
angles = 0:(360/num):359;

%c1=1;
%num1 = ncenter;
%angles1 = 0:(360/num1):359;
%n2=ncenter+1;
%angles1 = linspace(0,2*pi,n2);

%x = 2*cos(angles*pi/180);
%y = 2*sin(angles*pi/180);
sbeNode=cellfun(@num2str,num2cell(1:size(sbeG,1)),'Uniform',false);

if ischar(sbeNode)
    sbeNodetext=strrep(sbeNode,'_','\_');
    sbeNodetext=strrep(sbeNodetext,'^','\^');
else
    sbeNodetext = sbeNode;
end

for ind = 1:length(sbeNodetext)
    if ismember(ind,idx)
        
        %text(xy(ind,1), xy(ind,2), sbeNode{ind}, 'FontSize', 8, 'Rotation', 0);
        try
            text(xy(ind,1), xy(ind,2), sbeNodetext{ind}, 'Clipping', 'On');
        catch exception
            errordlg(exception.message);
            return;
        end
        %{
        if angles(c1)>90 && angles(c1)<270
        text(xy(ind,1),xy(ind,2),sbeNode{ind},'Rotation',angles1(c1)+180,...
            'HorizontalAlignment','right','fontsize',5)            
        else
        text(xy(ind,1),xy(ind,2),sbeNode{ind},'Rotation',angles1(c1),...
            'HorizontalAlignment','left','fontsize',5)
        end
        c1=c1+1;
        %}
    else
        if angles(c)>90 && angles(c)<270
            try
                text(xy(ind,1),xy(ind,2),sbeNodetext{ind},'Rotation',...
                    angles(c)+180,'HorizontalAlignment','right', 'Clipping', 'On')
            catch exception
                errordlg(exception.message);
                close(wb);
                return;
            end
        else
            try
                text(xy(ind,1),xy(ind,2),sbeNodetext{ind},'Rotation',angles(c),...
                    'HorizontalAlignment','left', 'Clipping', 'On')
            catch exception
                errordlg(exception.message);
                close(wb);
                return;
            end
        end
        c=c+1;
    end
end
%axis equal
%axis square
%axis off
%box off

function [xy]=treering_layout(G,n_center)
%format compact
%format long e

n=num_vertices(G);
if nargin<2
    n_center=5;
end
if ~(n_center>0&&n_center<=n)
    error('N_CENTER needs to be >=1 and <=N')
end

degree_k=sum(G,2);
[~,y]=sort(degree_k);
idx=y(end-n_center+1:end);  % top 5
xy=zeros(n,2);

n1=length(G)-n_center+1;
theta = linspace(0,2*pi,n1);
xy1 = zeros(n1,2);
x = 2*cos(theta);
y = 2*sin(theta);
xy1(1:n1,1) = x(1:n1);
xy1(1:n1,2) = y(1:n1);
xy1(end,:)=[];

n2=n_center+1;
theta = linspace(0,2*pi,n2);
xy2 = zeros(n2,2);
x = cos(theta);
y = sin(theta);
xy2(1:n2,1) = x(1:n2);
xy2(1:n2,2) = y(1:n2);
xy2(end,:)=[];

idx2=setdiff(1:n,idx);
xy(idx,:)=xy2;
xy(idx2,:)=xy1;
end

end