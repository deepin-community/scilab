// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - 3DS - Adeline CARNIS adeline.carnis@3ds.com
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for detectImportOptions function
// =============================================================================

path = fullfile(SCI,"modules", "spreadsheet", "tests", "unit_tests");

opts = detectImportOptions(fullfile(path, "K_1.csv"));
assert_checkequal(opts.variableNames, []);
assert_checkequal(opts.delimiter, ",");
assert_checkequal(opts.decimal, ".");

opts = detectImportOptions(fullfile(path, "K_2.csv"));
assert_checkequal(opts.variableNames, []);
assert_checkequal(opts.delimiter, ascii(9));
assert_checkequal(opts.decimal, ".");

opts = detectImportOptions(fullfile(path, "K_3.csv"), "Delimiter", " ");
assert_checkequal(opts.variableNames, []);
assert_checkequal(opts.delimiter, " ");
assert_checkequal(opts.decimal, ",");

opts = detectImportOptions(fullfile(path, "K_4.csv"));
assert_checkequal(opts.variableNames, []);
assert_checkequal(opts.delimiter, ";");
assert_checkequal(opts.decimal, ",");

opts = detectImportOptions(fullfile(path, "t1.csv"));
assert_checkequal(opts.variableNames, ["val", "time", "a", "b"]);
assert_checkequal(opts.variableTypes, ["double", "datetime", "double", "string"]);
assert_checkequal(opts.delimiter, ",");
assert_checkequal(opts.decimal, ".");
assert_checkequal(opts.inputFormat, ["", "yyyy-MM-dd HH:mm:ss", "", ""]);

ts = readtimeseries(fullfile(path, "t1.csv"), opts);
assert_checkequal(ts.Properties.VariableNames, ["time", "val", "a", "b"]);
expected = [string(datetime(2021, 11, 12, 1:4, 0, 0)'), string([zeros(4,1), [20; 24; 21; 24]]), ["on"; "on"; "off"; "on"]];
assert_checkequal(string(ts), expected);