// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - 3DS - Adeline CARNIS adeline.carnis@3ds.com
// Copyright (C) 2023 - 3DS - Antoine ELIAS antoine.elias@3ds.com
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for varfun function
// =============================================================================

rand("seed", 0)
x1 = floor(rand(5,1)*5)-1.5;
x2 = -floor(rand(5,1)*5)+0.5;
A = table(x1, x2);

function y = f(x)
    y = abs(x)
endfunction

V = varfun(f, A);
assert_checkequal(V.fun_Var1, abs(x1));
assert_checkequal(V.fun_Var2, abs(x2));

V = varfun(sum, A);
assert_checkequal(V.Variables, [sum(x1), sum(x2)]);

V = varfun(max, A);
assert_checkequal(V.Variables, [max(x1), max(x2)]);

// With InputVariables
V = varfun(f, A, "InputVariables", "Var2");
assert_checkequal(V.Properties.VariableNames, "fun_Var2");
assert_checkequal(V.fun_Var2, abs(x2));

V = varfun(sum, A, "InputVariables", "Var2");
assert_checkequal(V.Variables, sum(x2));

V = varfun(max, A, "InputVariables", "Var1");
assert_checkequal(V.Variables, max(x1));

// With GroupingVariables
A = table(["a"; "b"; "b"; "c"; "a"], x1, x2);
V = varfun(sum, A, "GroupingVariables", "Var1");
expected = ["a" "2" "1" "-2"; "b" "2" "0" "-6"; "c" "1" "-0.5" "-3.5"];
assert_checkequal(V.Properties.VariableNames, ["Var1", "GroupCount", "fun_Var2", "fun_Var3"]);
assert_checkequal(string(V), expected);



timestamp = hours([1 3 2 2 3])';
A = timeseries(timestamp, x1, x2, "VariableNames", ["hours", "x1", "x2"]);
V = varfun(sum, A);
expected = ["01:00:00" "0.5" "-11.5"];
assert_checkequal(V.Properties.VariableNames, ["hours", "fun_" + ["x1", "x2"]]);
assert_checkequal(string(V), expected);

V = varfun(sum, A, "GroupingVariables", "hours");
expected = [string(hours(1:3))' string([1;2;2]), string([-0.5;-2; 3]), string([-2.5; -6; -3])];
assert_checkequal(V.Properties.VariableNames, ["hours", "GroupCount", "fun_x1", "fun_x2"]);
assert_checkequal(string(V), expected);


// -----------------------------------------------------------------------------
// Data from www.historique-meteo.net
T = readtable(fullfile(SCI, "modules", "spreadsheet", "tests", "unit_tests","meteo_data_bordeaux.csv"));

V = varfun(max, T, "GroupingVariables", "OPINION", "InputVariables", "MAX_TEMPERATURE_C");
expected = ["météo correcte" "7" "25"; ...
            "météo défavorable" "3" "26"; ...
            "météo favorable" "10" "31"; ...
            "météo idéale" "10" "31"];
assert_checkequal(V.Properties.VariableNames, ["OPINION" "GroupCount", "fun_MAX_TEMPERATURE_C"]);
assert_checkequal(string(V), expected);

V = varfun(mean, T, "GroupingVariables", "OPINION", "InputVariables", ["MAX_TEMPERATURE_C", "MIN_TEMPERATURE_C", "SUNHOUR"]);
expected = ["météo correcte" "7" "23" "17.714286" "12.371429"; ...
            "météo défavorable" "3" "23" "17.333333" "10.233333"; ...
            "météo favorable" "10" "25.6" "17.5" "13.3"; ...
            "météo idéale" "10" "26.7" "17.8" "14.2"];
assert_checkequal(V.Properties.VariableNames, ["OPINION" "GroupCount", "fun_MAX_TEMPERATURE_C", "fun_MIN_TEMPERATURE_C", "fun_SUNHOUR"]);
assert_checkequal(string(V), expected);
