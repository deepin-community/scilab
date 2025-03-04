// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 2649 -->
//

// <-- Short Description -->
// diary() function cannot be nested.
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/2649
//

dia0 = diary(TMPDIR+'/my_log_1');
a = 1;
dia1 = diary(TMPDIR+'/my_log_2');
b = 1;
diary(dia0, 'close');
diary(dia1, 'close');

ret = mgetl(TMPDIR+'/my_log_1')
ret = mgetl(TMPDIR+'/my_log_2')

