function [b]=numhlabel(a)

% Population Genetics and Evolution Toolbox (PGEToolbox)
% Author: James Cai
% (c) Texas A&M University
%
% $LastChangedDate: 2013-01-05 11:04:57 -0600 (Sat, 05 Jan 2013) $
% $LastChangedRevision: 324 $
% $LastChangedBy: jcai $

maxlen=length(num2str(max(a)));
b=cell(length(a),1);
b(:)={eval(['sprintf(''%0',num2str(maxlen),'d'',0)'])};
for k=1:length(a)
    b{k}=eval(['sprintf(''%0',num2str(maxlen),'d'',a(k))']);
end



