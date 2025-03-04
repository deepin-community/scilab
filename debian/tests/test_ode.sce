// ---------- Simple one dimension ODE (C coded external)
ccode=['#include <math.h>'
       'void myode(int *n,double *t,double *y,double *ydot)'
       '{'
       '  ydot[0]=y[0]*y[0]-y[0]*sin(*t)+cos(*t);'
       '}']
mputl(ccode,TMPDIR+'/myode.c') //create the C file
// Compile
WORKDIR=pwd()
cd TMPDIR
ilib_for_link('myode','myode.c',[],'c',[],'loader.sce');
exec('loader.sce') //incremental linking
y0=0;
t0=0;
t=0:0.1:%pi;
y = ode(y0,t0,t,'myode');
disp(WORKDIR)
cd(WORKDIR)
print("ode_solution.txt", y(17))
