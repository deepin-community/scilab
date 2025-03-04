// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - 3DS - Adeline CARNIS
// Copyright (C) 2022 - 3DS - Antoine ELIAS
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function [d,t] = %datetime_splitter(dt)
    d = floor(dt);
    fracd = dt - d;
    tmps = abs(%eps * 86400 * dt);
    tmps(tmps == 0) = 1;
    srnd = 2 .^ floor(-log2(tmps));
    t = round (86400 * fracd .* srnd) ./ srnd;
endfunction
