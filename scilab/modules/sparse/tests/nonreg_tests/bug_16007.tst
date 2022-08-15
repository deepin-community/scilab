// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - Stéphane Mottelet
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 16007 -->
//
// <-- Bugzilla URL -->
// http://bugzilla.scilab.org/show_bug.cgi?id=16007
//
// <-- Short Description -->
// non-integer index in sparse makes Scilab crash

A=sparse([1 1.5], 1);
assert_checkerror("sparse([1 0.5], 1)",sprintf(_("%s: Invalid index.\n"),"sparse"));