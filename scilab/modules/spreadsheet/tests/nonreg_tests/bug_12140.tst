// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2012 - Scilab Enterprises - Sylvestre Ledru
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// 
// <-- CLI SHELL MODE -->
//
// <-- Non-regression test for bug 12140 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/12140
//
// <-- Short Description -->
// csvRead fails when comma is used as decimal mark
//
filename=SCI+"/modules/spreadsheet/" + "tests/nonreg_tests/bug_12140.csv";

[Mss, comments] = csvRead(filename, ";" , "," , "double" , [] ,"/foo bar/");
assert_checkfalse(Mss(1,2) == %nan);
assert_checkfalse(Mss(1,3) == %nan);
Mss_ref=[280,4.730900000000000068D-23, 2.869819999999999938D-23];

assert_checkalmostequal(Mss(1,:), Mss_ref);
Mss=mgetl(filename);
M=csvTextScan(Mss(2:$,:),";",",");
assert_checkalmostequal(M, Mss_ref);

[Mss, comments] = csvRead(filename, ";" , "," , "string" , [] ,"/foo bar/");
assert_checkequal(Mss,["280","4.7309E-23","2.86982E-23"]);

[Mss, comments] = csvRead(filename, ";" , [] , "string" , [] ,"/foo bar/");
assert_checkequal(Mss,["280","4,7309E-23","2,86982E-23"]);
