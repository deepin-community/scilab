// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - Sylvestre LEDRU
// Copyright (C) 2013 - Scilab Enterprises
// Copyright (C) 2023 - Dassault Systemes - cedric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//<-- CLI SHELL MODE -->
//<-- NO CHECK REF -->
//
// This test originally comming from the test of getURL function that have been replaced by http_get.

function checkFile(filePath, expectedFilePath, minimalFileSize)
    assert_checkequal(filePath, expectedFilePath)
    info = fileinfo(filePath);
    assert_checktrue(info(1) > minimalFileSize);
    deletefile(filePath);
endfunction

function checkFileAndContent(filePath, expectedFilePath, minimalFileSize, keywordToFind)
    fd = mopen(filePath, "r");
    assert_checktrue(grep(mgetl(fd), keywordToFind) <> []);
    mclose(fd);
    checkFile(filePath, expectedFilePath, minimalFileSize);
endfunction

function checkContent(content, keywordToFind)
    assert_checktrue(length(content) > 10);
    assert_checktrue(grep(content, keywordToFind) <> []);
endfunction

curdir = pwd();
destdir = fullfile(TMPDIR, "http_get");
mkdir(destdir);
cd(destdir);

// Check downloaded file
filePath = http_get("https://www.scilab.org", fullfile(destdir, "index.html"));
checkFile(filePath, fullfile(destdir, "index.html"), 1000);

filePath = http_get("https://www.scilab.org/", fullfile(destdir, "index.html"));
checkFile(filePath, fullfile(destdir, "index.html"), 1000);

filePath = http_get("https://help.scilab.org/numderivative.html", fullfile(destdir, "numderivative.html"));
checkFile(filePath, fullfile(destdir, "numderivative.html"), 1000);

filePath = http_get("www.scilab.org", fullfile(destdir, "index.html"), follow=%t);
checkFile(filePath, fullfile(destdir, "index.html"), 1000);

filePath = http_get("https://help.scilab.org/numderivative.html", fullfile(destdir, "numderivative.html"), follow=%t);
checkFile(filePath, fullfile(destdir, "numderivative.html"), 1000);

filePath = http_get("ftp://ftp.free.fr/pub/Distributions_Linux/debian/README", fullfile(destdir, "README"));
checkFile(filePath, fullfile(destdir, "README"), 10);

filePath = http_get("ftp://ftp.free.fr/pub/Distributions_Linux/debian/README", fullfile(destdir, "README_Debian"));
checkFileAndContent(filePath, fullfile(destdir, "README_Debian"), 10, "Linux");

filePath = http_get("ftp://ftp.free.fr/pub/Distributions_Linux/debian/README", fullfile(destdir, "README"));
checkFileAndContent(filePath, fullfile(destdir, "README"), 10, "Linux");

// HTTPS
filePath = http_get("https://encrypted.google.com", fullfile(destdir, "index.html"));
checkFileAndContent(filePath, fullfile(destdir, "index.html"), 100, "html");

filePath = http_get("https://httpbin.org/basic-auth/user/passwd", fullfile(destdir, "testauth"), auth="user:passwd");
checkFileAndContent(filePath, fullfile(destdir, "testauth"), 10, "authenticated");

// Check returned content
content  = http_get("http://www.scilab.org:80", follow=%t);
checkContent(content, "html");

content  = http_get("https://plop:ae@www.scilab.org:80");
checkContent(content, "html");

content  = http_get("https://www.scilab.org/aze");
checkContent(content, "Dassault");

content  = http_get("https://www.scilab.org");
checkContent(content, "html");

content  = http_get("https://www.scilab.org/");
checkContent(content, "html");

content  = http_get("ftp://ftp.free.fr/pub/Distributions_Linux/debian/README");
checkContent(content, "Linux");

// HTTPS
content = http_get("https://encrypted.google.com");
checkContent(content, "html");

content = http_get("https://httpbin.org/basic-auth/user/passwd", auth="user:passwd");
assert_checkequal(content.authenticated, %t);
assert_checkequal(content.user, "user");

// Badly formatted URL
assert_checkerror("http_get(''https://plop@ae:www.scilab.org:80'');", [], 999);

// Headers
[_, _, headers] = http_get("https://www.google.com/");
assert_checkequal(typeof(headers), "st");
[_, _, headers] = http_get("google.com", follow=%T);
assert_checkequal(typeof(headers), "list");

cd(curdir);
