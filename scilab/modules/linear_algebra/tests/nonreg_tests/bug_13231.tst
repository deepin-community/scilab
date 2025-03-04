// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 13231 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/13231
//
// <-- Short Description -->
// spec() yielded a segfault


n = 2000;
A = rand(n,n);
assert_checkequal(execstr("d = spec(A);", "errcatch"), 0);
assert_checkequal(execstr("[X,D] = spec(A);", "errcatch"), 0);
