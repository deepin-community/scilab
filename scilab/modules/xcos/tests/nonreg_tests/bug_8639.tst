// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - DIGITEO - Clément DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- INTERACTIVE TEST -->
// <-- XCOS TEST -->
//
// <-- Non-regression test for bug 8639 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/8639
//
// <-- Short Description -->
// Xcos simulation were not halted at the end of a session

xcos(SCI + "/modules/xcos/demos/bounce.zcos")
// Start the simulation
// close Xcos
// --> the simulation must stop
// close Scilab
// --> all the windows should be closed


