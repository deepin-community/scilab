// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - 3DS - Adeline CARNIS adeline.carnis@3ds.com
// Copyright (C) 2022 - 3DS - Antoine ELIAS antoine.elias@3ds.com
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for duration
// =============================================================================

function checkduration(d, v)
    assert_checkequal(d.duration, v);
endfunction

function checkstring(d, v)
    assert_checkequal(%duration_string(d), v);
endfunction

checkduration(duration([]), []);
checkduration(duration(0), 0);
checkduration(duration(1), 3600000);
checkduration(duration(0, 0, 0), 0);
checkduration(duration(0, 0, 1), 1000);

checkstring(duration(1, 1, 1), "01:01:01");
checkstring(duration(0, 0, 60), "00:01:00");
checkstring(duration(0, 60, 00), "01:00:00");
checkstring(duration(60, 0, 00), "60:00:00");

checkstring(duration(12, 30, 45), "12:30:45");
checkstring(duration([12 30 45]), "12:30:45");
checkstring(duration("12:30:45"), "12:30:45");
checkstring(duration(12, 30, 45, 250), "12:30:45.250");
checkstring(duration([12 30 45 250]), "12:30:45.250");
checkstring(duration("12:30:45.250"), "12:30:45.250");

h = [3 5];
checkstring(duration(h, 17, 58), ["03:17:58" "05:17:58"]);
checkstring(duration(h, 17, 58, 600), ["03:17:58.600" "05:17:58.600"]);
checkstring(duration(h', 17, 58), ["03:17:58"; "05:17:58"]);
checkstring(duration(h', 17, 58, 600), ["03:17:58.600"; "05:17:58.600"]);
assert_checkequal(duration(h, 0, 0), hours(h));
assert_checkequal(duration(h', 0, 0), hours(h'));

h = [3 4; 5 6];
checkstring(duration(h, 17, 58), ["03:17:58" "04:17:58";"05:17:58" "06:17:58"]);
checkstring(duration(h, 17, 58, 600), ["03:17:58.600" "04:17:58.600"; "05:17:58.600" "06:17:58.600"]);
assert_checkequal(duration(h, 0, 0), hours(h));

mm = [12 24];
checkstring(duration(13, mm, 04), ["13:12:04" "13:24:04"]);
checkstring(duration(13, mm, 04, 600), ["13:12:04.600" "13:24:04.600"]);
checkstring(duration(13, mm', 04), ["13:12:04"; "13:24:04"]);
checkstring(duration(13, mm', 04, 600), ["13:12:04.600"; "13:24:04.600"]);
assert_checkequal(duration(0, mm, 0), minutes(mm));
assert_checkequal(duration(0, mm', 0), minutes(mm'));

mm = [12 24;35 47];
checkstring(duration(13, mm, 04), ["13:12:04" "13:24:04"; "13:35:04" "13:47:04"]);
checkstring(duration(13, mm, 04, 600), ["13:12:04.600" "13:24:04.600"; "13:35:04.600" "13:47:04.600"]);
assert_checkequal(duration(0, mm, 0), minutes(mm));

sec = [23 47];
checkstring(duration(13, 35, sec), ["13:35:23" "13:35:47"]);
checkstring(duration(13, 35, sec, 10), ["13:35:23.010" "13:35:47.010"]);
checkstring(duration(13, 35, sec'), ["13:35:23"; "13:35:47"]);
checkstring(duration(13, 35, sec', 10), ["13:35:23.010"; "13:35:47.010"]);
assert_checkequal(duration(0, 0, sec), seconds(sec));
assert_checkequal(duration(0, 0, sec'), seconds(sec'));

sec = [11 23; 47 52];
checkstring(duration(13, 35, sec), ["13:35:11" "13:35:23"; "13:35:47" "13:35:52"]);
checkstring(duration(13, 35, sec, 10), ["13:35:11.010" "13:35:23.010"; "13:35:47.010" "13:35:52.010"]);
assert_checkequal(duration(0, 0, sec), seconds(sec));

milli = [7 125];
checkstring(duration(13, 35, 23, milli), ["13:35:23.007" "13:35:23.125"]);
checkstring(duration(13, 35, 23, milli'), ["13:35:23.007"; "13:35:23.125"]);
assert_checkequal(duration(0, 0, 0, milli), milliseconds(milli));
assert_checkequal(duration(0, 0, 0, milli'), milliseconds(milli'));

checkstring(duration(h, mm, 04), ["03:12:04" "04:24:04"; "05:35:04" "06:47:04"]);
checkstring(duration(h, mm, 04, 600), ["03:12:04.600" "04:24:04.600"; "05:35:04.600" "06:47:04.600"]);
checkstring(duration(h, mm, sec), ["03:12:11" "04:24:23"; "05:35:47" "06:47:52"]);
checkstring(duration(h, mm, sec, 600), ["03:12:11.600" "04:24:23.600"; "05:35:47.600" "06:47:52.600"]);
assert_checkequal(duration(h, mm, 0), hours(h) + minutes(mm));
assert_checkequal(duration(h, mm, sec), hours(h) + minutes(mm) + seconds(sec));

h = [3 5];
mm = [12 24];
sec = [23 47];
checkstring(duration(h, mm, 04), ["03:12:04" "05:24:04"]);
checkstring(duration(h, mm, 04, 600), ["03:12:04.600" "05:24:04.600"]);
checkstring(duration(h, mm, sec), ["03:12:23" "05:24:47"]);
checkstring(duration(h, mm, sec, 600), ["03:12:23.600" "05:24:47.600"]);
checkstring(duration(h', mm', 04), ["03:12:04"; "05:24:04"]);
checkstring(duration(h', mm', 04, 600), ["03:12:04.600"; "05:24:04.600"]);
checkstring(duration(h', mm', sec'), ["03:12:23"; "05:24:47"]);
checkstring(duration(h', mm', sec', 600), ["03:12:23.600"; "05:24:47.600"]);

checkstring(duration(h, mm, sec, milli), ["03:12:23.007" "05:24:47.125"]);
checkstring(duration(h', mm', sec', milli'), ["03:12:23.007"; "05:24:47.125"]);
assert_checkequal(duration(h, mm, sec, milli), hours(h) + minutes(mm) + seconds(sec) + milliseconds(milli));
assert_checkequal(duration(h', mm', sec', milli'), hours(h') + minutes(mm') + seconds(sec') + milliseconds(milli'));

x = rand(4, 3)*10;
assert_checkequal(duration(x), duration(x(:, 1), x(:, 2), x(:, 3)));


// check overload
D = duration(1, 0, 0);
checkduration(D + hours(1:3), [2:4] * 3600 * 1000);
checkduration(hours(1:3) + D, [2:4] * 3600 * 1000);
checkduration(D + [1:3], [2:4] * 3600 * 1000);
checkduration([1:3] + D, [2:4] * 3600 * 1000);

D = duration(4, 0, 0);
checkduration(D - hours(1:3), [3:-1:1] * 3600 * 1000);
checkduration(D - [1:3], [3:-1:1] * 3600 * 1000);

checkduration(D * 2, 2 * 4 * 3600 * 1000);
checkduration(2 * D, 2 * 4 * 3600 * 1000);
checkduration(D * [2 4;3 5], [2 4;3 5] * 4 * 3600 * 1000);
checkduration([2 4;3 5] * D, [2 4;3 5] * 4 * 3600 * 1000);
//checkduration(duration([1 2], 0, 0) * [2 4], [2 4] .* [1 2] * 3600 * 1000);
//checkduration([2 4] * duration([1 2], 0, 0), [2 4] .* [1 2] * 3600 * 1000);

assert_checkequal(duration(1:3, 0, 0) / duration(1:3, 0, 0),  ones(1,3));
checkduration(duration(1:3, 0, 0) / [1:3],  ones(1,3) * 3600 * 1000);
assert_checkequal(round(duration(12, 30, 15) / duration(6, 30, 15)), 2);
assert_checkequal(round(duration([18 12;24 6], 30, 15) / duration(6, 30, 15)), [3 2;4 1]);
checkduration(duration(12, 0, 0) / 6, 2 * 3600 * 1000);
checkduration(duration([18 12;24 6], 0, 0) / 6, [3 2;4 1] * 3600 * 1000);

assert_checktrue(duration(12, 30, 15) == hours(12) + minutes(30) + seconds(15));
assert_checktrue(duration(1, 0, 0) == 1);
assert_checktrue(1 == duration(1, 0, 0));
assert_checktrue(duration([1 2;3 4], 0, 0) == [1 2;3 4]);
assert_checktrue([1 2;3 4] == duration([1 2;3 4], 0, 0));

assert_checktrue(duration(1, 0, 0) <> hours(2));
assert_checktrue(duration(1, 0, 0) <> 2);
assert_checktrue(2 <> duration(1, 0, 0));
assert_checktrue(duration([1 2; 3 4], 0, 0) <> [2 5; 1 3]);
assert_checktrue([2 5; 1 3] <> duration([1 2; 3 4], 0, 0));

A = duration([6 30 30; 4 15 0]);
B = duration([6 45 0; 3 50 0]);
assert_checkequal(A > B, [%f; %t]);
assert_checktrue(A > [5; 1]);
assert_checktrue([7; 5] > A);

assert_checkequal(A >= B, [%f; %t]);
assert_checktrue(A >= [5; 1]);
assert_checktrue([7 5] >= duration([7 5], 0, 0));

assert_checkequal(A < B, [%t; %f]);
assert_checktrue(A < [7; 5]);
assert_checktrue([5 1] < duration([6 2], 0, 0));

assert_checkequal(A <= B, [%t; %f]);
assert_checktrue(A <= [7; 5]);
assert_checktrue([6 2] <= duration([6 2], 0, 0));

checkduration(duration(0,0,0):duration(0,0,10), [0:10] * 1000);
checkduration(duration(0,0,0):seconds(2):duration(0,0,10), [0:2:10] * 1000);
checkduration(duration(0,0,0):minutes(2):duration(0,10,0), [0:2:10] * 60 * 1000);
checkduration(duration(0,0,0):hours(2):duration(10,0,0), [0:2:10] * 60 * 60 * 1000);

checkduration([duration(0,0,0); duration(0,0,10)], [0;10] * 1000);
checkduration([duration(0,0,0) duration(0,0,10)], [0 10] * 1000);
checkduration([duration(0,0,[0; 5]); duration(0,0,10)], [0;5;10] * 1000);
checkduration([duration(0,0,[0 5]) duration(0,0,10)], [0 5 10] * 1000);

assert_checkequal([duration([0 1]', 0,0), duration([])], duration([0 1]', 0, 0));
assert_checkequal([duration([0 1], 0,0), duration([])], duration([0 1], 0, 0));

clear c; c(2) = hours(2);
assert_checktrue(c == duration([0;2], 0, 0));

clear c; c(2:3) = hours(2:3);
assert_checktrue(c == duration([0 2 3], 0, 0));

c(:, [2 3 4]) = hours([1 2 3]);
assert_checktrue(c == duration([0 1 2 3], 0, 0));
checkstring(c, ["00:00:00" "01:00:00" "02:00:00" "03:00:00"]);

t = []; t($+1) = seconds(1);
assert_checktrue(t == duration(0, 0, 1));
checkstring(t, "00:00:01");

checkstring(duration(1,0,0, "OutputFormat", "mm:ss"), "60:00");
checkstring(duration(["01:00:00" "02:00:00"; "03:00:00" "04:00:00"], "InputFormat", "hh:mm:ss"), ["01:00:00" "02:00:00"; "03:00:00" "04:00:00"]);
checkstring(duration(["01:00" "02:00"; "03:00" "04:00"], "InputFormat", "hh:mm"), ["01:00:00" "02:00:00"; "03:00:00" "04:00:00"]);
checkstring(duration(["01:00" "02:00"; "03:00" "04:00"], "InputFormat", "mm:ss"), ["00:01:00" "00:02:00"; "00:03:00" "00:04:00"]);
checkstring(duration(["01:00:00:00" "02:00:00:00"; "03:00:00:00" "04:00:00:00"], "InputFormat", "dd:hh:mm:ss"), ["24:00:00" "48:00:00"; "72:00:00" "96:00:00"]);

checkstring(duration(["01:00:00" "02:00:00"; "03:00:00" "04:00:00"], "OutputFormat", "hh:mm:ss"), ["01:00:00" "02:00:00"; "03:00:00" "04:00:00"]);
checkstring(duration(["01:00:00" "02:00:00"; "03:00:00" "04:00:00"], "OutputFormat", "hh:mm"), ["01:00" "02:00"; "03:00" "04:00"]);
checkstring(duration(["01:00:00" "02:00:00"; "03:00:00" "04:00:00"], "OutputFormat", "mm:ss"), ["60:00" "120:00"; "180:00" "240:00"]);
checkstring(duration(["01:00:00" "02:00:00"; "03:00:00" "04:00:00"], "OutputFormat", "dd:hh:mm:ss"), ["00:01:00:00" "00:02:00:00"; "00:03:00:00" "00:04:00:00"]);

checkstring(duration(["01:00:00" "02:00:00"; "03:00:00" "04:00:00"], "InputFormat", "hh:mm:ss", "OutputFormat", "hh:mm"), ["01:00" "02:00"; "03:00" "04:00"]);
checkstring(duration(["01:00:00" "02:00:00"; "03:00:00" "04:00:00"], "InputFormat", "hh:mm:ss", "OutputFormat", "mm:ss"), ["60:00" "120:00"; "180:00" "240:00"]);
checkstring(duration(["01:00" "02:00"; "03:00" "04:00"], "InputFormat", "hh:mm", "OutputFormat", "mm:ss"), ["60:00" "120:00"; "180:00" "240:00"]);

checkstring(duration("70:50", "InputFormat", "mm:ss"), "01:10:50");
checkstring(duration(["2:15" "65:23"], "InputFormat", "mm:ss"), ["00:02:15", "01:05:23"]);
checkstring(duration(["2:15"; "65:23"], "InputFormat", "mm:ss"), ["00:02:15"; "01:05:23"]);

checkstring(duration("70:50.300", "InputFormat", "mm:ss.SSS"), "01:10:50.300");
checkstring(duration(["2:15.300" "65:23.456"], "InputFormat", "mm:ss.SSS"), ["00:02:15.300", "01:05:23.456"]);
checkstring(duration(["2:15.300"; "65:23.456"], "InputFormat", "mm:ss.SSS"), ["00:02:15.300"; "01:05:23.456"]);

checkstring(duration("70:50", "InputFormat", "mm:ss", "OutputFormat", "hh:mm:ss"), "01:10:50");
checkstring(duration(["2:15" "65:23"], "InputFormat", "mm:ss", "OutputFormat", "hh:mm:ss"), ["00:02:15", "01:05:23"]);
checkstring(duration(["2:15"; "65:23"], "InputFormat", "mm:ss", "OutputFormat", "hh:mm:ss"), ["00:02:15"; "01:05:23"]);

checkstring(duration("70:50", "InputFormat", "mm:ss", "OutputFormat", "mm:ss"), "70:50");
checkstring(duration(["2:15" "65:23"], "InputFormat", "mm:ss", "OutputFormat", "mm:ss"), ["02:15", "65:23"]);
checkstring(duration(["2:15"; "65:23"], "InputFormat", "mm:ss", "OutputFormat", "mm:ss"), ["02:15"; "65:23"]);

checkstring(duration("70:50.300", "InputFormat", "mm:ss.SSS", "OutputFormat", "hh:mm:ss.SSS"), "01:10:50.300");
checkstring(duration(["2:15.300" "65:23.456"], "InputFormat", "mm:ss.SSS", "OutputFormat", "hh:mm:ss.SSS"), ["00:02:15.300", "01:05:23.456"]);
checkstring(duration(["2:15.300"; "65:23.456"], "InputFormat", "mm:ss.SSS", "OutputFormat", "hh:mm:ss.SSS"), ["00:02:15.300"; "01:05:23.456"]);

d = duration("01:01:01");
d.format = "h";
checkstring(d, "1.017 h");
d.format = "m";
checkstring(d, "61.017 m");
d.format = "s";
checkstring(d, "3661.000 s");

d = duration(1, 0, 0);
assert_checkequal(d(1):d($), d(1));


// checkerror
msg = msprintf(_("%s: Wrong number of input argument: %d to %d expected, except to %d.\n"), "duration", 1, 8, 2);
assert_checkerror("duration()", msg);
assert_checkerror("duration(1, 1)", msg);
assert_checkerror("duration(1, 1, 1, 1, 1, 1, 1, 1, 1)", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: ""%s"" or ""%s"" expected.\n"), "duration", 2, "InputFormat", "OutputFormat");
assert_checkerror("duration(""12:12:30"", ""toto"", ""hh:mm:ss"")", msg);
msg = msprintf(_("%s: Wrong value for input argument #%d: ""%s"" or ""%s"" expected.\n"), "duration", 4, "InputFormat", "OutputFormat");
assert_checkerror("duration(""12:12:30"", ""InputFormat"", ""hh:mm:ss"", ""toto"", ""hh:mm"")", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: real, string or duration expected.\n"), "duration", 1);
assert_checkerror("duration(%t)", msg);
assert_checkerror("duration(%s)", msg);

msg = msprintf(_("%s: Wrong format for input argument #%d.\n"), "duration", 1);
assert_checkerror("duration("""")", msg);

msg = msprintf(_("%s: Wrong type for input arguments #%d, #%d and #%d: reals expected.\n"), "duration", 1, 2, 3);
assert_checkerror("duration(""toto"", 1, 2)", msg);
assert_checkerror("duration(1, 2, ""toto"")", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: ""%s"" or ""%s"" expected.\n"), "duration", 2, "InputFormat", "OutputFormat");
assert_checkerror("duration(1, ""toto"", 2)", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: string expected.\n"), "duration", 3);
assert_checkerror("duration(1, ""InputFormat"", 2)", msg);
assert_checkerror("duration(1, ""OutputFormat"", 2)", msg);
msg = msprintf(_("%s: Wrong value for ""%s"" argument: {%s, %s, %s, %s} expected.\n"), "duration", "InputFormat", "dd:hh:mm:ss", "hh:mm:ss", "hh:mm", "mm:ss");
assert_checkerror("duration(1, ""InputFormat"", ""toto"")", msg);
assert_checkerror("duration(""01:00"", ""InputFormat"", ""dd:hhmm:ss"")", msg);
msg = msprintf(_("%s: Wrong value for ""%s"" argument: {%s, %s, %s, %s} expected.\n"), "duration", "OutputFormat", "dd:hh:mm:ss", "hh:mm:ss", "hh:mm", "mm:ss");
assert_checkerror("duration(1, ""OutputFormat"", ""toto"")", msg);

msg = msprintf(_("%s: Wrong type for input arguments #%d, #%d, #%d and #%d: reals expected.\n"), "duration", 1, 2, 3, 4);
assert_checkerror("duration(""toto"", 1, 2, 3)", msg);
assert_checkerror("duration(1, ""toto"", 2, 3)", msg);
assert_checkerror("duration(1, 2, 3, ""toto"")", msg);

msg = msprintf(_("%s: Wrong number of input arguments.\n"), "duration");
assert_checkerror("duration(1, 2, 3, 4, ""toto"")", msg);

msg = msprintf(_("%s: Wrong size for input arguments #%d, #%d and #%d: scalar or matrix of same size expected.\n"), "duration", 1, 2, 3);
assert_checkerror("duration(1, [15 20], [15; 30])", msg);
assert_checkerror("duration(1, [15; 20], [15 30])", msg);
assert_checkerror("duration([12 13], 20, [15; 30])", msg);
assert_checkerror("duration([12; 13], 20, [15 30])", msg);
assert_checkerror("duration([12; 13], [20 25], [15 30])", msg);

msg = msprintf(_("%s: Wrong size for input arguments #%d, #%d, #%d and #%d: scalar or matrix of same size expected.\n"), "duration", 1, 2, 3, 4);
assert_checkerror("duration(1, [15 20], [15; 30], 300)", msg);
assert_checkerror("duration(1, [15; 20], [15 30], 300)", msg);
assert_checkerror("duration([12 13], 20, [15; 30], 300)", msg);
assert_checkerror("duration([12; 13], 20, [15 30], 300)", msg);
assert_checkerror("duration([12; 13], [20 25], [15 30], 300)", msg);
assert_checkerror("duration([12; 13], 20, 30, [300 400])", msg);

msg = msprintf(_("%s: Wrong size for input arguments #%d and #%d: scalar or matrix of same size expected.\n"), "%duration_a_duration", 1, 2);
assert_checkerror("duration(1:3, 0, 0) + hours(1:2)", msg);
assert_checkerror("hours(1:2) + duration(1:3, 0, 0)", msg);

msg = msprintf(_("%s: Wrong size for input arguments #%d and #%d: scalar or matrix of same size expected.\n"), "%duration_a_s", 1, 2);
assert_checkerror("duration(1:3, 0, 0) + [1:2]", msg);
msg = msprintf(_("%s: Wrong size for input arguments #%d and #%d: scalar or matrix of same size expected.\n"), "%s_a_duration", 1, 2);
assert_checkerror("[1:2] + duration(1:3, 0, 0)", msg);

msg = msprintf(_("%s: Wrong size for input arguments #%d and #%d: scalar or matrix of same size expected.\n"), "%duration_s_duration", 1, 2);
assert_checkerror("duration(1:3, 0, 0) - hours(1:2)", msg);
msg = msprintf(_("%s: Wrong size for input arguments #%d and #%d: scalar or matrix of same size expected.\n"), "%duration_s_s", 1, 2);
assert_checkerror("duration(1:3, 0, 0) - [1:2]", msg);

msg = msprintf(_("%s: Inconsistent row/column dimensions.\n"), "%duration_m_s");
assert_checkerror("duration(1:3, 0, 0) * [1:2]", msg);
msg = msprintf(_("%s: Inconsistent row/column dimensions.\n"), "%s_m_duration");
assert_checkerror("[1:2] * duration(1:3, 0, 0)", msg);

msg = msprintf(_("%s: Wrong size for input arguments #%d and #%d: scalar or matrix of same size expected.\n"), "%duration_r_s", 1, 2);
assert_checkerror("duration(1:3, 0, 0)/[1:2]", msg);
msg = msprintf(_("%s: Wrong size for input arguments #%d and #%d: scalar or matrix of same size expected.\n"), "%duration_r_duration", 1, 2);
assert_checkerror("duration(1:3, 0, 0)/duration(1:2, 0, 0)", msg);

msg = msprintf(_("%s: Wrong size for input arguments #%d and #%d: scalar or matrix of same size expected.\n"), "%duration_2_s", 1, 2);
assert_checkerror("duration([6 30 30; 4 15 0]) > [5 6]", msg);
msg = msprintf(_("%s: Wrong size for input arguments #%d and #%d: scalar or matrix of same size expected.\n"), "%duration_2_duration", 1, 2);
assert_checkerror("duration([6 30 30; 4 15 0]) > duration([5 6], 0, 0)", msg);
msg = msprintf(_("%s: Wrong size for input arguments #%d and #%d: scalar or matrix of same size expected.\n"), "%s_2_duration", 1, 2);
assert_checkerror("[5 6] > duration([6 30 30; 4 15 0])", msg);

msg = msprintf(_("%s: Wrong size for input arguments #%d and #%d: scalar or matrix of same size expected.\n"), "%duration_4_s", 1, 2);
assert_checkerror("duration([6 30 30; 4 15 0]) >= [5 6]", msg);
msg = msprintf(_("%s: Wrong size for input arguments #%d and #%d: scalar or matrix of same size expected.\n"), "%duration_4_duration", 1, 2);
assert_checkerror("duration([6 30 30; 4 15 0]) >= duration([5 6], 0, 0)", msg);
msg = msprintf(_("%s: Wrong size for input arguments #%d and #%d: scalar or matrix of same size expected.\n"), "%s_4_duration", 1, 2);
assert_checkerror("[5 6] >= duration([6 30 30; 4 15 0])", msg);

msg = msprintf(_("%s: Wrong size for input arguments #%d and #%d: scalar or matrix of same size expected.\n"), "%duration_1_s", 1, 2);
assert_checkerror("duration([6 30 30; 4 15 0]) < [7 5]", msg);
msg = msprintf(_("%s: Wrong size for input arguments #%d and #%d: scalar or matrix of same size expected.\n"), "%duration_1_duration", 1, 2);
assert_checkerror("duration([6 30 30; 4 15 0]) < duration([7 6], 0, 0)", msg);
msg = msprintf(_("%s: Wrong size for input arguments #%d and #%d: scalar or matrix of same size expected.\n"), "%s_1_duration", 1, 2);
assert_checkerror("[5 6] < duration([6 30 30; 6 15 0])", msg);

msg = msprintf(_("%s: Wrong size for input arguments #%d and #%d: scalar or matrix of same size expected.\n"), "%duration_3_s", 1, 2);
assert_checkerror("duration([6 30 30; 4 15 0]) <= [7 5]", msg);
msg = msprintf(_("%s: Wrong size for input arguments #%d and #%d: scalar or matrix of same size expected.\n"), "%duration_3_duration", 1, 2);
assert_checkerror("duration([6 30 30; 4 15 0]) <= duration([7 6], 0, 0)", msg);
msg = msprintf(_("%s: Wrong size for input arguments #%d and #%d: scalar or matrix of same size expected.\n"), "%s_3_duration", 1, 2);
assert_checkerror("[5 6] <= duration([6 30 30; 6 15 0])", msg);

msg = msprintf(_("%s: Wrong size for input arguments: scalars expected.\n"), "%duration_b_duration");
assert_checkerror("duration([0 1], 0, 0):duration(12, 0, 0)", msg);

msg = msprintf(_("%s: Wrong size for input arguments #%d and #%d: scalar or matrix of same size expected.\n"), "%duration_f_duration", 1, 2);
assert_checkerror("[duration([0 1], 0, 0); duration(12, 0, 0)]", msg);
msg = msprintf(_("%s: Wrong size for input arguments #%d and #%d: scalar or matrix of same size expected.\n"), "%duration_c_duration", 1, 2);
assert_checkerror("[duration([0; 1], 0, 0)  duration(12, 0, 0)]", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d.\n"), "duration", 1);
assert_checkerror("duration(""01:00"")", msg);

msg = msprintf(_("%s: Wrong format for input argument #%d: Not use ""%s"".\n"), "duration", 1, "dd:hh:mm:ss");
assert_checkerror("duration(""01:00"", ""InputFormat"", ""dd:hh:mm:ss"")", msg);
msg = msprintf(_("%s: Wrong format for input argument #%d: Not use ""%s"".\n"), "duration", 1, "hh:mm");
assert_checkerror("duration(""01:00:00"", ""InputFormat"", ""hh:mm"")", msg);
msg = msprintf(_("%s: Wrong format for input argument #%d: Not use ""%s"".\n"), "duration", 1, "dd:hh:mm:ss");
assert_checkerror("duration(""01:00:00"", ""InputFormat"", ""dd:hh:mm:ss"")", msg);
msg = msprintf(_("%s: Wrong format for input argument #%d: Not use ""%s"".\n"), "duration", 1, "mm:ss");
assert_checkerror("duration(""01:00:00:00"", ""InputFormat"", ""mm:ss"")", msg);

msg = msprintf(_("%s: Wrong size for input argument #%d: 3 or 4 columns expected.\n"), "duration", 1);
assert_checkerror("duration([0 5])", msg);
assert_checkerror("duration([0; 5])", msg);

// msg = msprintf(_("%s: Wrong format: Options {%s, %s, %s, %s, %s} expected.\n"), "%duration_string", "y", "d", "h", "m", "s");
// d = duration("01:01:01");
// assert_checkerror("d.format=""t""", msg);
