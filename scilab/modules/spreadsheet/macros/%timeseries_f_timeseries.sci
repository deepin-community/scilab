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

function out = %timeseries_f_timeseries(ts1, ts2)
    if or(ts1.props.variableNames <> ts2.props.variableNames) then
        error(msprintf(_("%s: %s properties must contains the same names.\n"), "%timeseries_f_timeseries", "VariableNames"));
    end

    out = ts1;
    for c = 1:size(ts1.vars, "*")
        out.vars(c).data = [ts1.vars(c).data;ts2.vars(c).data];
    end

    diff_t = out.vars(1).data(2:$) - out.vars(1).data(1:$-1);
    step = diff_t(1);
    diff_t = diff_t - step;
    if mean(diff_t.duration) then
        step = %nan;
        out.props.timeStep = step;
        out.props.sampleRate = step;
    else
        out.props.timeStep = step;
        out.props.sampleRate = seconds(1) / step;
    end
endfunction
