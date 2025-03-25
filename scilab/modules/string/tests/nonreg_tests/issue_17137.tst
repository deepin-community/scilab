// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - 3DS - Antoine ELIAS
//
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 17137 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17137
//
// <-- Short Description -->
// "strsubst" crashes trying to replace non existent group ("$")
// -------------------------------------------------------------
assert_checkequal(strsubst(" $,", "/,/", "", "r"), " $");
// Test with strsplit
assert_checkequal(strsplit("$;$", ";"), ["$";"$"]);