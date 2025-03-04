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

function opts = detectImportOptions(filename, varargin)
    opts = struct();
    fname = "detectImportOptions";
    delim = "";
    decimal = [];

    if nargin == 0 then
        error(msprintf(_("%s: Wrong number of input arguments: At least %d expected.\n"), fname, 1));
    end

    if type(filename) <> 10 then
        error(msprintf(_("%s: Wrong type for input argument #%d: A string expected.\n"), fname, 1));
    end

    if isscalar(filename) then
        if isfile(filename) then
            // get extension from the filename
            extension = fileext(filename);
            // .txt, .dat or .csv for delimited text files
            if or(extension == [".txt", ".dat", ".csv"]) then
                f = mgetl(filename);
            else
                return
            end
        else
            f = filename;
        end
    else
        f = filename;
    end

    if nargin > 2 then
        if modulo(nargin-1, 2) <> 0 then
            error(msprintf(_("%s: Wrong number of input arguments"), fname));
        end

        for i = nargin-2:-2:1
            if type(varargin(i)) <> 10 || (type(varargin(i)) == 10 && ~isscalar(varargin(i))) then
                error(msprintf(_("%s: Wrong type for input argument #%d: A string expected.\n"), fname, i));
            end

            select varargin(i)
            case "Delimiter"
                delim = varargin(i+1);
                if type(delim) <> 10 then
                    error(msprintf(_("%s: Wrong type for %s argument #%d: A string expected.\n"), fname, "Delimiter", i+1));
                end
                if delim == "" then
                    error(msprintf(_("%s: Wrong value for %s argument #%d: A non-empty string expected.\n"), fname, "Delimiter", i+1));
                end

            case "Decimal"
                decimal = varargin(i+1);
                if type(decimal) <> 10 then
                    error(msprintf(_("%s: Wrong type for %s argument #%d: A string expected.\n"), fname, "Decimal", i+1));
                end
                if decimal == "" then
                    error(msprintf(_("%s: Wrong value for %s argument #%d: A non-empty string expected.\n"), fname, "Decimal", i+1));
                end
            end
        end 
    end

    while f($) == ""
        f($) = [];
    end

    // detect header
    [header, c , l] = detectHeader(f);

    // detect delimiter
    datalines = [1:size(f, "r")];
    if l <> [] then
        v = 1:size(f, "r");
        v(l) = [];
        f(l) = [];
        datalines = v;
    end
    headlines = [1 size(f, "r")];

    if delim == "" then
        if decimal == [] then
            [delim, decimal] = detectDelimiter(f);
        else
            delim = detectDelimiter(f);
        end
    else
        if decimal == [] then
            [a, decimal] = detectDelimiter(f, delim);
        end
    end

    // detect variable names and type
    test = csvTextScan(f(1), delim, decimal);
    variableNames = [];
    hasheader = %f;
    index = [];

    if size(f, "*") > 1 then
        if and(isnan(test)) then
            h = csvTextScan(f(1), delim, decimal, "string");
            variableNames = h;
            index = find(variableNames == "");
            datalines(1) = [];
            headlines(1) = [];
            hasheader = %t;
        end
        f(1) = [];
    end

    // csvTextScan on all the file
    h = csvTextScan(f, delim, decimal, "string");

    if ~hasheader & index <> [] & variableNames <> [] then
        for i = index
            if and(h(:, i) == "") then
                variableNames(index) = [];
            end
        end
    end

    variableTypes = emptystr(variableNames);
    inputFormat = [];

    for i = 1:size(h, 'c')
        // types managed : datetime, double, string
        if h(1, i) == "" then
            variableTypes(1,i) = "string";
            inputFormat(1,i) = "";
            mat = h(:, i);
            idx = mat <> "";
            if or(idx) then
                [infmt, _typ] = detectFormatDatetime(mat(idx)(1))
                variableTypes(1,i) = _typ;
                inputFormat(1,i) = infmt;
            else
                // empty column
                if index <> i then
                    index = [index, i];
                end
            end
        else
            [infmt, _typ] = detectFormatDatetime(h(:, i))
            variableTypes(1,i) = _typ;
            inputFormat(1,i) = infmt
        end
    end

    variableNames(index) = [];
    variableTypes(index) = [];
    inputFormat(index) = [];

    opts.variableNames = variableNames;
    opts.variableTypes = variableTypes;
    opts.delimiter = delim;
    opts.decimal = decimal;
    opts.datalines = datalines;
    opts.header = header;
    opts.inputFormat = inputFormat;
    opts.emptyCol = index;
    
endfunction
