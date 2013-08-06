function [moduleid]=mcode(sbeG,threshold)
%MCODE - modeule detection using MCODE algorithm
%
% [moduleid]=mcode(sbeG) outputs a vector of module memebership 
% assignment for all nodes in the input network
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: James Cai, Kranti Konganti.
% (C) Texas A&M University.
%
% $LastChangedDate: 2012-12-28 19:01:43 -0600 (Fri, 28 Dec 2012) $
% $LastChangedRevision: 278 $
% $LastChangedBy: konganti $
%

if (nargin<2)
      threshold=0.3;
end
n=size(sbeG,1);
weight=zeros(1,n);
outM=cell(1,n);

%weighting all vertices
for k=1:n
    i=sbeG(:,k);
    submatrix=sbeG(i,i);
    [outM{k},ikc]=i_kcore(submatrix);
    n_l=length(outM{k});
    edgesk=(sum(sum(outM{k}))/2)+n_l;
    edgemax=(n_l+1)*n_l/2;
    weight(k)=ikc*(edgesk/edgemax);
end


num=0;
modules=cell(0);

while max(weight)>=2;
    seed=find(weight==max(weight));
    svertex=seed(1);
    %if weight(svertex)<2,break; end;
    nodes=find(sbeG(:,seed(1)));
    neibweight=weight(nodes)>threshold*max(weight);
    module=nodes(neibweight);
  %  if length(module)<3,break, end;
    num=num+1;
    modules{num}=[svertex; module];
    sbeG(module,:)=0;
    sbeG(:,module)=0;
    weight(module)=0;
    weight(seed(1))=0;
end
%coresize=zeros(1,size(modules,2));

r=1;
while r<=length(modules)
    if length(modules{r})<3
        modules(r)=[];
        continue
    end
    r=r+1;
end

moduleid=zeros(n,1);
for u=1:length(modules);
	moduleid(modules{u})=u;
end

%for u=1:length(modules);
%    content=modules{u};
%    coresize(u)=length(content);
%    modules_num=modules{u};
%    pro_name{u}=sbeG(modules_num);    
%end



    
