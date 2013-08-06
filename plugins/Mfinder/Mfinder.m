function outputCell = Mfinder(varargin)
% - Mfinder 
% It is a software tool for network motifs detection. It calls the
% executables compiled from the source provided by the authors.
%
% Ref: Kashtan N., Itzkovitz S., Milo R., Alon U. Mfinder tool guide. 2002. 
%      Technical report, Department of Molecular Cell Biology and Computer 
%      Science and Applied Mathematics, Weizman Institute of Science, Israel.
%
%
% output = Mfinder(s, r, p)
% s - Motif Size
% r - Number of Random Networks to Generate
% p - Number of Samples
%
%
% Plugin Author:
% --------------
%
% Kranti Konganti
% Whole Systems Genomics Initiative ( WSGI ) ,
% Texas A&M University
%
%


%% Test and load either largest extracted network or original network
[g, e] = getcurrentnetsession;

%% If network is not yet loaded, return
if isempty(g)
    outputCell{1} = sprintf('\n%s\n%s\n%s\n\n%s', 'mfinder Output', ...
        '=======================================', ...
        'Network not yet loaded !', ...
        'Aborting plugin execution ...');
    return;
end


%% Define addin path.
%[~, plugins_dir] = get_plugins_dir;
mfinderPath = ['"', fileparts(which(mfilename)), filesep];

%% Mfinder needs tab-delimited output.
tmpInputFile = tempname;
tmpInputFileMembers = [tmpInputFile, '_MEMBERS.txt'];
tmpInputFileOutput = [tmpInputFile, '_OUT.txt'];
tmpInputFile = [tmpInputFile, '.txt'];

waitForMfinder = waitbar(0, 'Please wait... Formatting input for Mfinder...');
waitbar(0.25, waitForMfinder);
writesbe2tab(g, e, 'motifformat', tmpInputFile);

%% Test the arch to call correct Mfinder executable.
waitbar(0.5, waitForMfinder, 'Please wait... Choosing appropriate executable for system architecture...');
if isunix
    [~, arch] = system('uname -a');
    if ~isempty(regexpi(arch, '^darwin.+?x86\_64.*', 'match'))
        mfinderExe = [mfinderPath, 'mfinder-maci64'];
    elseif ~isempty(regexpi(arch, '^darwin.+?i686.*', 'match'))
        errordlg('Mfinder works best on Mac OSX with Intel 64-bit architechture only...');
        outputCell{1} = sprintf('%s', 'Error !');
        return;
    elseif ~isempty(regexpi(arch, '^linux.+?x86\_64.*', 'match'))
        mfinderExe = [mfinderPath, 'mfinder-linux64'];
    elseif ~isempty(regexpi(arch, '^linux.+?i686.*', 'match'))
        errordlg('Mfinder works best on Linux with 64-bit architechture only...');
        outputCell{1} = sprintf('%s', 'Error !');
        return;
    end
elseif ispc
    mfinderExe = [mfinderPath, 'mfinder-win32.exe'];
end

%% Get options and execute Mfinder;
waitbar(0.75, waitForMfinder, 'Waiting for User inputs...');
if nargin == 0
    prompt = {'Motif Size ( s ):', ...
        'Number of Random Networks to Generate ( r ):', ...
        'Number of Samples ( p ):'};
    
    dlgTitle = 'Apply Mfinder Algorithm';
    num_lines = 1;
    answer = inputdlg(prompt, dlgTitle, ...
        [num_lines, 50; num_lines, 50; num_lines, 50], {'3', '0', '0'});
    
    if ~isempty(answer)
        s = str2double(answer{1});
        r = str2double(answer{2});
        p = str2double(answer{3});
    else
        outputCell{1} = sprintf('%s', 'Mfinder - Selection Incomplete !');
        closeMfinderWaitbar(waitForMfinder);
        return;
    end
elseif nargin == 3
    s = varargin{1};
    r = varargin{2};
    p = varargin{3};
else
    errordlg('Invalid Number of arguments');
    outputCell{1} = sprintf('%s', 'Mfinder Error !');
    return;
end

if mod(s, 1) ~= 0 || mod(r, 1) ~= 0 || mod(p, 1) ~= 0
    errordlg('Option Values must be 0 or positive integer !');
    outputCell{1} = sprintf('%s', 'Mfinder Error !');
    return;
end

cmdCall = [mfinderExe, '"', ' ', tmpInputFile, ' -omem -nd '];

if s > 0
    cmdCall = [cmdCall, ' -s ', num2str(s)];
end
if r > 0
    cmdCall = [cmdCall, ' -r ', num2str(r)];
end
if p > 0
    cmdCall = [cmdCall, ' -p ', num2str(p)];
end

waitbar(0.9, waitForMfinder, 'Executing Mfinder...');

%disp(cmdCall);

[MfinderStatus, cmdCallRes] = system(cmdCall);

if MfinderStatus == 0
    MfinderOutFID = fopen(tmpInputFileOutput, 'r');
    MfinderMembersFID = fopen(tmpInputFileMembers, 'r');
else
    errordlg('Mfinder execution failed...');
    outputCell{1} = sprintf('%s', cmdCallRes);
    closeMfinderWaitbar(waitForMfinder);
    return;
end
   

%% Cannot define the size, so no other choice !!!

if isempty(e)
    outputCell{1} = sprintf('\n%s\n', 'Network not yet loaded !');
end

% Output header
outputHeaderTitle = 'Mfinder Output';
outputCell{1} = sprintf('\n%s\n%s', outputHeaderTitle, ...
    '================================================');

MfinderOutput = fgetl(MfinderOutFID);

while ischar(MfinderOutput)
    MfinderOutput = regexprep(MfinderOutput, '^\s+', '');
    outputCell{end + 1} = sprintf('%s', MfinderOutput);
    MfinderOutput = fgetl(MfinderOutFID);
end

MfinderMembersOutput = fgetl(MfinderMembersFID);

while ischar(MfinderMembersOutput)
    nodeMembers = strsplit(char(MfinderMembersOutput), '\t');
    if size(nodeMembers, 2) > s
        nodeMembersOutput = '';
        for i =  1:s
            nodeMembersOutput = [nodeMembersOutput, char(9), ...
                e{str2double(nodeMembers(i))}];
        end
        outputCell{end + 1} = sprintf('%s', nodeMembersOutput);
    else
        outputCell{end + 1} = sprintf('%s', MfinderMembersOutput);
    end
    MfinderMembersOutput = fgetl(MfinderMembersFID);
end

closeMfinderWaitbar(waitForMfinder);

%% Mfinder completed
    function closeMfinderWaitbar(waitH)
        waitbar(1, waitH);
        close(waitH);
    end

fclose(MfinderOutFID);
fclose(MfinderMembersFID);

if exist(tmpInputFile, 'file'); delete(tmpInputFile); end;
if exist(tmpInputFileMembers, 'file'); delete(tmpInputFileMembers); end;
if exist(tmpInputFileOutput, 'file'); delete(tmpInputFileOutput); end;

end
