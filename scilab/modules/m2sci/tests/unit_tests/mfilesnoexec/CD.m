% Test file for function cd()
% Copyright INRIA
% Matlab version: 6.5.0.180913a (R13)
% V.C.

dirName = '~'
cd(dirName)
cd ~
cd ..
cd dirname
cd 'dirname'
cd('dirname')
cd
wd=cd
