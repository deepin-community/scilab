% Test file for function axis()
% Copyright INRIA
% Matlab version: 6.5.1.199709 (R13) Service Pack 1
% V.C.
% Copyright 2020 - Samuel GOUGEON

xmin=1;ymin=1;zmin=1;cmin=1;
xmax=10;ymax=10;zmax=10;cmax=10;

axis([xmin xmax ymin ymax])
axis([xmin xmax ymin ymax zmin zmax])
axis([xmin xmax ymin ymax zmin zmax cmin cmax])
v = axis;

axis auto
axis manual
axis tight
axis fill

axis ij
axis xy

axis equal
axis image
axis square
axis vis3d
axis normal

axis off
axis on

%m2scideclare h1|1 1|Handle
%m2scideclare h2|1 1|Handle

axis(h1,'equal')
axis(h1,'ij')
axis(h1,'xy')
axis([h1 h2],'auto')
axis([h1 h2],'ij','xy')
[mode,visibility,direction] = axis('state')

axis auto square tight
axis(h2,'manual',[xmin xmax ymin ymax])
