// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Pierre MARECHAL <pierre.marechal@scilab.org>
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- ENGLISH IMPOSED -->
// <-- NO CHECK REF -->

load("SCI/modules/atoms/macros/atoms_internals/lib");
exec("SCI/modules/atoms/tests/unit_tests/atomsTestUtils.sce");

// If previous test did not end properly, restore, else backup config file
atomsRestoreConfig(%T);
atomsSaveConfig();

// Do not use the autoload system
atomsSetConfig("autoloadAddAfterInstall","False");
atomsSetConfig("Verbose" ,"False");

// Force config
atomsSetConfig("autoloadAddAfterInstall", "False");
atomsSetConfig("Verbose", "False");
atomsSetConfig("offLine", "False");
atomsRepositoryReset();

// Load the 1st scenario : See scene10.test.atoms.scilab.org.txt
// =============================================================================
atomsLoadTestScene("scene10");

// Install the toolbox 3
// =============================================================================

atomsInstall("toolbox_3V6");
atomsShow("toolbox_3V6");
atomsRemove("toolbox_3V6");

// Restore original values
// =============================================================================
atomsRestoreConfig(%T);

atomsRepositorySetOfl(mgetl(SCI+"/modules/atoms/tests/unit_tests/repositories.orig"));
