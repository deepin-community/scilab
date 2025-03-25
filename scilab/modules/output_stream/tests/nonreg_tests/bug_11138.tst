// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2012 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 11138 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/11138
//
// <-- Short Description -->
//  a = list() crashed on Windows x64.
//

a = list()

assert_checkequal(isempty(a), %T);