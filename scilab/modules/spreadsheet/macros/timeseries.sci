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

function ts = timeseries(varargin)
    // {
    //     names : ["Time", "Var1"],
    //     props: {
    //         SampleRate: 12
    //         TimeStep: 18
    //     }
    //     vars: [{
    //         data
    //         description
    //         units
    //         continuity
    //     }, {
    //         data
    //         description
    //         units
    //         continuity
    //     }]
    // }

    t = [];
    names = [];
    variableContinuity = [];
    variableUnits = [];
    step = [];
    sampleRate = [];
    timeStep = [];
    startTime = duration(0);
    hasStartTime = %f;
    fname = "timeseries";

    rhs = nargin;
    if rhs == 0 then
        error(msprintf(_("%s: Wrong number of input argument: At least %d expected.\n"), fname, 1));
    end
    
    if rhs == 1 then
        if typeof(varargin(1)) == "st" then
            variableNames = fieldnames(st)';
            l = list();
            for f = variableNames
                l($+1) = st(f);
            end
            ts = timeseries(l(:), "VariableNames", variableNames);
            return
        end
    end

    if nargin > 2 then

        for i = nargin-1:-2:1
            if type(varargin(i)) <> 10 || (type(varargin(i)) == 10 && ~isscalar(varargin(i))) then
                break;
            end

            select varargin(i)
            case "SampleRate"
                sampleRate = varargin(i + 1);
                if type(sampleRate) <> 1 then
                    error(msprintf(_("%s: Wrong type for %s argument #%d: a real value expected"), fname, "SampleRate", i+1));
                end
                step = duration(0, 0, 1 / sampleRate);
                timeStep = step;

            case "TimeStep"
                timeStep = varargin(i + 1);
                if ~isduration(timeStep) && ~iscalendarDuration(timeStep) then
                    error(msprintf(_("%s: Wrong type for %s argument #%d: duration or calendarDuration expected"), fname, "TimeStep", i+1));
                end
                step = timeStep;
                if isduration(timeStep) then
                    sampleRate = seconds(1) / timeStep;
                else
                    sampleRate = %nan;
                end
                
            case "StartTime"
                hasStartTime = %t;
                startTime = varargin(i + 1);
                if ~isduration(startTime) && ~isdatetime(startTime) then
                    error(msprintf(_("%s: Wrong type for %s argument #%d: duration or datetime expected"), fname, "StartTime", i+1));
                end
            case "VariableNames"
                names = varargin(i + 1);
                if type(names) <> 10 then
                    error(msprintf(_("%s: Wrong type for %s argument #%d: string vector expected"), fname, "VariableNames", i+1));
                end

                if or(names == "") then
                    error(msprintf(_("%s: Wrong value for %s argument #%d: no empty strings expected"), fname, "VariableNames", i+1));
                end
            case "VariableUnits"
                variableUnits = varargin(i + 1);
                if type(variableUnits) <> 10 then
                    error(msprintf(_("%s: Wrong type for %s argument #%d: string vector expected"), fname, "VariableUnits", i+1));
                end

            case "VariableContinuity"
                variableContinuity = varargin(i + 1);
                if type(variableContinuity) <> 10 then
                    error(msprintf(_("%s: Wrong type for %s argument #%d: string vector expected"), fname, "VariableContinuity", i+1));
                end

                defaultVariableContinuity = ["", "unset", "continuous", "event", "step"];
                for k = 1:size(variableContinuity, "*")
                    if and(variableContinuity(k) <> defaultVariableContinuity) then
                        error(msprintf(_("%s: Wrong type for %s argument #%d: %s, %s, %s or %s expected"), fname, "VariableContinuity", i+1, "unset", "continuous", "step", "event"));
                    end
                end

            case "RowTimes"
                t.data = varargin(i + 1);
                if ~isdatetime(t.data) && ~isduration(t.data) then
                    error(msprintf(_("%s: Wrong type for %s option: duration or datetime vector expected.\n"), fname, "RowTimes"));
                end
            else
                break;
            end

            rhs = rhs - 2;
        end

        if step <> [] && t == [] then
            if iscalendarDuration(step) && isduration(startTime) then
                error(msprintf(_("%s: Wrong type for %s option: StarTime must be a datetime when TimeStep is a calendarDuration.\n"), fname, "TimeStep"));
            end
            r = size(varargin(1), 1);
            t.data = (startTime:step:startTime + step * (r - 1))';
        end

        if hasStartTime && step == [] then
            error(msprintf(_("%s: %s must be used with %s or %s property.\n"), fname, "StartTime", "TimeStep", "SampleRate"));
        end
    end

    if rhs == 1 then
        data = varargin(1);
        if type(data) == 1 && size(data, 2) > 1 then
            l = list();
            for i = 1:size(data, 2)
                l($+1) = data(:,i);
            end
            ts = timeseries(l(:), varargin(2:$));
            return
        end
    end

    timeOffset = 1;
    if t == [] then
        if isduration(varargin(1)) || isdatetime(varargin(1)) then
            timeOffset = 0;
            if isrow(varargin(1)) then
                varargin(1) = varargin(1)';
            end
            t.data = varargin(1);
        else
            error(msprintf(_("%s: Row times vector is missing.\n"), fname));
        end
        
    end

    if size(t.data, "*") <> 0 && step == [] then
        if startTime <> duration(0) then
            //shift time vector to new startTime
            if t.data(1) > startTime then
                t.data = t.data - (t.data(1) - startTime);
            else
                t.data = t.data + (t.data(1) - startTime);
            end
        end

        if size(t.data, "*") == 1 then
            timeStep = %nan;
            sampleRate = %nan;
        else
            [tmp, step] = isregular(t.data);
            if ~tmp && isdatetime(t.data) then
                timeUnit = ["years", "months", "days"];
                for tu = timeUnit
                    [tmp, step] = isregular(t.data, tu)
                    if tmp then
                        break;
                    end
                end
            end
            if isnan(step) then
                timeStep = duration(step, 0,0);
                sampleRate = step;
            else
                timeStep = step;
                if isduration(timeStep) then
                    sampleRate = seconds(1) / timeStep;
                else
                    sampleRate = %nan;
                end
            end
            // diff_t = t.data(2:$) - t.data(1:$-1);
            // step = diff_t(1);
            // diff_t = diff_t - step;
            // if mean(diff_t.duration) then
            //     step = %nan;
            //     timeStep = duration(step, 0,0);
            //     sampleRate = step;
            // else
            //     timeStep = step;
            //     sampleRate = seconds(1) / timeStep;
            // end
            
        end
    end

    //data = []; 
    ref_size = size(varargin(1));
    for i = 2-timeOffset:rhs
        tmp = varargin(i);
        if and(typeof(tmp) <> ["constant", "boolean", "string", "duration", "datetime", "calendarduration"]) then
            error(msprintf(_("%s: Wrong type for input argument #%d: double, boolean or string matrix expected.\n"), fname, i, varargin(i)));
        end

        s = size(tmp);
        if s == [1 1] then
            tmp = repmat(tmp, ref_size(1), 1);
        elseif s(1) <> ref_size(1) then
            error(msprintf(_("%s: Wrong size for input argument #%d: must be the same size of time vector.\n"), fname, i));
        end
        //d.data = tmp;
        n = size(t, "*")
        if s(2) > 1 then
            for j = 1:s(2)
                t(1, n + j).data = tmp(:, j);
            end
        else
            t(1, n + 1).data = tmp;
        end
    end

    if names == [] then
        names(1) = "Time";
        for i = 2:size(t, "*")
            names(1, i) = sprintf("Var%d", i - 1);
        end
    else
        if size(names, "*") <> size(t, "*") then
            error(msprintf(_("%s: Wrong size of %s values.\n"), "timeseries", "VariableNames"));
        end
    end

    if variableContinuity == [] then
        variableContinuity = emptystr(names);
    end

    if variableUnits == [] then
        variableUnits = emptystr(names);
    end

    if t(1).data.format == [] then
        if typeof(t(1).data) == "datetime" then
            if t(1).data.time <> [] && or(t(1).data.time <> 0) then
                t(1).data.format = "yyyy-MM-dd HH:mm:ss";
            end
        end
    end

    props = mlist(["props", "description", "variableNames", "variableDescriptions", "variableUnits", "variableContinuity", "startTime", "sampleRate", "timeStep", "userdata"], ...
        "", names, emptystr(names), variableUnits, variableContinuity, t(1).data(1), sampleRate, timeStep, []);

    ts = mlist(["timeseries", "props", "vars"], props, t);

endfunction
