function centrefigure(parent,child,childsize)
%CENTREFIGURE Centres a figure on a parent or the screen and sets its size
%
% centrefigure(parent,child,childsize)
%
% Centres the child figure on the parent figure, giving
% it the specified size.
% If the parent is zero or empty, the child figure is
% centred on the screen.
% The top of the figure will never be off the top of the screen.  If
% necessary, it will appear below the centre of the parent figure.

% Copyright 2006-2010 The MathWorks, Inc.

sc = get(0,'screensize');
if isempty(parent) | parent==0
    pp = sc;
else
    pp = get(parent,'position');
end
centre = pp(1:2) + pp(3:4) / 2 + [20 -20];
cp = [ centre - childsize/2 , childsize ];
if cp(2) + cp(4) > sc(4)
    % The top of the figure would be off the top of the screen.
    % Move it down until it is on the screen.
    cp(2) = sc(4) - cp(4);
end
set(child,'position',cp);

