// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2006-2008 - INRIA - Serge STEER <serge.steer@inria.fr>
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 1802 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/1802
//
// <-- Short Description -->
//    The sci2exp function is very very slow for large matrices

a=rand(100,500);
timer();sci2exp(a);t=timer();
if t>60 then pause,end
