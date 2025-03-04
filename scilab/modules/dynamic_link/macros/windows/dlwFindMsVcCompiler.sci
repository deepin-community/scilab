// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 3DS - 2023 - Antoine ELIAS
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

//=============================================================================
function MSCompiler = dlwFindMsVcCompiler()
    MSCompiler = "unknown";

    versions = getVsWhereInformation();
    if isempty(versions) then
        return
    end

    if size(versions, "*") == 1 then
        MSCompiler = versions.name;
        return;
    end

    val = getenv("SCILAB_PREFERRED_MSVC", "");
    if val == "" then //for compatibility
        val = getenv("SCILAB_PREFERED_MSVC", "");
    end

    if val then
        idx = findinlist(versions.name, val);
        if idx <> [] then
            MSCompiler = val;
            return;
        end
    end

    MSCompiler = versions(1).name;
endfunction