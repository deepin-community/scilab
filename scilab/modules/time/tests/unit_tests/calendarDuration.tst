// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - 3DS - Adeline CARNIS adeline.carnis@3ds.com
// Copyright (C) 2022 - 3DS - Antoine ELIAS antoine.elias@3ds.com
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

function checkcalendar(c, y, m, d, v)
    assert_checkequal(c.y, y);
    assert_checkequal(c.m, m);
    assert_checkequal(c.d, d);
    assert_checkequal(c.t.duration, v);
endfunction

function checkstring(d, v)
    assert_checkequal(%calendarDuration_string(d), v);
endfunction

checkcalendar(calendarDuration(0, 0, 0), 0, 0, 0, 0);
checkcalendar(calendarDuration(1, 0, 0), 1, 0, 0, 0);
checkcalendar(calendarDuration(0, 1, 0), 0, 1, 0, 0);
checkcalendar(calendarDuration(0, 0, 1), 0, 0, 1, 0);

checkstring(calendarDuration(0, 0, 0), " 0h 0m 0s");
checkstring(calendarDuration(1, 0, 0), " 1y");
checkstring(calendarDuration(0, 1, 0), " 1m");
checkstring(calendarDuration(0, 0, 1), " 1d");
checkstring(calendarDuration(0, 0, 0, hours(1)), " 1h 0m 0s");
checkstring(calendarDuration(1, 0, 0, hours(1)), " 1y 1h 0m 0s");
checkstring(calendarDuration(0, 1, 0, hours(1)), " 1m 1h 0m 0s");
checkstring(calendarDuration(0, 0, 1, hours(1)), " 1d 1h 0m 0s");
checkstring(calendarDuration(1, 0, 0, "OutputFormat", "mdt"), " 12m");
checkstring(calendarDuration(1, 1, 0, "OutputFormat", "ymdt"), " 1y 1m");
checkstring(calendarDuration(1, 1, 0, "OutputFormat", "mdt"), " 13m");

assert_checktrue(calendarDuration([1, 1, 1, 1, 1, 1]) == calendarDuration(1, 1, 1, hours(1) + minutes(1) + seconds(1)));
checkstring(calendarDuration([0, 0, 0, 0, 0, 0]), " 0h 0m 0s");
checkstring(calendarDuration([1, 0, 0, 0, 0, 0]), " 1y");
checkstring(calendarDuration([0, 1, 0, 0, 0, 0]), " 1m");
checkstring(calendarDuration([0, 0, 1, 0, 0, 0]), " 1d");
checkstring(calendarDuration([0, 0, 0, 1, 0, 0]), " 1h 0m 0s");
checkstring(calendarDuration([1, 0, 0, 1, 0, 0]), " 1y 1h 0m 0s");
checkstring(calendarDuration([0, 1, 0, 1, 0, 0]), " 1m 1h 0m 0s");
checkstring(calendarDuration([0, 0, 1, 1, 0, 0]), " 1d 1h 0m 0s");
checkstring(calendarDuration([1, 0, 0, 0, 0, 0], "OutputFormat", "mdt"), " 12m");
checkstring(calendarDuration([1, 1, 0, 0, 0, 0], "OutputFormat", "ymdt"), " 1y 1m");
checkstring(calendarDuration([1, 1, 0, 0, 0, 0], "OutputFormat", "mdt"), " 13m");

checkcalendar(calendarDuration(0, 10, 0) + caldays(10), 0, 10, 10, 0);
checkcalendar(caldays(10) + calendarDuration(0, 10, 0), 0, 10, 10, 0);
checkcalendar(calendarDuration(0, 10, 0) + caldays([10 20]), [0 0], [10 10], [10 20], [0 0]);
checkcalendar(caldays([10 20]) + calendarDuration(0, 10, 0), [0 0], [10 10], [10 20], [0 0]);
checkcalendar(calendarDuration(0, [10 20], 0) + caldays([10 20]), [0 1], [10 8], [10 20], [0 0]);
checkcalendar(caldays([10 20]) + calendarDuration(0, [10 20], 0), [0 1], [10 8], [10 20], [0 0]);
checkcalendar(calendarDuration(0, 10, 0) + 10, 0, 10, 10, 0);
checkcalendar(10 + calendarDuration(0, 10, 0), 0, 10, 10, 0);
checkcalendar(calendarDuration(0, 10, 0) + [10 20], [0 0], [10 10], [10 20], [0 0]);
checkcalendar([10 20] + calendarDuration(0, 10, 0), [0 0], [10 10], [10 20], [0 0]);
checkcalendar(calendarDuration(0, [10 20], 0) + [10 20], [0 1], [10 8], [10 20], [0 0]);
checkcalendar([10 20] + calendarDuration(0, [10 20], 0), [0 1], [10 8], [10 20], [0 0]);
checkcalendar(caldays(1) + duration(0, 0, 1), 0, 0, 1, 1000);
checkcalendar(duration(0,0,1) + caldays(1), 0, 0, 1, 1000);
checkcalendar(caldays(1) + duration(0, 0, [1 10]), [0 0], [0, 0], [1 1], [1000 10000]);
checkcalendar(duration(0, 0, [1 10]) + caldays(1), [0 0], [0, 0], [1 1], [1000 10000]);
checkcalendar(calendarDuration(1, [5 9], 1) + duration(0, 0, 30), [1 1], [5 9], [1 1], [30000 30000]);
checkcalendar(duration(0, 0, 30) + calendarDuration(1, [5 9], 1), [1 1], [5 9], [1 1], [30000 30000]);
checkcalendar(calyears(1:5) + calmonths(1:5) + caldays(10:14) + hours(6:10), 1:5, 1:5, 10:14, [6:10] * 3600 * 1000);
checkcalendar(hours(6:10) + calyears(1:5) + calmonths(1:5) + caldays(10:14), 1:5, 1:5, 10:14, [6:10] * 3600 * 1000);

assert_checktrue(calendarDuration(1, 0, 0) == calyears(1));
assert_checktrue(calendarDuration(0, 1, 0) == calmonths(1));
assert_checktrue(calendarDuration(0, 0, 1) == caldays(1));
assert_checktrue(calendarDuration(1, 1, 1) == calyears(1) + calmonths(1) + caldays(1));
assert_checktrue(calendarDuration([1 2], 1, 0) == calyears([1 2]) + calmonths(1));
assert_checktrue(calendarDuration(0, [1 2], 1) == calmonths([1 2]) + caldays(1));

assert_checktrue(calendarDuration(1, 0, 0) <> calyears(2));
assert_checktrue(calendarDuration(0, 1, 0) <> calmonths(2));
assert_checktrue(calendarDuration(0, 0, 1) <> caldays(2));
assert_checktrue(calendarDuration(1, 1, 1) <> calyears(2) + calmonths(2) + caldays(2));
assert_checktrue(calendarDuration([1 2], 1, 0) <> calyears([3 4]) + calmonths(2));
assert_checktrue(calendarDuration(0, [1 2], 1) <> calmonths([3 4]) + caldays(2));

assert_checktrue(calendarDuration(1, 0, 0) < calyears(2));
assert_checktrue(calendarDuration(0, 1, 0) < calmonths(2));
assert_checktrue(calendarDuration(0, 0, 1) < caldays(2));
assert_checktrue(calendarDuration(1, 1, 1) < calyears(2) + calmonths(2) + caldays(2));
assert_checktrue(calendarDuration([1 2], 1, 0) < calyears([3 4]) + calmonths(2));
assert_checktrue(calendarDuration(0, [1 2], 1) < calmonths([3 4]) + caldays(2));

assert_checktrue(calendarDuration(1, 0, 0) <= calyears(2));
assert_checktrue(calendarDuration(0, 1, 0) <= calmonths(2));
assert_checktrue(calendarDuration(0, 0, 1) <= caldays(2));
assert_checktrue(calendarDuration(1, 1, 1) <= calyears(2) + calmonths(2) + caldays(2));
assert_checktrue(calendarDuration([1 2], 1, 0) <= calyears([3 4]) + calmonths(2));
assert_checktrue(calendarDuration(0, [1 2], 1) <= calmonths([3 4]) + caldays(2));

assert_checktrue(calendarDuration(1, 0, 0) > calmonths(11));
assert_checktrue(calendarDuration(0, 1, 0) > caldays(29));
assert_checktrue(calendarDuration(0, 0, 1) > caldays(0));
assert_checktrue(calendarDuration(1, 1, 1) > calmonths(12) + caldays(31));
assert_checktrue(calendarDuration([1 2], 1, 0) > calyears([0 1]));
assert_checktrue(calendarDuration(0, [1 2], 1) > calmonths([0 1]));

assert_checktrue(calendarDuration(1, 0, 0) >= calmonths(13));
assert_checktrue(calendarDuration(0, 1, 0) >= caldays(30));
assert_checktrue(calendarDuration(0, 0, 1) >= caldays(1));
assert_checktrue(calendarDuration(1, 1, 1) >= calmonths(13));
assert_checktrue(calendarDuration([1 2], 1, 0) >= calyears([0 1])+ calmonths(1));
assert_checktrue(calendarDuration(0, [1 2], 1) >= calmonths([0 1]) + caldays(1));

A = calendarDuration([1 2], [10 11], [15 30]);
B = calendarDuration(0, [3 15], 0);
checkcalendar([A B], [1 2 0 0], [10 11 3 15], [15 30 0 0], [0 0 0 0]);
checkcalendar([A; B], [1 2; 0 0], [10 11; 3 15], [15 30; 0 0], [0 0; 0 0]);

checkcalendar(A * 2, [3 5], [8 10], [30 60], [0 0]);
checkcalendar(2 * A, [3 5], [8 10], [30 60], [0 0]);

C = calendarDuration(1, 2, 3, 15, 2, 2);
checkcalendar(C * 2, 2, 4, 6, 30 * 3600 * 1000 + 4 * 60 * 1000 + 4 * 1000);
checkcalendar(2 * C, 2, 4, 6, 30 * 3600 * 1000 + 4 * 60 * 1000 + 4 * 1000);

// outputFormat
c1 = calendarDuration(1, 10, 1, 10, 10, 10, "OutputFormat", "mdt");
c2 = calendarDuration(2, 5, 2, 2, 2, 2, "OutputFormat", "ymdt");
d = duration(3, 30, 45);
checkstring(c1 + c2 , " 51m 3d 12h 12m 12s");
checkstring(c2 + c1 , " 4y 3m 3d 12h 12m 12s");
checkstring(c1 + d, " 22m 1d 13h 40m 55s");
checkstring(d + c1, " 22m 1d 13h 40m 55s");
checkstring(c2 + d, " 2y 5m 2d 5h 32m 47s");
checkstring(d + c2, " 2y 5m 2d 5h 32m 47s");
checkstring(c1 + c2 + d, " 51m 3d 15h 42m 57s");
checkstring(d + c1 + c2, " 51m 3d 15h 42m 57s");
checkstring(c2 + c1 + d, " 4y 3m 3d 15h 42m 57s");
checkstring(d + c2 + c1, " 4y 3m 3d 15h 42m 57s");

coef = 3;
checkstring(c1 * coef, " 66m 3d 30h 30m 30s");
checkstring(coef * c1, " 66m 3d 30h 30m 30s");
checkstring(c2 * coef, " 7y 3m 6d 6h 6m 6s");
checkstring(coef * c2, " 7y 3m 6d 6h 6m 6s");

checkstring([c1 c2], [" 22m 1d 10h 10m 10s" " 29m 2d 2h 2m 2s"]);
checkstring([c1; c2], [" 22m 1d 10h 10m 10s"; " 29m 2d 2h 2m 2s"]);
checkstring([c2 c1], [" 2y 5m 2d 2h 2m 2s" " 1y 10m 1d 10h 10m 10s"]);
checkstring([c2; c1], [" 2y 5m 2d 2h 2m 2s"; " 1y 10m 1d 10h 10m 10s"]);

c3 = [c1 c2];
checkstring(c3 + d, [" 22m 1d 13h 40m 55s" " 29m 2d 5h 32m 47s"]);
checkstring(d + c3, [" 22m 1d 13h 40m 55s" " 29m 2d 5h 32m 47s"]);
checkstring(c3 * coef, [" 66m 3d 30h 30m 30s" " 87m 6d 6h 6m 6s"]);
checkstring(coef * c3, [" 66m 3d 30h 30m 30s" " 87m 6d 6h 6m 6s"]);

checkstring(c3' + d, [" 22m 1d 13h 40m 55s"; " 29m 2d 5h 32m 47s"]);
checkstring(d + c3', [" 22m 1d 13h 40m 55s"; " 29m 2d 5h 32m 47s"]);
checkstring(c3' * coef, [" 66m 3d 30h 30m 30s"; " 87m 6d 6h 6m 6s"]);
checkstring(coef * c3', [" 66m 3d 30h 30m 30s"; " 87m 6d 6h 6m 6s"]);

c4 = [c2 c1];
checkstring(c4 + d, [" 2y 5m 2d 5h 32m 47s" " 1y 10m 1d 13h 40m 55s"]);
checkstring(d + c4, [" 2y 5m 2d 5h 32m 47s" " 1y 10m 1d 13h 40m 55s"]);
checkstring(c4 * coef, [" 7y 3m 6d 6h 6m 6s" " 5y 6m 3d 30h 30m 30s"]);
checkstring(coef * c4, [" 7y 3m 6d 6h 6m 6s" " 5y 6m 3d 30h 30m 30s"]);

checkstring(c4' + d, [" 2y 5m 2d 5h 32m 47s"; " 1y 10m 1d 13h 40m 55s"]);
checkstring(d + c4', [" 2y 5m 2d 5h 32m 47s"; " 1y 10m 1d 13h 40m 55s"]);
checkstring(c4' * coef, [" 7y 3m 6d 6h 6m 6s"; " 5y 6m 3d 30h 30m 30s"]);
checkstring(coef * c4', [" 7y 3m 6d 6h 6m 6s"; " 5y 6m 3d 30h 30m 30s"]);

d2 = duration(3:4, 10, 15);
checkstring(c1 + d2, [" 22m 1d 13h 20m 25s" " 22m 1d 14h 20m 25s"]);
checkstring(d2 + c1, [" 22m 1d 13h 20m 25s" " 22m 1d 14h 20m 25s"]);
checkstring(c1 + d2', [" 22m 1d 13h 20m 25s"; " 22m 1d 14h 20m 25s"]);
checkstring(d2' + c1, [" 22m 1d 13h 20m 25s"; " 22m 1d 14h 20m 25s"]);
checkstring(c2 + d2, [" 2y 5m 2d 5h 12m 17s" " 2y 5m 2d 6h 12m 17s"]);
checkstring(d2 + c2, [" 2y 5m 2d 5h 12m 17s" " 2y 5m 2d 6h 12m 17s"]);
checkstring(c2 + d2', [" 2y 5m 2d 5h 12m 17s"; " 2y 5m 2d 6h 12m 17s"]);
checkstring(d2' + c2, [" 2y 5m 2d 5h 12m 17s"; " 2y 5m 2d 6h 12m 17s"]);
checkstring(c3 + d2, [" 22m 1d 13h 20m 25s" " 29m 2d 6h 12m 17s"]);
checkstring(d2 + c3, [" 22m 1d 13h 20m 25s" " 29m 2d 6h 12m 17s"]);
checkstring(c3' + d2', [" 22m 1d 13h 20m 25s"; " 29m 2d 6h 12m 17s"]);
checkstring(d2' + c3', [" 22m 1d 13h 20m 25s"; " 29m 2d 6h 12m 17s"]);
checkstring(c4 + d2, [" 2y 5m 2d 5h 12m 17s" " 1y 10m 1d 14h 20m 25s"]);
checkstring(d2 + c4, [" 2y 5m 2d 5h 12m 17s" " 1y 10m 1d 14h 20m 25s"]);
checkstring(c4' + d2', [" 2y 5m 2d 5h 12m 17s"; " 1y 10m 1d 14h 20m 25s"]);
checkstring(d2' + c4', [" 2y 5m 2d 5h 12m 17s"; " 1y 10m 1d 14h 20m 25s"]);

coef = [3 5];
checkstring(c1 * coef, [" 66m 3d 30h 30m 30s" " 110m 5d 50h 50m 50s"]);
checkstring(coef * c1, [" 66m 3d 30h 30m 30s" " 110m 5d 50h 50m 50s"]);
checkstring(c1 * coef', [" 66m 3d 30h 30m 30s"; " 110m 5d 50h 50m 50s"]);
checkstring(coef' * c1, [" 66m 3d 30h 30m 30s"; " 110m 5d 50h 50m 50s"]);
checkstring(c2 * coef, [" 7y 3m 6d 6h 6m 6s" " 12y 1m 10d 10h 10m 10s"]);
checkstring(coef * c2, [" 7y 3m 6d 6h 6m 6s" " 12y 1m 10d 10h 10m 10s"]);
checkstring(c2 * coef', [" 7y 3m 6d 6h 6m 6s"; " 12y 1m 10d 10h 10m 10s"]);
checkstring(coef' * c2, [" 7y 3m 6d 6h 6m 6s"; " 12y 1m 10d 10h 10m 10s"]);
checkstring(c3' * coef, [" 66m 3d 30h 30m 30s" " 110m 5d 50h 50m 50s"; " 87m 6d 6h 6m 6s" " 145m 10d 10h 10m 10s"]);
checkstring(coef * c3', [" 66m 3d 30h 30m 30s" " 110m 5d 50h 50m 50s"; " 87m 6d 6h 6m 6s" " 145m 10d 10h 10m 10s"]);
checkstring(c3 * coef', " 211m 13d 40h 40m 40s");
checkstring(coef' * c3, " 211m 13d 40h 40m 40s");
checkstring(c4' * coef, [" 7y 3m 6d 6h 6m 6s" " 12y 1m 10d 10h 10m 10s"; " 5y 6m 3d 30h 30m 30s" " 9y 2m 5d 50h 50m 50s"]);
checkstring(coef * c4', [" 7y 3m 6d 6h 6m 6s" " 12y 1m 10d 10h 10m 10s"; " 5y 6m 3d 30h 30m 30s" " 9y 2m 5d 50h 50m 50s"]);
checkstring(c4 * coef', " 16y 5m 11d 56h 56m 56s");
checkstring(coef' * c4, " 16y 5m 11d 56h 56m 56s");

checkstring(coef .* c3, [" 66m 3d 30h 30m 30s" " 145m 10d 10h 10m 10s"]);
checkstring(coef' .* c3', [" 66m 3d 30h 30m 30s"; " 145m 10d 10h 10m 10s"]);
checkstring(c3 .* coef, [" 66m 3d 30h 30m 30s" " 145m 10d 10h 10m 10s"]);
checkstring(c3' .* coef', [" 66m 3d 30h 30m 30s"; " 145m 10d 10h 10m 10s"]);
checkstring(coef .* c4, [" 7y 3m 6d 6h 6m 6s" " 9y 2m 5d 50h 50m 50s"]);
checkstring(coef' .* c4', [" 7y 3m 6d 6h 6m 6s"; " 9y 2m 5d 50h 50m 50s"]);
checkstring(c4 .* coef, [" 7y 3m 6d 6h 6m 6s" " 9y 2m 5d 50h 50m 50s"]);
checkstring(c4' .* coef', [" 7y 3m 6d 6h 6m 6s"; " 9y 2m 5d 50h 50m 50s"]);

du = duration(2, 2, 2);
checkcalendar(c3(2), 2, 5, 2, du.duration);
checkcalendar(c3(1, 2), 2, 5, 2, du.duration);

c = caldays(1:2);
c(2, [1 2]) = caldays(3:4);
checkcalendar(c, zeros(2, 2), zeros(2, 2), [1 2;3 4], zeros(2, 2));
c($+1, :) = caldays(5:6);
checkcalendar(c, zeros(3, 2), zeros(3, 2), [1 2;3 4;5 6], zeros(3, 2));
c(:, $+1) = c(1:3);
checkcalendar(c, zeros(3, 3), zeros(3, 3), [1 2 1;3 4 3;5 6 5], zeros(3, 3));
c(2, 2) = c(1,2) + c(3,2);
checkcalendar(c, zeros(3, 3), zeros(3, 3), [1 2 1;3 8 3;5 6 5], zeros(3, 3));

clear e;
e(1:3) = caldays(1);
checkcalendar(e, zeros(3, 1), zeros(3, 1), ones(3, 1), zeros(3, 1));
e(4, $+1) = caldays(1);
checkcalendar(e, zeros(4, 2), zeros(4, 2), [1 0; 1 0; 1 0; 0 1], zeros(4, 2));

clear e;
e = []; e($+1) = caldays(1);
checkcalendar(e, 0, 0, 1, 0);

// checkerror
msg = msprintf(_("%s: Wrong number of input argument: %d to %d expected, except to %d and %d.\n"), "calendarDuration", 1, 8, 2, 7);
assert_checkerror("calendarDuration(1, 2, 3, 4, 5)", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: real expected.\n"), "calendarDuration", 1);
assert_checkerror("calendarDuration(""1"")", msg);

msg = msprintf(_("%s: Wrong type for input arguments #%d, #%d and #%d: reals expected.\n"), "calendarDuration", 1, 2, 3);
assert_checkerror("calendarDuration(""1"", ""2"", ""3"")", msg);

msg = msprintf(_("%s: Wrong type for input arguments #%d, #%d and #%d: reals expected.\n"), "calendarDuration", 1, 2, 3);
assert_checkerror("calendarDuration(""1"", 2, 3, hours(1))", msg);
msg = msprintf(_("%s: Wrong type for input arguments #%d, #%d and #%d: reals expected.\n"), "calendarDuration", 1, 2, 3);
assert_checkerror("calendarDuration(1, 2, ""3"", hours(1))", msg);
msg = msprintf(_("%s: Wrong type for input argument #%d: duration expected.\n"), "calendarDuration", 4);
assert_checkerror("calendarDuration(1, 2, 3, 1)", msg);

msg = msprintf(_("%s: Wrong type for input arguments #%d, #%d, #%d, #%d, #%d and #%d: reals expected.\n"), "calendarDuration", 1, 2, 3, 4, 5, 6);
assert_checkerror("calendarDuration(1, ""2"", 3, 1, 15, 30)", msg);

msg = msprintf(_("%s: Wrong size for input arguments #%d and #%d: scalar or matrix of same size expected.\n"), "%calendarDuration_a_s", 1, 2);
assert_checkerror("calendarDuration(0, [10 20 30], 0) + [10 20]", msg);
msg = msprintf(_("%s: Wrong size for input arguments #%d and #%d: scalar or matrix of same size expected.\n"), "%s_a_calendarDuration", 1, 2);
assert_checkerror("[10 20] + calendarDuration(0, [10 20 30], 0)", msg);
msg = msprintf(_("%s: Wrong size for input arguments #%d and #%d: scalar or matrix of same size expected.\n"), "%calendarDuration_a_calendarDuration", 1, 2);
assert_checkerror("caldays([10 20]) + calendarDuration(0, [10 20 30], 0)", msg);
msg = msprintf(_("%s: Wrong size for input arguments #%d and #%d: scalar or matrix of same size expected.\n"), "%duration_a_calendarDuration", 1, 2);
assert_checkerror("hours([10 20]) + calendarDuration(0, [10 20 30], 0)", msg);
assert_checkerror("hours([10; 20]) + calendarDuration(0, [10 20 30], 0)", msg);
assert_checkerror("hours([10; 20]) + calendarDuration(0, [10; 20; 30], 0)", msg);
assert_checkerror("hours([10 20]) + calendarDuration(0, [10; 20; 30], 0)", msg);

msg = msprintf(_("%s: Wrong size for input arguments #%d and #%d: scalar or matrix of same size expected.\n"), "%calendarDuration_a_duration", 1, 2);
assert_checkerror("calendarDuration(0, [10 20 30], 0) + hours([10 20])", msg);
assert_checkerror("calendarDuration(0, [10 20 30], 0) + hours([10; 20])", msg);
assert_checkerror("calendarDuration(0, [10; 20; 30], 0) + hours([10; 20])", msg);
assert_checkerror("calendarDuration(0, [10; 20; 30], 0) + hours([10 20])", msg);

msg = msprintf(_("%s: Wrong size for input arguments #%d and #%d: scalar or matrix of same size expected.\n"), "%calendarDuration_2_calendarDuration", 1, 2);
assert_checkerror("calendarDuration([1 2 3], 0, 0) > calendarDuration([1 2], 0, 0)", msg);
assert_checkerror("calendarDuration([1 2], 0, 0) > calendarDuration([1 2 3], 0, 0)", msg);

msg = msprintf(_("%s: Wrong size for input arguments #%d and #%d: scalar or matrix of same size expected.\n"), "%calendarDuration_4_calendarDuration", 1, 2);
assert_checkerror("calendarDuration([1 2 3], 0, 0) >= calendarDuration([1 2], 0, 0)", msg);
assert_checkerror("calendarDuration([1 2], 0, 0) >= calendarDuration([1 2 3], 0, 0)", msg);

msg = msprintf(_("%s: Wrong size for input arguments #%d and #%d: scalar or matrix of same size expected.\n"), "%calendarDuration_1_calendarDuration", 1, 2);
assert_checkerror("calendarDuration([1 2 3], 0, 0) < calendarDuration([1 2], 0, 0)", msg);
assert_checkerror("calendarDuration([1 2], 0, 0) < calendarDuration([1 2 3], 0, 0)", msg);

msg = msprintf(_("%s: Wrong size for input arguments #%d and #%d: scalar or matrix of same size expected.\n"), "%calendarDuration_3_calendarDuration", 1, 2);
assert_checkerror("calendarDuration([1 2 3], 0, 0) <= calendarDuration([1 2], 0, 0)", msg);
assert_checkerror("calendarDuration([1 2], 0, 0) <= calendarDuration([1 2 3], 0, 0)", msg);

msg = msprintf(_("%s: Wrong size for input arguments #%d and #%d: scalar or matrix of same size expected.\n"), "%calendarDuration_f_calendarDuration", 1, 2);
assert_checkerror("[calendarDuration([1 2 3], 0, 0); calendarDuration([1 2], 0, 0)]", msg);
assert_checkerror("[calendarDuration([1 2], 0, 0); calendarDuration([1 2 3], 0, 0)]", msg);
assert_checkerror("[calendarDuration([1 2 3], 0, 0); calendarDuration([1; 2], 0, 0)]", msg);
assert_checkerror("[calendarDuration([1 2], 0, 0); calendarDuration([1; 2; 3], 0, 0)]", msg);

msg = msprintf(_("%s: Wrong size for input arguments #%d and #%d: scalar or matrix of same size expected.\n"), "%calendarDuration_c_calendarDuration", 1, 2);
assert_checkerror("[calendarDuration([1; 2; 3], 0, 0) calendarDuration([1; 2], 0, 0)]", msg);
assert_checkerror("[calendarDuration([1; 2], 0, 0) calendarDuration([1; 2; 3], 0, 0)]", msg);
assert_checkerror("[calendarDuration([1; 2; 3], 0, 0) calendarDuration([1 2], 0, 0)]", msg);
assert_checkerror("[calendarDuration([1; 2], 0, 0) calendarDuration([1 2 3], 0, 0)]", msg);

msg = msprintf(_("%s: Inconsistent row/column dimensions.\n"), "%calendarDuration_m_s");
assert_checkerror("calendarDuration([1 2 3], 0, 0) * [1 2]", msg);
assert_checkerror("calendarDuration([1 2 3], 0, 0) * [1; 2]", msg);
assert_checkerror("calendarDuration([1; 2; 3], 0, 0) * [1 2]", msg);
assert_checkerror("calendarDuration([1; 2; 3], 0, 0) * [1; 2]", msg);

msg = msprintf(_("%s: Inconsistent row/column dimensions.\n"), "%s_m_calendarDuration");
assert_checkerror("[1 2] * calendarDuration([1 2 3], 0, 0)", msg);
assert_checkerror("[1; 2] * calendarDuration([1 2 3], 0, 0)", msg);
assert_checkerror("[1 2] * calendarDuration([1; 2; 3], 0, 0)", msg);
assert_checkerror("[1; 2] * calendarDuration([1; 2; 3], 0, 0)", msg);

// extraction error
msg = msprintf(_("%s: Invalid index.\n"), "%calendarDuration_e");
assert_checkerror("c3(3)", msg);
assert_checkerror("c3(2, 1)", msg);
assert_checkerror("c3(1, 3)", msg);