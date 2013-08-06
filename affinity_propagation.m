function idx = affinity_propagation(sbeG)
%AFFINITY_PROPAGATION - affinity propagation
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: Kranti Konganti, James Cai.
% (C) Texas A&M University.
%
% $LastChangedDate: 2012-12-28 19:01:43 -0600 (Fri, 28 Dec 2012) $
% $LastChangedRevision: 278 $
% $LastChangedBy: konganti $
%

N=size(sbeG,1); A=zeros(N,N); R=zeros(N,N); % Initialize messages
sbeG=sbeG+(eps*sbeG+realmin*100).*rand(N,N); % Remove degeneracies
lam=0.5; % Set damping factor
for iter=1:100
    % Compute responsibilities
    Rold=R;
    AS=A+sbeG; [Y,I]=max(AS,[],2);
    for i=1:N AS(i,I(i))=-realmax; end;
    [Y2,I2]=max(AS,[],2);
    R=sbeG-repmat(Y,[1,N]);
    for i=1:N R(i,I(i))=sbeG(i,I(i))-Y2(i); end;
    R=(1-lam)*R+lam*Rold; % Dampen responsibilities

    % Compute availabilities
    Aold=A;
    Rp=max(R,0); for k=1:N Rp(k,k)=R(k,k); end;
    A=repmat(sum(Rp,1),[N,1])-Rp;
    dA=diag(A); A=min(A,0); for k=1:N A(k,k)=dA(k); end;
    A=(1-lam)*A+lam*Aold; % Dampen availabilities
end;
E=R+A; % Pseudomarginals
I=find(diag(E)>0); K=length(I); % Indices of exemplars
[tmp c]=max(sbeG(:,I),[],2); idx=I(c); % Assignments
