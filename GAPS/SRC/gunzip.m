function newnamefile=gunzip(namefile,path,pathexe)
%
% Function gunzip
%
%   Uncompress files

%Get Location of Executable
tempz = fullfile(path,'rodrigo.z');
tempgz = fullfile(path,'rodrigo.gz');

if strcmpi(namefile(end-1:end),'.z');
    copyfile(namefile,tempz,'f');
    if ispc()
        system([fullfile(pathexe,gunzip.exe) tempz]);
    else
        system(['gunzip ' tempz]);
    end
elseif strcmpi(namefile(end-1:end),'gz');
    copyfile(namefile,tempgz,'f');
    if ispc()
        system([fullfile(pathexe,gunzip.exe) tempgz]);
    else
        system(['gunzip ' tempgz]);
    end
else
    error('Incorrect compression. Must be in .Z or .gz format.');
end



np=4;
if namefile(end-1) == '.'
    np=2;
elseif namefile(end-2) == '.'
    np=3;
else
    error('Incorrect compression. Must be in .Z or .gz format.');
end

newnamefile=[namefile(1:end-np)];
copyfile(fullfile(path,'rodrigo'),newnamefile,'f');
delete(fullfile(path,'rodrigo'));
