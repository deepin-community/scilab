// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - 3DS - Adeline CARNIS adeline.carnis@3ds.com
// Copyright (C) 2023 - 3DS - Antoine ELIAS antoine.elias@3ds.com
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for readtable/writetable function
// =============================================================================

t = readtable(fullfile(SCI, "modules", "spreadsheet", "tests", "unit_tests", "results_without_time.csv"));
assert_checkequal(size(t), [3 3]);
assert_checkequal(t.Properties.VariableNames, ["a", "b", "c"]);
assert_checkequal(t.a, ones(3, 1));
assert_checkequal(t.b, 0.42 * ones(3, 1));
assert_checkequal(t.c, "version" + emptystr(3, 1));

writetable(t, fullfile(TMPDIR, "test.csv"));
t1 = readtable(fullfile(TMPDIR, "test.csv"));
assert_checktrue(t1.vars == t.vars);

writetable(t, fullfile(TMPDIR, "test.csv"), "Delimiter", ";");
t1 = readtable(fullfile(TMPDIR, "test.csv"));
assert_checktrue(t1.vars == t.vars);

Names = ["toto", "titi", "tutu"]';
t.Row = Names

writetable(t, fullfile(TMPDIR, "test.csv"), "WriteRowNames", %t);
t1 = readtable(fullfile(TMPDIR, "test.csv"), "ReadRowNames", %t);
assert_checktrue(t1.vars == t.vars);
assert_checktrue(t1.Row == t.Row);
