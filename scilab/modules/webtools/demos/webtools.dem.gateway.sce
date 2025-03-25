// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes - Clément DAVID
//
// This file is released under the 3-clause BSD license. See COPYING-BSD.

function subdemolist = demo_gateway()

    demopath = get_absolute_file_path();
    gettext("Webtools");   // Lets gettext() harvesting it
    add_demo("Webtools", demopath + "webtools.dem.gateway.sce");

    subdemolist = [_("COVID JSON data from European ECDC")  "ecdc.dem.sce"
                   _("COVID CSV data from OurWorldInData")  "ourworldindata.dem.sce"];

    subdemolist(:,2) = demopath + subdemolist(:,2);

endfunction

subdemolist = demo_gateway();
clear demo_gateway;