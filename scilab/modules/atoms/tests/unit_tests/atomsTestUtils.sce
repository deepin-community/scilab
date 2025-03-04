// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systemes - Bruno JOFRET <bruno.jofret@3ds.com>
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
function atomsLoadTestScene(name)
    select name
    case "scene10"
        archives = [
            "toolbox_1V6_1.0-1.bin.x64.windows.zip",
            "toolbox_2V6_1.0-1.bin.zip",
            "toolbox_2V6_2.0-1.bin.zip",
            "toolbox_3V6_1.0-1.bin.zip",
            "toolbox_4V6_1.0-1.bin.zip",
            "toolbox_5V6_1.0-1.bin.x64.windows.zip",
            "toolbox_6V6_1.0-1.bin.zip"]
    case "scene11"
        archives = [
            "toolbox_1V6_1.0-1.bin.x64.windows.zip",
            "toolbox_2V6_1.0-1.bin.zip",
            "toolbox_2V6_2.0-1.bin.zip",
            "toolbox_2V6_2.1-1.bin.zip",
            "toolbox_4V6_1.0-1.bin.zip",
            "toolbox_5V6_1.0-1.bin.x64.windows.zip"]
    case "scene12"
        archives = [
            "toolbox_1V6_1.0-1.bin.x64.windows.zip",
            "toolbox_2V6_1.0-1.bin.zip",
            "toolbox_2V6_2.0-1.bin.zip",
            "toolbox_2V6_2.1-1.bin.zip",
            "toolbox_4V6_1.1-2.bin.zip",
            "toolbox_5V6_1.0-1.bin.x64.windows.zip"]
    else
        error(msprintf(_("atomsLoadTestScene: Unknown scene: %s."), name));
    end
    repository = atomsCreateLocalRepositoryFromDescription(SCI+"/modules/atoms/tests/unit_tests/" + name + ".DESCRIPTION", name);
    atomsRepositorySetOfl(repository);
    for iFile = 1:size(archives, "*")
        copyfile(SCI + "/modules/atoms/tests/unit_tests/" + archives(iFile), TMPDIR + "/" + name + "/");
    end
endfunction

function filePath = atomsCreateLocalRepositoryFromDescription(descriptionFile, name)
    filePath = "";
    gzip = findGzip();
    [OSNAME,ARCH,LINUX,MACOSX,SOLARIS,BSD] = atomsGetPlatform();
    
    // Remove/Create repository folder
    [status, message] = rmdir(TMPDIR + filesep() + name,'s')
    mkdir(TMPDIR, name);
    
    // Edit description file to replace TMPDIR by its value
    desc = mgetl(descriptionFile);
    for iLine=1:size(desc, "*")
        if ~isempty(strindex(desc(iLine), "TMPDIR")) then
            desc(iLine) = strsubst(desc(iLine), "TMPDIR", strsubst(TMPDIR, "\", "/"));
        end
    end
    tmpDescriptionFile = fullfile(TMPDIR, name + ".DESCRIPTION");
    mputl(desc, tmpDescriptionFile)
    
    // Gzip description file
    localRepository = TMPDIR + filesep() + name + filesep() + OSNAME + ".gz"
    [rep, stat ,err] = unix_g(gzip + " -c " + tmpDescriptionFile + " > " + localRepository);

    // TMPDIR is using C:\Users\Me under Linux
    // but we need a valid URI
    filePath = "file://" + strsubst(TMPDIR + filesep() + name, "\", "/")
endfunction

function gzipCommand = findGzip()
    [OSNAME,ARCH,LINUX,MACOSX,SOLARIS,BSD] = atomsGetPlatform();
    if OSNAME == "windows" then
        gzipCommand = getshortpathname(fullpath(pathconvert(SCI+"/tools/gzip/gzip.exe",%F)));
    else
        gzipCommand = "gzip"
    end 
endfunction

function atomsRepositoryReset()
    userRep = atomsRepositoryList("user");
    allusersRep = atomsRepositoryList("allusers");
    if userRep <> [] then
        atomsRepositoryDel(userRep);
    end
    if allusersRep <> [] then
        atomsRepositoryDel(allusersRep);
    end
    sampleRep = atomsCreateLocalRepositoryFromDescription(SCI+"/modules/atoms/tests/unit_tests/sample.DESCRIPTION", "sample")
    atomsRepositorySetOfl(sampleRep);
endfunction
