//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2020 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received
//
//

function %_spCompJacobian_p(spch)
    st = struct();
    names = fieldnames(spch);
    for i = 1:size(names,"*")-1;
        st(names(i)) = spch(names(i))    
    end
    mprintf(string(st))
endfunction
