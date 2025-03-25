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

function out = %datetime_b_duration(dt1, dura, dt2)
    if size(dt1, "*") <> 1 || size(dura, "*") <> 1 || size(dt2, "*") <> 1 then
        error(msprintf(_("%s: Wrong size for input arguments: scalars expected.\n"), "%datetime_b_duration"));
    end

    out = datetime([], "OutputFormat", dt1.format);
    if dt1 <= dt2 && dura > duration(0, 0, 0) then
        s = dt2 - dt1;
        vec = duration(0):dura:s;
        out = dt1 + vec;
    end
endfunction
