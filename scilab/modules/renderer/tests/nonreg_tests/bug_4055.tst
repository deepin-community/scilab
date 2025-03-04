//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - DIGITEO - Allan CORNET
// Copyright (C) 2013 - Scilab Enterprises - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 4055 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/4055
//
// <-- Short Description -->
// From time to time, when I plot a graphic, scilab displays a blank graphic windows.

if getos() == 'Windows' then

    if fileinfo(SCI+'\bin\jogl_desktop.dll') == [] then pause,end
    if fileinfo(SCI+'\bin\gluegen_rt.dll') == [] then pause,end

    if fileinfo(SCI+'\thirdparty\gluegen-rt.jar') == [] then pause,end
    if fileinfo(SCI+'\thirdparty\jogl-all.jar') == [] then pause,end

end

