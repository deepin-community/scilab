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

function [delim, decim] = detectDelimiter(str, delimiters)
    if nargin == 1 then
        delimiters = [";", ",", "|", ":", " ", ascii(9)];    
    end

    r = size(str, "r");
    if r > 20 then
        r = 20
    end

    tab = zeros(r, size(delimiters, "*"));
    delim = [];
    newdelimiters = [];
    count = zeros(delimiters);

    tmp = strsubst(str(1:r), "/"".*?""/g", "", "r");
    tmp = strsubst(tmp, "/[""a-zA-Z0-9\.\-\+]+/g", "", "r");
    split = list();
    for i = 1:r
        split(i) = strsplit(tmp(i));
        newdelimiters = unique([newdelimiters; split(i)], "keepOrder")
    end

    for d = delimiters
        for c = 1:r
            idx = find(split(c) == d)
            if idx <> [] then
                if find(delim <> d) then
                    delim = [delim, d];
                end
                count(delimiters == d) = count(delimiters == d) + length(idx);
                tab(c, delimiters == d) = length(idx)
            end
        end
    end

    decim = ".";

    if delim == [] then
        if newdelimiters <> "" then
            delim = detectDelimiter(str, newdelimiters');
        end
    else
        nb = sum(bool2s(tab>0), "r");
        if modulo(max(nb), r) == 0 then
            delim = delimiters(nb == max(nb))(1);
        else
            [m, k] = max(count);
            delim = delimiters(k)
        end
    end

    // find decimal separator "," or "."
    if delim <> "," then
        index = find(delimiters == ",");
        decimal = [",", "."];
        if index <> [] then
            // search only "." separator
            count = [count(index) 0];
            k = 2;          
        else
            count = zeros(1, 2);
            k = 1:2;
        end

        for d = k
            for c = 1:r
                idx = strindex(str(c), decimal(d))
                if idx <> [] then
                    count(d) = count(d) + length(idx);
                end
            end
        end
        [m, k] = max(count);
        decim = decimal(k)
    end
    
endfunction
