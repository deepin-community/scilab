// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - 3DS - Adeline CARNIS
// Copyright (C) 2024 - 3DS - Antoine ELIAS
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function out = %duration_i_timeseries(i, val, ts)
    out = ts;
    select i
    case "StartTime"
    case "TimeStep"
    case "Properties"
    case "SampleRate"
    else
        idx = find(ts.props.variableNames == i);
        if idx == [] then
            varnames = [out.props.variableNames(1) i];
            out = [out timeseries(out.vars(1).data, val, "VariableNames", varnames)]
        else
            out.vars(idx).data = val;
        end
    end
endfunction
