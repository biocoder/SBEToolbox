function printdistmat(D,sbeNode,dec)
%PRINTMATRIX - Prints to the screen a printout of the matrix
%
% printmatrix(D,aln,dec)
% PRINTMATRIX prints to the screen a nice easy to read printout of the matrix D
% that can be copied and pasted into other applications (e.g. Excel).
%
% PRINTMATRIX(D); prints out the contents of D with 3 decimal places
%
% PRINTMATRIX(D,DEC); prints out the contents of D with DEC decimal places
%
%
% Written by Stephan W. Wegerich, SmartSignal Corp. August, 2001.
%
% if(nargin==1),dec=3;end


% [n,m]=size(sbeNode);
% for k=1:m
% fprintf(['%s\t'],char(sbeNode(n)));
% end
% fprintf('\n');

if(nargin<3),dec=3;end
if(nargin<2),sbeNode=strread(num2str(1:size(D,1)),'%s'); end

if(any(~isreal(D(:)))), error('Input Must be Real'); end

if(any(isnan(D(:))))
	disp('Raw output shown because NaN in result.');
	disp(' ');
	disp(D);
	return;
end

[N,M]=size(D);

D2=D; D2(D2==inf)=[];
ff=ceil(log10(max(max(abs(D2)))))+dec+3;
fprintf('\n');

symmetry='nodiag';

	if ~(N==M)
		symmetry='yes';
	end
	
%symmetry='yes';
switch (symmetry)
    case ('yes')
	for i=1:N,
	    %name=char(sbeNode(i));
        name=sbeNode{i};
	    [x,len]=size(name);
		   if (len>10) 
			len=10;
			name = char(name(1:len));
		   elseif (len<10)
			name(len+1:10)=' ';	
		   end
	    fprintf(['%s '],name);


	    if (dec==0)
		fprintf(['%#',num2str(ff),'d '],D(i,:));
	    else
		fprintf(['%#',num2str(ff),'.',num2str(dec),'f '],D(i,:));
	    end	   
	    fprintf('\n');
	end
     case ('no')
	for i=1:N,
	    name=sbeNode{i};
	    [x,len]=size(name);
		   if (len>10)
			len=10;
			name = char(name(1:len));
		   elseif (len<10)
			name(len+1:10)=' ';
		   end
	    fprintf(['%s '],name);
	    if (i<=M)
		for j=1:i,
		    if (dec==0)
			fprintf(['%#',num2str(ff),'d '],D(i,j));
		    else
			fprintf(['%#',num2str(ff),'.',num2str(dec),'f '],D(i,j));
		    end
		end
	    end
        fprintf('\n');
	end

    case ('nodiag')
	for i=1:N,
	    name=sbeNode{i};
	    [x,len]=size(name);
		   if (len>10)
			len=10;
			name = char(name(1:len));
		   elseif (len<10)
			name(len+1:10)=' ';
		   end
	    fprintf(['%s '],name);

    if (i<=M)
	for j=1:i,
	if ~(i==j)
	    if (dec==0)
		fprintf(['%#',num2str(ff),'d '],D(i,j));
	    else
		fprintf(['%#',num2str(ff),'.',num2str(dec),'f '],D(i,j));
	    end
	end	
	end
      end
	    fprintf('\n');
    end
end