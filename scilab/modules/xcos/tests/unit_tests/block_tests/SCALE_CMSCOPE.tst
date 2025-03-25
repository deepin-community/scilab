// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes - Clément DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- ENGLISH IMPOSED -->
// <-- XCOS TEST -->
// <-- NO CHECK REF -->
//
// <-- Unit test for SCALE_CSOPE -->
//
// <-- Short Description -->
// This scope autocompute multiple visible bounds
//

scs_m = scicos_diagram();

blk1 = RAMP("define");
blk1.graphics.exprs = ["0.1", "2", "-10"];
blk2 = RAMP("define");
blk2.graphics.exprs = ["-0.1", "1", "10"];
blk3 = SCALE_CMSCOPE("define");
blk4 = CLOCK_c("define");

blk5 = CLINDUMMY_f("define");

lnk1 = scicos_link(from=[1 1 0], to=[3 1 1]);
lnk2 = scicos_link(from=[2 1 0], to=[3 2 1]);
lnk3 = scicos_link(from=[4 1 0], to=[3 1 1], ct=[1,-1]);

scs_m.objs = list(blk1, blk2, blk3, blk4, blk5, lnk1, lnk2, lnk3);
scicos_simulate(scs_m);
