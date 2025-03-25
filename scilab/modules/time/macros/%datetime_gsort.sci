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

function varargout = %datetime_gsort(dt, varargin)
    d = dt.date;
    t = dt.time;

    val = dt.date * (24*60*60) + t;
    [_, idx] = gsort(val, varargin(:));

    d = d(idx);
    t = t(idx);

    dt.date = d;
    dt.time = t;
    varargout(1) = dt;
    varargout(2) = idx;
endfunction
