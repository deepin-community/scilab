// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - 3DS - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for princomp function
// =============================================================================

x = [1 2 1; 2 3 1; 0 2 1];
[facpr, comprinc, l, tsquare, explained, mu] = princomp(x);
assert_checkequal(size(facpr), [3 3]);
assert_checkequal(size(comprinc), [3 2]);
assert_checkequal(size(l), [2 1]);
assert_checkequal(size(tsquare), [3 1]);
assert_checkequal(size(explained), [2 1]);
assert_checkequal(size(mu), [1 3]);
assert_checkalmostequal(comprinc * facpr(:, 1:2)' + repmat(mu, 3, 1), x, [], %eps);
assert_checkalmostequal(sum(explained), 100);
assert_checkalmostequal(l, [1.2675919; 0.0657415], 1d-6);

x = [6 6 5 5; 8 8 8 8; 6 7 11 9; 14 14 15 15; 14 14 9 12; 11 10 5 7; 5 7 14 11; 13 12 8 9; 9 9 12 12];
[facpr, comprinc, l, tsquare, explained, mu] = princomp(x, %t);
assert_checkalmostequal(comprinc * facpr' + repmat(mu, 9, 1), x);
assert_checkalmostequal(sum(explained), 100);