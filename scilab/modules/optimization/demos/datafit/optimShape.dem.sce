// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systemes - Bruno JOFRET
//
// This file is released under the 3-clause BSD license. See COPYING-BSD.
function demo_optimshape()

    function optimshapeplot(x, optimValues, state)
        if (state == "init") then
            // Initialise second axes: cost function values
            subplot(1, 2, 2);
            a = gca();
            a.tag = "costfunction";
            xlabel("Iteration");
            ylabel("Function value");
            xtitle("Current Function Value");
            plot(0, optimValues.fval);
            e = gce().children;
            e.mark_mode = "on";
            e.mark_style = 5;
            e.mark_size = 10;
            e.mark_background = 6;
            e.tag = "CostFunctionValue";
        else
            // Update value
            e = get("CostFunctionValue");
            e.data($+1,1:2) = [optimValues.iteration optimValues.fval];
            // Update axes
            // Compute new bounds
            itermin = 0;
            itermax = optimValues.iteration;
            fmin = min(e.data(:,2));
            fmax = max(e.data(:,2));
            a = get("costfunction");
            a.data_bounds = [
                itermin fmin
                itermax fmax
            ];
            // Title
            a.title.text = msprintf("Current Function Value: %e", optimValues.fval)
        end
    endfunction

    function g = costfunction(X, nbPoint, XTarget)
        // Compute cost value
        g = sum((matrix(X, [2, nbPoint]) - XTarget).^2)

        // Update shape graphics
        e = get("CurrentShape");
        e.data = matrix(X, [2, nbPoint])' .* 10;
    endfunction

    // Create a figure to be able to see the optimisation steps
    // First axes: Shapes / Second axes: cost function values
    my_handle = scf(100001);
    clf(my_handle,"reset");
    my_handle.axes_size = [935 450];
    demo_viewCode("optimShape.dem.sce");
    subplot(1, 2, 1);
    xlabel("X");
    ylabel("Y");
    xtitle("Shape");
    a = gca();
    a.axes_visible = "on";
    a.box = "on";
    a.clip_state = "clipgrf";
    // Target shape
    xpoly(0, 0);
    e = gce();
    e.foreground = color("red");
    e.mark_foreground = color("red");
    e.closed = "on";
    e.mark_mode = "on";
    e.mark_size = 3;
    e.tag = "TargetShape";
    // Current optimisation step shape
    xpoly(0, 0);
    e = gce();
    e.foreground = color("green");
    e.mark_foreground = color("green");
    e.closed = "on";
    e.mark_mode = "on";
    e.mark_size = 3;
    e.tag = "CurrentShape"
    legend(["Target", "Current"]);

    // Optimisation settings
    opt = optimset("Display", "iter", ...
                "PlotFcns" , optimshapeplot, ...
                "TolX", 1e-5, ...
                "MaxIter", 1e5, ...
                "MaxFunEvals", 1e6);

    // Define target
    nbPoint = 5
    // ** Random Shape
    bounds = [0, 0; 10, 10];
    XTarget = rand(2, nbPoint);
    // ** Circle Shape
    //bounds = [-10, -10; 10, 12];
    //v = linspace(0, 2*%pi, nbPoint + 1);
    //XTarget = [ sin(v(1:$-1));
    //            cos(v(1:$-1))] 

    // Update graphics
    a.data_bounds = bounds;
    e = get("TargetShape")
    e.data = matrix(XTarget, [2, nbPoint])' .* 10;

    // Initial point
    XStart = rand(2, nbPoint);
    [Xopt fval] = fminsearch(list(costfunction, nbPoint, XTarget), XStart, opt);

    my_handle.info_message = _("Completed!");
endfunction

demo_optimshape();
clear demo_optimshape();