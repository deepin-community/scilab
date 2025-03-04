// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2023 - Dassault Systemes - Bruno JOFRET
//
// This file is released under the 3-clause BSD license. See COPYING-BSD.


function demo_scilab_colormaps()

    colormapList = ["autumn", "bone", "cool", "copper", "gray", "hot", "hsv",...
    "jet", "ocean", "parula", "pink", "rainbow", "spring", "summer", "white", "winter"];

    //Compute gigantic colormap
    cmap=[];
    for i=colormapList
        cmap = [cmap ; colormap(evstr(i + "(128)"))]
    end

    n = size(colormapList, '*');
    M = zeros(128, n);
    M(:) = 1:size(M, '*');
    M = M'

    f=scf();
    f.figure_name = _("Scilab colormaps");
    Matplot(M)
    f.color_map = cmap;
    a=gca();
    a.axes_visible = ["off", "on", "off"];
    a.auto_ticks = "off";
    y_ticks = a.y_ticks;
    y_ticks.locations = (1:size(colormapList, '*'))'
    y_ticks.labels = colormapList($:-1:1)';
    a.y_ticks = y_ticks;
    a.sub_ticks = [0 0]
endfunction

demo_scilab_colormaps();
clear demo_scilab_colormaps;
