// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systemes - Cedric DELAMARRE
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function varargout = splitURL(varargin)
    warnobsolete("url_split", "2025.0.0")
    if nargout == 0 then
        nargout = 1
    end
    c = "[" + strcat("varargout(" + string(1:nargout) + ")", ", ") + "] = url_split(varargin(:))";
    execstr(c);
endfunction
