Welcome to Scilab 2024.1.0
==========================

This file details the changes between Scilab 2024.1.0 (this version), and the previous stable 2023.1.0 release (including information from 2024.0.0).
For changelogs of earlier releases, please see [Scilab 2024.0.0][1].

Summary:

- New features
- Obsolete functions & features
- Removed functions & features
- Installation, Compilation, Packaging, API/ABI changes
- Fixed bugs

Please report anything we could have missed, on the [Scilab Community on Discourse][2] or the [bug tracker][3].

[1]: https://help.scilab.org/docs/2024.0.0/en_US/CHANGES.html
[2]: https://scilab.discourse.group
[3]: https://gitlab.com/scilab/scilab/-/issues

New features
------------

For a high-level description of the main new features of this release, please consult the the "What's new" page of the help, by simply typing `help` in the Scilab console.

In summary, the main new features and additions are:

### Scilab 2024.1.0

#### New functions

- `uiimport()`: GUI facilitating the import data from CSV or TXT file.
- `scilab()` runs another Scilab in interactive or batch mode with command line options.
- `colormap()`: sets and/or gets a figure colormap.
- `bezier()`: computes the points of a Bezier curve using `bernstein()` matrix.
- `princomp()` now returns the variance percentage and the estimated mean of each variable of input.
- [Predefined colormaps][4] function helpers have been added to generate different types of [colormaps][5].

[4]: https://help.scilab.org/predefined_colormaps
[5]: https://help.scilab.org/colormaps

#### Language changes

- New helpers have been added for `arguments` block: `mustBeSquare`, `mustBeEqualDimsOrScalar`.

#### Display

- Type and Dimensions of variables are now displayed in command line output.

#### Performances

- Some Scilab modules (`Statistics`, `Elementary functions`, ...) have been updated to use the `arguments` block hence enhancing their performances.
- Sparse matrix concatenation and product operations have been speedup (See #17183).

#### Web tools

- Headers added as optional output arguments to `http_*` functions.

### Scilab 2024.0.0

#### New functions

- Timeseries introduces a large set of functions and features to simplify the management of timed data and data tables in Scilab.
- `cvode()`, `arkode()`, `ida()` and `kinsol()` from [SUNDIALS](https://computing.llnl.gov/projects/sundials).
- `compress()` and `decompress()` functions manage compressed archives (ZIP, tar.gz and tar.xz files).
- `angle()` computes the argument of complex numbers, in radians.

#### Language changes

- `arguments/end` keywords added: validate function input arguments in a standard way (using standard error messages) and faster than using Scilab code (`type`, `typeof`, ...).
  Some helpers have been added for this new block: `mustBeSameType`, `mustBeEqualDimsOrScalar`, ...
  Some Scilab functions (`modulo`, `pmodulo`, ...) and modules (`time`, ...) have been updated to use this new block hence enhancing their performances.
- `select/case` supports multiple cases with `cells`.
- When calling a function or extracting values, it is possible to skip an output argument. If a variable is named `_` the output value will not be assigned (e.g. `[r1, _, r3,...] = func(...)`).

#### Web tools

- Use `curl` as default in `atomsDownload()` for all OS to handle local file repositories.
- `url_encode()` and `url_decode()` are added.
- Headers added as optional input arguments to `http_*` functions.
- Cookie management added to webtools module.

#### Graphics

- New marker types added for graphic objects:
  - triangles pointing to data: upward, downward, left, right,
  - horizontal line (minus sign) centred on data,
  - vertical line centred on data.
- `errbar()` function uses horizontal line marks.
- `subplot()` manages `frame` uicontrols.

#### Differential equations

- Several features added to `cvode()`, `arkode()`, `ida()` and `kinsol()` through optional arguments (`cvode()` and `ida()` have specific sensitivity features).
- Absolute and relative numerical tolerances added to `intl()` input arguments.

#### Sparse matrices

- [ColPack](https://github.com/CSCsw/ColPack) graph colouring algorithms for sparse Jacobian computation have been integrated.

#### String

- `strsubst()` manages group in replacement.
- `string()` accepts `lists`, `cells` and `structs`.

Obsolete functions or features
------------------------------

### Scilab 2024.1.0

All these functions and features will be removed in Scilab 2026.0.0 (October 2025):

- `dassl()`, `dasrt()` and `daskr()` are now internal functions: Please use `dae()` instead.
- Colormap functions (`autumncolormap()`, `bonecolormap()`, `coolcolormap()`, `coppercolormap()`, `graycolormap()`, `hotcolormap()`, `hsvcolormap()`, `jetcolormap()`, `oceancolormap()`, `parulacolormap()`, `pinkcolormap()`, `rainbowcolormap()`, `springcolormap()`, `summercolormap()`, `whitecolormap()`, `wintercolormap()`) have been renamed without `colormap` suffix, so `autumncolormap()` became `autumn()`, ...
  
### Scilab 2024.0.0

All these functions and features will be removed in Scilab 2025.0.0 (October 2024):

- `splitURL()`: Please use `url_split()` instead.
- `getURL()`: Please use `http_get()` instead.
- `sound()`: Please use `playsnd()` instead.

Removed Functions
-----------------

### Scilab 2024.0.0

The following functions have been removed:

- `dnaupd()`, `dneupd()`, `dsaupd()`, `dseupd()`, `znaupd()`, `zneupd()`, obsolete since Scilab 2023.0.0. Please use `eigs()` instead.
- `plotframe()`, obsolete since Scilab 2023.0.0. Please use `plot2d([], [], 0, "011", " ", [xmin ymin ymax ymax])` instead.
- `svd(X, 0)`, obsolete since Scilab 2023.0.0. Please use `svd(X, "e")` instead.
- `xget('fpf')` and `xset('fpf')`, obsolete since Scilab 2023.0.0. Please use the `fpf` argument of `contour()`, `contourf()` and `contour2d()` instead.

Removed Features
----------------

The following features and usages have been removed or disabled:

- Matlab Sparse datatype has been removed (See #16285).

Compilation
-----------

### Scilab 2024.1.0

- Required version of Flexdock updated to 1.2.5.
- macOS version can now be built using Clang 16 (with some C99 rules enforced) and 10.9 SDK.

### Scilab 2024.0.0

- Required version of Autoconf updated to 2.71 (for Linux aarch64 and macOS Apple M1).
- Required version of Automake updated to 1.16.5 (for Linux aarch64 and macOS Apple M1).
- Required version of JDK updated to Java 17.
- Required version of JoGL updated to 2.5.0.
- Required version of HDF5 updated to 1.10.10.
- Required version of MATIO updated to 1.5.9.
- New dependency: libarchive >= 3.1 (used on `compress` and `decompress` functions).

Packaging & Supported Operating Systems
---------------------------------------

### Scilab 2024.1.0

- Scilab is now supported from macOS 10.13 (High Sierra) to macOS 14 (Sonoma).

### Scilab 2024.0.0

- 32-bit platforms are not supported (no binary versions released).

- Native macOS M1/arm64 build is provided (at least 2 x faster than Intel build using Rosetta emulation).

- Scilab embedded JVM is Java 17 without a memory usage limit. Java heap size limit can still be set in Preferences (General / Java Heap Memory).

- To run or compile Scilab, you might need:
  - Windows (amd64):
    - Windows 11 (Desktop)
    - Windows 10 (Desktop)
    - Windows 8 (Desktop)
  - macOS:
    - Intel-based Mac running macOS 10.9+ (run) and 10.14+ (compile)
    - M1-based Mac running macOS 11+ (run, compile).
  - Linux (amd64):
    - debian:11
    - ubuntu:18.04, 20.04, 22.04, 23.10
    - fedora:38

API/ABI modification
--------------------

### Scilab 2024.1.0

- External toolboxes can use C++14, C++17, C++20 or more recent versions.

### Scilab 2024.0.0

- Javasci source/target version switched from 6 to 7 (minimal version supported by Java 17).
- Windows F2C compiler is no longer used due to its limited COMMON support, please use Intel Fortran Compiler Classic.

License
-------

### Scilab 2024.1.0

- Javasci module license has been changed to BSD to make integration in thirdparty applications easier.

Issue Fixes
-----------

### Scilab 2024.1.0

- [#6218](https://gitlab.com/scilab/scilab/-/issues/6218): `bezier()` function was only available as a demonstration.
- [#10898](https://gitlab.com/scilab/scilab/-/issues/10898): Tests for Scilab used with pipes were missing.
- [#11464](https://gitlab.com/scilab/scilab/-/issues/11464): JVM was not terminated correctly when using `Call_ScilabOpen()`.
- [#12026](https://gitlab.com/scilab/scilab/-/issues/12026): SciNotes now restore files at startup without asking for user confirmation.
- [#13789](https://gitlab.com/scilab/scilab/-/issues/13789): `loadmatfile()` failed loading single precision arrays, they are now loaded as double precision arrays.
- [#14905](https://gitlab.com/scilab/scilab/-/issues/14905): `x_choose_modeless()` made Scilab freeze.
- [#16070](https://gitlab.com/scilab/scilab/-/issues/16070): `feval(0:3,string)` displayed error messages with Chinese characters.
- [#16252](https://gitlab.com/scilab/scilab/-/issues/16252): Description in `wavread.sci` contained erroneous information.
- [#16535](https://gitlab.com/scilab/scilab/-/issues/16535): `host()` and `unix()` functions did not update Scilab `consolebox()` on Windows 10.
- [#16694](https://gitlab.com/scilab/scilab/-/issues/16694): `dassl()`, `dasrt()` and `daskr()` should become internals. As designed for, `dae()` is now the unique gateway.
- [#16880](https://gitlab.com/scilab/scilab/-/issues/16880): `loadXcosLibs()` failed when Coselica toolbox was loaded.
- [#16930](https://gitlab.com/scilab/scilab/-/issues/16930): Error management in `loadmatfile()` needed to be improved.
- [#16959](https://gitlab.com/scilab/scilab/-/issues/16959): `tbx_builder_help()` can now generate a toolbox help even when help pages contain `<images>` tags using this toolbox functions.
- [#17029](https://gitlab.com/scilab/scilab/-/issues/17029): `getfield()` wrongly required an output argument.
- [#17083](https://gitlab.com/scilab/scilab/-/issues/17083): `sci2exp()` failed to handle long lines when the `lmax` parameter was set.
- [#17088](https://gitlab.com/scilab/scilab/-/issues/17088): Scilab CI sometimes failed due to ATOMS write access checks.
- [#17105](https://gitlab.com/scilab/scilab/-/issues/17105): Xcos `TOWS` block failed with an error about `post_xcos_simulate()`.
- [#17121](https://gitlab.com/scilab/scilab/-/issues/17121): Display overload function should not be called with one output argument but with none.
- [#17137](https://gitlab.com/scilab/scilab/-/issues/17137): `strsplit(" $, ", ",")` crashed Scilab.
- [#17139](https://gitlab.com/scilab/scilab/-/issues/17139): Reading a malformed JSON file could make Scilab crash.
- [#17141](https://gitlab.com/scilab/scilab/-/issues/17141): `uiSpreadsheet(<file>)` did not display the CSV file (issue fixed by `uiimport()` integration).
- [#17143](https://gitlab.com/scilab/scilab/-/issues/17143): Function `comet3d()` no more worked in Scilab 2024.0.0.
- [#17144](https://gitlab.com/scilab/scilab/-/issues/17144): An "OpenJDK 64-Bit Server VM" warning was displayed when running Scilab in advanced console.
- [#17145](https://gitlab.com/scilab/scilab/-/issues/17145): CTRL+A in a uicontrol listbox did not update handle properties.
- [#17147](https://gitlab.com/scilab/scilab/-/issues/17147): `regexp()` and `strsubst()` had invalid memory accesses.
- [#17149](https://gitlab.com/scilab/scilab/-/issues/17149): Scilab installation under Windows with a normal user account failed creating Desktop shortcut.
- [#17150](https://gitlab.com/scilab/scilab/-/issues/17150): `SCALE_CSCOPE` block icon was missing in Linux binary versions.
- [#17152](https://gitlab.com/scilab/scilab/-/issues/17152): `clean()` function does not behave according its documentation.
- [#17162](https://gitlab.com/scilab/scilab/-/issues/17162): Calling `subplot()` changed current figure to last figure modified.
- [#17163](https://gitlab.com/scilab/scilab/-/issues/17163): Minor spelling mistakes in Scilab source code fixed.
- [#17164](https://gitlab.com/scilab/scilab/-/issues/17164): Patterns were missing in `.desktop` files under Linux.
- [#17167](https://gitlab.com/scilab/scilab/-/issues/17167): `fullpath()` could miss trailing path separator.
- [#17168](https://gitlab.com/scilab/scilab/-/issues/17168): `subplot()` was broken when `demo_gui()` was opened.
- [#17169](https://gitlab.com/scilab/scilab/-/issues/17169): `File > Execute...` menu now runs file with `-1` mode (no echo).
- [#17170](https://gitlab.com/scilab/scilab/-/issues/17170): `meshgrid()` incorrectly checked its output arguments.
- [#17171](https://gitlab.com/scilab/scilab/-/issues/17171): `file("last", unit)` no more worked since Scilab 2024.0.0.
- [#17173](https://gitlab.com/scilab/scilab/-/issues/17173): `SCALE_CSCOPE` block auto-scalingdid not work.
- [#17175](https://gitlab.com/scilab/scilab/-/issues/17175): Scilab exited with wrong error code in case of syntax error.
- [#17182](https://gitlab.com/scilab/scilab/-/issues/17182): `getd()` behavior when used inside a function had to be clarified.
- [#17183](https://gitlab.com/scilab/scilab/-/issues/17183): Sparse matrix concatenation (and product) was slow.
- [#17185](https://gitlab.com/scilab/scilab/-/issues/17185): Batch launch of Scilab did not work as expected.
- [#17186](https://gitlab.com/scilab/scilab/-/issues/17186): Using an unknown variable in an argument validator made Scilab 2024.0.0 crash.
- [#17194](https://gitlab.com/scilab/scilab/-/issues/17194): `macr2tree()` now returns paired operands on "cc" operator (as on "rc").
- [#17196](https://gitlab.com/scilab/scilab/-/issues/17196): `sci2exp()` returned expressions using `makecell()` instead of using curly braces when input was a cell array.
- [#17197](https://gitlab.com/scilab/scilab/-/issues/17197): `macr2tree()` did not manage extractions correctly.
- [#17198](https://gitlab.com/scilab/scilab/-/issues/17198): Display of cell arrays was broken when having more than 2 dimensions.
- [#17203](https://gitlab.com/scilab/scilab/-/issues/17203): Timeseries `StartTime` was different when doing "extraction and then retime" or "retime and then extraction".
- [#17205](https://gitlab.com/scilab/scilab/-/issues/17205): In GUI mode Scilab exited with exit status 16.
- [#17206](https://gitlab.com/scilab/scilab/-/issues/17206): `SUN_Clink()` failed under Windows.
- [#17207](https://gitlab.com/scilab/scilab/-/issues/17207): SciNotes syntax highlighting failed in some cases and froze Scilab.
- [#17208](https://gitlab.com/scilab/scilab/-/issues/17208): Using `surf()` with "LineStyle" option set to "none" did not draw anything (surface was hidden).
- [#17211](https://gitlab.com/scilab/scilab/-/issues/17211): `int2d()` returned an error when called with 6 input arguments.
- [#17212](https://gitlab.com/scilab/scilab/-/issues/17212): All `FMInterface` block from `fmu-wrapper` contained invalid `model.opar`.
- [#17213](https://gitlab.com/scilab/scilab/-/issues/17213): Resume a `pause` in an overloading function crashed Scilab.
- [#17215](https://gitlab.com/scilab/scilab/-/issues/17215): `h = findobj(searchHandles, ...)` did not work when `searchHandles` was a row vector.
- [#17217](https://gitlab.com/scilab/scilab/-/issues/17217): Calling `impl()` with wrong input size crashed Scilab.
- [#17219](https://gitlab.com/scilab/scilab/-/issues/17219): Scilab crashed when a line of a cell creation was commented out in a script.
- [#17220](https://gitlab.com/scilab/scilab/-/issues/17220): `TMPDIR` was not deleted at Scilab exit on Windows.
- [#17221](https://gitlab.com/scilab/scilab/-/issues/17221): Creation of timeseries from existing variable time and using `synchronize()` did not behave as expected.
- [#17222](https://gitlab.com/scilab/scilab/-/issues/17222): Default option proposed when exporting a variable to CSV was wrong.
- [#17223](https://gitlab.com/scilab/scilab/-/issues/17223): `datetime("now")` lost milliseconds information.
- [#17224](https://gitlab.com/scilab/scilab/-/issues/17224): When used with bounds, `optim()` returned wrong values for `iter` and `evals` output arguments.
- [#17229](https://gitlab.com/scilab/scilab/-/issues/17229): `nanreglin()` failed because of `%nan` and `%inf`values.
- [#17231](https://gitlab.com/scilab/scilab/-/issues/17231): `TCL_EvalFile()` returned a error about BWidget package under Linux.
- [#17233](https://gitlab.com/scilab/scilab/-/issues/17233): "#RRGGBB" format in `bar()` did not to work properly.
- [#17235](https://gitlab.com/scilab/scilab/-/issues/17235): `tbx_build_help_loader()` returned an error about an undefined variable.
- [#17236](https://gitlab.com/scilab/scilab/-/issues/17236): Build of Scilab with `-Werror=implicit-function-declaration` has been fixed.
- [#17237](https://gitlab.com/scilab/scilab/-/issues/17237): Display of array ot rationals was broken.
- [#17238](https://gitlab.com/scilab/scilab/-/issues/17238): `{ list() }` could not be displayed.
- [#17244](https://gitlab.com/scilab/scilab/-/issues/17244): `expm()` function returned wrong results for many negative values.
- [#17245](https://gitlab.com/scilab/scilab/-/issues/17245): `schur()` function returned incorrect results when transforming complex-valued matrix pencils.
- [#17248](https://gitlab.com/scilab/scilab/-/issues/17248): Display of a `zpk` system failed when having more than a pair of complex zeros.

### Scilab 2024.0.0

- [#6503](https://gitlab.com/scilab/scilab/-/issues/6503): `select/case` now supports grouped cases (e.g. `{1, 2}` matches `1`or `2`.).
- [#8339](https://gitlab.com/scilab/scilab/-/issues/8339): Mac OS X file browser was not working as expected.
- [#9123](https://gitlab.com/scilab/scilab/-/issues/9123): `strsubst()` did not handle group remplacement.
- [#11852](https://gitlab.com/scilab/scilab/-/issues/11852): File Browser did not update when creating a file from SciNotes (Save/Save As).
- [#11951](https://gitlab.com/scilab/scilab/-/issues/11951): Calls to `unzip.exe`, `zip.exe` and `gzip.exe` have been replaced by new `compress` and `decompress` functions.
- [#11979](https://gitlab.com/scilab/scilab/-/issues/11979): `csvTextScan()` returned unexpected results with blank space separators.
- [#12280](https://gitlab.com/scilab/scilab/-/issues/12280): `atomsExtract()` (`unzip` & `untar`) features are now available in other functions using new `compress` and `decompress` functions.
- [#13579](https://gitlab.com/scilab/scilab/-/issues/13579): `bar()` and `barh()` no more display useless and annoying warnings about data transpose.
- [#13601](https://gitlab.com/scilab/scilab/-/issues/13601): New `angle()` function has been added for calculating the argument (angle) for a complex number.
- [#13841](https://gitlab.com/scilab/scilab/-/issues/13841): `toolbox_skeleton` no more contains a version requirement (considering it is given for the current Scilab version).
- [#14037](https://gitlab.com/scilab/scilab/-/issues/14037): `light()` made graphics very unstable (`java.lang.NullPointerException`).
- [#14053](https://gitlab.com/scilab/scilab/-/issues/14053): Display of cell arrays with scalar components had regressed compared to Scilab 5.x.
- [#14068](https://gitlab.com/scilab/scilab/-/issues/14068): SciNotes not more backuped files on closing.
- [#14760](https://gitlab.com/scilab/scilab/-/issues/14760): `writeb()`, `write4b()`, `readb()` and `read4b()` functions documentation has been removed (functions were removed in Scilab 6.0.0).
- [#14797](https://gitlab.com/scilab/scilab/-/issues/14797): Tooltip no more worked for `edit` style uicontrols.
- [#14963](https://gitlab.com/scilab/scilab/-/issues/14963): Interrupting or abort execution of an uicontrol callback was not possible.
- [#15074](https://gitlab.com/scilab/scilab/-/issues/15074): There was a memory leak in figure `colormap` property management (also occuring in `addcolor()` and `color()`).
- [#15328](https://gitlab.com/scilab/scilab/-/issues/15328): Scilab is now compiled using JDK 17 and run with JRE 17.
- [#15568](https://gitlab.com/scilab/scilab/-/issues/15568): `savematfile()` did not support `boolean`/`logical` variables with version greater than 4.
- [#15570](https://gitlab.com/scilab/scilab/-/issues/15570): `savematfile()` and `loadmatfile()` corrupted UTF-8 character strings.
- [#15574](https://gitlab.com/scilab/scilab/-/issues/15574): `loadmatfile()` loaded logical arrays as `uint8` instead of as `booleans`.
- [#15727](https://gitlab.com/scilab/scilab/-/issues/15727): `savematfile()` returned an error when used with cells or structures including some `booleans`.
- [#15730](https://gitlab.com/scilab/scilab/-/issues/15730): `matfile_listvar()` and `loadmatfile()` crashed Scilab when the file contains some structure saved in version lesser than 7.3.
- [#15767](https://gitlab.com/scilab/scilab/-/issues/15767): `test_run("cacsd", "bug_13359")` randomly failed (graphics related issues).
- [#15790](https://gitlab.com/scilab/scilab/-/issues/15790): The label of a datatip customized with `polyline.display_function` and created in a batch session opened with the `-quit` option was not rendered.
- [#15837](https://gitlab.com/scilab/scilab/-/issues/15837): It was not possible to get reliable big integers (`int64`, `uint64`) from literal inputs.
- [#16256](https://gitlab.com/scilab/scilab/-/issues/16256): `loadmatfile()` trimmed the value of a character string in a structure field to its first character with version greater than 6.
- [#16285](https://gitlab.com/scilab/scilab/-/issues/16285): `Matlab sparse` type (7) has been removed (was almost not used).
- [#16317](https://gitlab.com/scilab/scilab/-/issues/16317): `sci2exp(complex([1 1], [%nan %inf]))` was not correctly evaluable.
- [#16333](https://gitlab.com/scilab/scilab/-/issues/16333): `tree_show(Xcos_diagram)` crashed Scilab.
- [#16367](https://gitlab.com/scilab/scilab/-/issues/16367): `http_get()` did not work with long filenames.
- [#16533](https://gitlab.com/scilab/scilab/-/issues/16533): A `javax.media.opengl.GLException: Caught GLException: Not a GL2 implementation` exception sometimes occured in Xcos.
- [#16544](https://gitlab.com/scilab/scilab/-/issues/16544): On some platforms, plotting failed with Java messages.
- [#16595](https://gitlab.com/scilab/scilab/-/issues/16595): `string(macro)` and `tree2code()` returned wrong code for multiline arrays including some comments.
- [#16642](https://gitlab.com/scilab/scilab/-/issues/16642): `$` failed when defining an empty variable using `x=[], x(1:$)=1` and left `x` unchanged.
- [#16700](https://gitlab.com/scilab/scilab/-/issues/16700): `scifunc_block_m` block behavior changed since Scilab 6.0.0 (Scilab 5.x behavior restored).
- [#16736](https://gitlab.com/scilab/scilab/-/issues/16736): `xcosDiagramToScilab()` was deeply unstable and crashed Scilab.
- [#16753](https://gitlab.com/scilab/scilab/-/issues/16753): Xcos block `block.z` and `block.oz` variables could not be updated at simulation flag `2`.
- [#16759](https://gitlab.com/scilab/scilab/-/issues/16759): Scilab could not be build with HDF5 1.10.7 under Debian.
- [#16772](https://gitlab.com/scilab/scilab/-/issues/16772): Datatip failed when the related curve was on overlaping axes or child of a `frame` uicontrol.
- [#16857](https://gitlab.com/scilab/scilab/-/issues/16857): The colon operator in `start:step:stop` sometimes exceeded the stop limit.
- [#16894](https://gitlab.com/scilab/scilab/-/issues/16894): File Browser did not refresh after a `deletefile()` instruction.
- [#16931](https://gitlab.com/scilab/scilab/-/issues/16931): States were not accessible in Xcos blocks defined as Scilab functions.
- [#16935](https://gitlab.com/scilab/scilab/-/issues/16935): Variable was sometimes modified after a call to a graphics function.
- [#16938](https://gitlab.com/scilab/scilab/-/issues/16938): `slint()` is now applicable to any file extension.
- [#16940](https://gitlab.com/scilab/scilab/-/issues/16940): `string()` output was broken for structs, lists or cells.
- [#16947](https://gitlab.com/scilab/scilab/-/issues/16947): `NOR_Gate.zcos` Xcos demonstration failed to simulate.
- [#16950](https://gitlab.com/scilab/scilab/-/issues/16950): `tree_show()` now manages visualization of heterogenous object leaves.
- [#16973](https://gitlab.com/scilab/scilab/-/issues/16973): New `urlencode()` & `urldecode()` functions have been added.
- [#16974](https://gitlab.com/scilab/scilab/-/issues/16974): `scilab_macros.txt` and `scilab_primitives.txt` files contents are now sorted and files are no more part of Scilab source tree.
- [#17003](https://gitlab.com/scilab/scilab/-/issues/17003): `slint()` now focuses on code maintenance and actual errors by default (instead of on code style).
- [#17004](https://gitlab.com/scilab/scilab/-/issues/17004): `L = list(mode, lines), L(2)()` returned an error instead of running `lines()`.
- [#17009](https://gitlab.com/scilab/scilab/-/issues/17009): Legacy API help pages have been removed (these functions must no more be used).
- [#17040](https://gitlab.com/scilab/scilab/-/issues/17040): Scilab is now build and run using Java 17 on Windows.
- [#17043](https://gitlab.com/scilab/scilab/-/issues/17043): Stacktrace sometimes reported a `macro` as a `builtin` and failed to report the erroneous line.
- [#17044](https://gitlab.com/scilab/scilab/-/issues/17044): `test_run("ast", "bug_15701")` failed on new macOS build.
- [#17050](https://gitlab.com/scilab/scilab/-/issues/17050): Clang compilation on macOS was broken (due to removed C++11 `std::unary_function` and `std::binary_function`).
- [#17052](https://gitlab.com/scilab/scilab/-/issues/17052): Using JoGL 2.4.0, docking a figure shrank its axes to a tiny size in the lower left corner of the figure.
- [#17053](https://gitlab.com/scilab/scilab/-/issues/17053): `arl2()` documentation example did not work.
- [#17058](https://gitlab.com/scilab/scilab/-/issues/17058): Redirection of <https://help.scilab.org/docs/current/LANG/index.html> was not up-to-date.
- [#17061](https://gitlab.com/scilab/scilab/-/issues/17061): `cdfnor()` crashed Scilab macOS/arm64 build.
- [#17063](https://gitlab.com/scilab/scilab/-/issues/17063): The 16kB limit for the content of `if/for/while/select` was still documented but the limit no longer existed since Scilab 6.0.0.
- [#17067](https://gitlab.com/scilab/scilab/-/issues/17067): `config.sub` was outdated.
- [#17068](https://gitlab.com/scilab/scilab/-/issues/17068): Under macOS, arm64 CPU architecture was wrongly detected during configuration of `ilib_build()`.
- [#17070](https://gitlab.com/scilab/scilab/-/issues/17070): The `xlabel()` web help page contained references to `zlabel()` in its title.
- [#17072](https://gitlab.com/scilab/scilab/-/issues/17072): `http_*()` functions now manage cookies.
- [#17074](https://gitlab.com/scilab/scilab/-/issues/17074): `write()` did not write text-content to the file.
- [#17075](https://gitlab.com/scilab/scilab/-/issues/17075): Scilab sometimes crashed when using complex matrices.
- [#17087](https://gitlab.com/scilab/scilab/-/issues/17087): `SCI/modules/sparse/src/c/lu.c` file did not compile when using recent versions of `clang`.
- [#17094](https://gitlab.com/scilab/scilab/-/issues/17094): `http_get()` was extremely slow when no filename argument was provided.
- [#17095](https://gitlab.com/scilab/scilab/-/issues/17095): Trying to change Scilab language using Preferences GUI did not reflect user selection in GUI.
- [#17100](https://gitlab.com/scilab/scilab/-/issues/17100): Scilab froze when displaying a variable under `pause` mode in ode.
- [#17102](https://gitlab.com/scilab/scilab/-/issues/17102): macOS configure cannot find `iconv` (dependency of `libarchive`.
- [#17106](https://gitlab.com/scilab/scilab/-/issues/17106): Under macOS, "Settings" item menu was not showing.
- [#17107](https://gitlab.com/scilab/scilab/-/issues/17107): C compiler detection failed with error under Windows when no compiler was installed.
- [#17110](https://gitlab.com/scilab/scilab/-/issues/17110): Under macOS, SciNotes save dialog selected parent of current directory as default.
- [#17120](https://gitlab.com/scilab/scilab/-/issues/17120): Display of cells was broken.
- [#17122](https://gitlab.com/scilab/scilab/-/issues/17122): Scilab crashed after `xsave()` on closing specific `bar()` figure.
- [#17127](https://gitlab.com/scilab/scilab/-/issues/17127): The "Acknowledgements" window (in Scilab About Box) was not read-only.
- [#17129](https://gitlab.com/scilab/scilab/-/issues/17129): `checkNamedArguments()` wrongly listed `varargout`.
- [#17130](https://gitlab.com/scilab/scilab/-/issues/17130): File Browser toolbar buttons generated spurious display in console.
