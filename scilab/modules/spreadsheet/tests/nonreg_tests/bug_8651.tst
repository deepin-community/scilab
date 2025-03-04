//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2012 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
//
// <-- Non-regression test for bug 8651 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/8651
//
// <-- Short Description -->
// The error message of write_csv was wrong.
//

a = ones(5,7);
filename = fullfile(TMPDIR, "foo.txt");
msgerr = msprintf(gettext("%s: Wrong value for input argument #%d: ''%s'' or ''%s'' expected.\n"), "write_csv", 4, ".", ",");
assert_checkerror ("write_csv(a,filename, "";"", ""@"");" , msgerr);
