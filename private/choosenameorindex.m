function [D]=choosenameorindex(aln)
%Display a quest dialog for choosing a genetic distance

% Molecular Biology & Evolution Toolbox, (C) 2004,


if (isempty(aln))
	error('Need aln.');
end

switch (aln.seqtype)
    case (3)
	ButtonName=questdlg('What genetic distance do you want to use?', ...
			    'Select genetic distance model', ...
			    'DayHoff','JTT','WAG','JTT');
	switch ButtonName,
	    case 'DayHoff', 
	      disp('We''re using DayHoff distance.');
	      D=dp_dayhoff(aln);
	     case 'JTT',
	      disp('We''re using JTT distance.')
	      D=dp_jtt(aln);
	     case 'WAG',
	      disp('We''re using WAG distance.');
	      D=dp_wag(aln);
	      otherwise
	      D=[];
	end
    otherwise
	ButtonName=questdlg('What genetic distance do you want to use?', ...
			    'Select genetic distance model', ...
			    'LogDet','JC69','Kimura80','LogDet');
	switch ButtonName,
	    case 'LogDet', 
	      disp('We''re using LogDet (Lake''s) distance.');
	      D=dn_logdet(aln);
	     case 'JC69',
	      disp('We''re using Jukes & Cantor (1969) distance.')
	      D=dn_jc(aln,1.0);
	     case 'Kimura80',
	      disp('We''re using Kimura 80 (2-Parameter) distance.');
	      D=dn_k2p(aln,1.0);
	      otherwise
	      D=[];
	end
end
