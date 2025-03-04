#!/bin/sh

ARCH=$(cc -print-multiarch)

if test $# -eq 0; then
    echo "This script compiles dependencies of Scilab for Linux $ARCH."
    echo
    echo "Syntax : $0 <dependency> with dependency equal to:"
    echo " - 'versions': display versions of dependencies,"
    echo " - 'download': download all dependencies,"
    echo " - 'all': compile all dependencies,"
    echo " - 'binary': configure dev-tools for binary version of Scilab,"
    echo " - 'jar': configure JARs for binary version of Scilab,"
    echo " - 'fromscratch': 'init' + 'download' + 'all' + 'binary',"
    echo " - 'archive': Create prerequirements archive."
    echo
    exit 42
fi

echo "Scilab prerequirements for $ARCH in branch $BRANCH"

INSTALLROOTDIR=$(pwd)/install
INSTALLUSRDIR=$(pwd)/install/usr
DOWNLOADDIR=$(pwd)/downloads
BUILDDIR=$(pwd)/builds
LOGDIR=$(pwd)/$SCI_VERSION_STRING

echo
echo "INSTALLROOTDIR = $INSTALLROOTDIR"
echo "INSTALLUSRDIR  = $INSTALLUSRDIR"
echo "DOWNLOADDIR    = $DOWNLOADDIR"
echo "BUILDDIR       = $BUILDDIR"
echo "LOGDIR         = $LOGDIR"
echo

create_folders() {
    mkdir -p "$INSTALLROOTDIR"
    mkdir -p "$INSTALLROOTDIR/java"
    mkdir -p "$INSTALLROOTDIR/thirdparty"
    mkdir -p "$INSTALLROOTDIR/lib"
    mkdir -p "$INSTALLROOTDIR/lib/thirdparty"
    mkdir -p "$INSTALLROOTDIR/modules"
    mkdir -p "$INSTALLUSRDIR"
    mkdir -p "$INSTALLUSRDIR/lib"
    mkdir -p "$INSTALLUSRDIR/bin"
    mkdir -p "$INSTALLUSRDIR/include"
    mkdir -p "$DOWNLOADDIR"
    mkdir -p "$BUILDDIR"
    mkdir -p "$LOGDIR"
}

export LD_LIBRARY_PATH="/usr/local/lib:$INSTALLUSRDIR/lib:$LD_LIBRARY_PATH"
export PATH="/usr/local/bin:$INSTALLUSRDIR/bin:$PATH"

################################
##### DEPENDENCIES VERSION #####
################################
JDK_VERSION=17.0.7+7
JRE_VERSION=17.0.7_7
ANT_VERSION=1.10.5
OPENBLAS_VERSION=0.3.7
ARPACK_VERSION=3.1.5
CURL_VERSION=7.64.1
EIGEN_VERSION=3.3.2
FFTW_VERSION=3.3.3
HDF5_VERSION=1.10.10
NCURSES_VERSION=6.4
LIBXML2_VERSION=2.9.9
MATIO_VERSION=1.5.9
OPENSSL_VERSION=1.1.1c
PCRE_VERSION=8.38
SUITESPARSE_VERSION=4.4.5
TCL_VERSION=8.5.15
TK_VERSION=8.5.15
BWIDGET_VERSION=1.9.16
ZLIB_VERSION=1.2.11
XZ_VERSION=5.4.4
JOGL_VERSION=2.5.0
OPENXLSX_VERSION=0.3.2
FOP_VERSION=2.0
LIBARCHIVE_VERSION=3.7.1

# Variables used by ant to build Java deps in Java 8
export JAVA_HOME="$BUILDDIR/java/jdk-$JDK_VERSION/"
export ANT_HOME="$INSTALLROOTDIR/java/ant"
export SOURCE_LEVEL=1.8
export TARGET_LEVEL=1.8
export TARGET_RT_JAR="$INSTALLROOTDIR/java/jre/lib/rt.jar"

make_versions() {
    echo "JDK_VERSION           = $JDK_VERSION"
    echo "JRE_VERSION           = $JRE_VERSION"
    echo "ANT_VERSION           = $ANT_VERSION"
    echo "OPENBLAS_VERSION      = $OPENBLAS_VERSION"
    echo "ARPACK_VERSION        = $ARPACK_VERSION"
    echo "CURL_VERSION          = $CURL_VERSION"
    echo "EIGEN_VERSION         = $EIGEN_VERSION"
    echo "FFTW_VERSION          = $FFTW_VERSION"
    echo "HDF5_VERSION          = $HDF5_VERSION"
    echo "NCURSES_VERSION       = $NCURSES_VERSION"
    echo "LIBXML2_VERSION       = $LIBXML2_VERSION"
    echo "MATIO_VERSION         = $MATIO_VERSION"
    echo "OPENSSL_VERSION       = $OPENSSL_VERSION"
    echo "PCRE_VERSION          = $PCRE_VERSION"
    echo "SUITESPARSE_VERSION   = $SUITESPARSE_VERSION"
    echo "TCL_VERSION           = $TCL_VERSION"
    echo "TK_VERSION            = $TK_VERSION"
    echo "BWIDGET_VERSION       = $BWIDGET_VERSION"
    echo "ZLIB_VERSION          = $ZLIB_VERSION"
    echo "XZ_VERSION            = $XZ_VERSION"
    echo "JOGL_VERSION          = $JOGL_VERSION"
    echo "OPENXLSX_VERSION      = $OPENXLSX_VERSION"
    echo "FOP_VERSION           = $FOP_VERSION"
    echo "LIBARCHIVE_VERSION    = $LIBARCHIVE_VERSION"
}

####################
##### DOWNLOAD #####
####################
download_dependencies() {
    cd "$DOWNLOADDIR" || exit 1


    [ ! -f jre-$JRE_VERSION.tar.gz ] && curl -L -o jre-$JRE_VERSION.tar.gz "https://oos.eu-west-2.outscale.com/scilab-releases-dev/prerequirements-sources/OpenJDK17U-jre_x64_linux_hotspot_$(echo ${JRE_VERSION} |sed 's/-//g').tar.gz"
    [ ! -f jdk-$JDK_VERSION.tar.gz ] && curl -L -o jdk-$JDK_VERSION.tar.gz "https://oos.eu-west-2.outscale.com/scilab-releases-dev/prerequirements-sources/ibm-semeru-open-jdk_x64_linux_$(echo ${JDK_VERSION} |sed 's/+/_/g')_openj9-0.38.0.tar.gz"
    
    [ ! -f OpenBLAS-$OPENBLAS_VERSION.tar.gz ] && curl -LO https://oos.eu-west-2.outscale.com/scilab-releases-dev/prerequirements-sources/OpenBLAS-$OPENBLAS_VERSION.tar.gz
    [ ! -f apache-ant-$ANT_VERSION-bin.tar.gz ] && curl -LO https://oos.eu-west-2.outscale.com/scilab-releases-dev/prerequirements-sources/apache-ant-$ANT_VERSION-bin.tar.gz
    [ ! -f arpack-ng-$ARPACK_VERSION.tar.gz ] && curl -LO https://oos.eu-west-2.outscale.com/scilab-releases-dev/prerequirements-sources/arpack-ng-$ARPACK_VERSION.tar.gz
    [ ! -f curl-$CURL_VERSION.tar.gz ] && curl -LO https://oos.eu-west-2.outscale.com/scilab-releases-dev/prerequirements-sources/curl-$CURL_VERSION.tar.gz
    [ ! -f eigen-$EIGEN_VERSION.tar.gz ] && curl -LO https://oos.eu-west-2.outscale.com/scilab-releases-dev/prerequirements-sources/eigen-$EIGEN_VERSION.tar.gz
    [ ! -f fftw-$FFTW_VERSION.tar.gz ] && curl -LO https://oos.eu-west-2.outscale.com/scilab-releases-dev/prerequirements-sources/fftw-$FFTW_VERSION.tar.gz
    [ ! -f hdf5-$HDF5_VERSION.tar.gz ] && curl -LO https://oos.eu-west-2.outscale.com/scilab-releases-dev/prerequirements-sources/hdf5-$HDF5_VERSION.tar.gz
    [ ! -f libxml2-$LIBXML2_VERSION.tar.gz ] && curl -LO https://oos.eu-west-2.outscale.com/scilab-releases-dev/prerequirements-sources/libxml2-$LIBXML2_VERSION.tar.gz
    [ ! -f matio-$MATIO_VERSION.tar.gz ] && curl -LO https://oos.eu-west-2.outscale.com/scilab-releases-dev/prerequirements-sources/matio-$MATIO_VERSION.tar.gz
    [ ! -f openssl-$OPENSSL_VERSION.tar.gz ] && curl -LO https://oos.eu-west-2.outscale.com/scilab-releases-dev/prerequirements-sources/openssl-$OPENSSL_VERSION.tar.gz
    [ ! -f SuiteSparse-$SUITESPARSE_VERSION.tar.gz ] && curl -LO https://oos.eu-west-2.outscale.com/scilab-releases-dev/prerequirements-sources/SuiteSparse-$SUITESPARSE_VERSION.tar.gz
    [ ! -f pcre-$PCRE_VERSION.tar.gz ] && curl -LO https://oos.eu-west-2.outscale.com/scilab-releases-dev/prerequirements-sources/pcre-$PCRE_VERSION.tar.gz
    [ ! -f ncurses-$NCURSES_VERSION.tar.gz ] && curl -LO https://oos.eu-west-2.outscale.com/scilab-releases-dev/prerequirements-sources/ncurses-$NCURSES_VERSION.tar.gz
    [ ! -f tcl$TCL_VERSION-src.tar.gz ] && curl -LO https://oos.eu-west-2.outscale.com/scilab-releases-dev/prerequirements-sources/tcl$TCL_VERSION-src.tar.gz
    [ ! -f tk$TK_VERSION-src.tar.gz ] && curl -LO https://oos.eu-west-2.outscale.com/scilab-releases-dev/prerequirements-sources/tk$TK_VERSION-src.tar.gz
    [ ! -f bwidget-$BWIDGET_VERSION.tar.gz ] && curl -LO https://oos.eu-west-2.outscale.com/scilab-releases-dev/prerequirements-sources/bwidget-$BWIDGET_VERSION.tar.gz
    [ ! -f zlib-$ZLIB_VERSION.tar.gz ] && curl -LO https://oos.eu-west-2.outscale.com/scilab-releases-dev/prerequirements-sources/zlib-$ZLIB_VERSION.tar.gz
    [ ! -f xz-$XZ_VERSION.tar.gz ] && curl -LO https://oos.eu-west-2.outscale.com/scilab-releases-dev/prerequirements-sources/xz-$XZ_VERSION.tar.gz
    
    [ ! -f gluegen-v$JOGL_VERSION.tar.xz ] && curl -LO https://oos.eu-west-2.outscale.com/scilab-releases-dev/prerequirements-sources/gluegen-v$JOGL_VERSION.tar.xz
    [ ! -f jcpp-v$JOGL_VERSION.tar.xz ] && curl -LO https://oos.eu-west-2.outscale.com/scilab-releases-dev/prerequirements-sources/jcpp-v$JOGL_VERSION.tar.xz
    [ ! -f jogl-v$JOGL_VERSION.tar.xz ] && curl -LO https://oos.eu-west-2.outscale.com/scilab-releases-dev/prerequirements-sources/jogl-v$JOGL_VERSION.tar.xz

    [ ! -f OpenXLSX-$OPENXLSX_VERSION.tar.gz ] && curl -LO https://oos.eu-west-2.outscale.com/scilab-releases-dev/prerequirements-sources/OpenXLSX-$OPENXLSX_VERSION.tar.gz

    # xmlgraphics-commons is included within FOP
    # Batik is included within FOP
    [ ! -f fop-$FOP_VERSION-bin.zip ] && curl -LO https://oos.eu-west-2.outscale.com/scilab-releases-dev/prerequirements-sources/fop-$FOP_VERSION-bin.zip

    # This archive contains .jar and directories that have been copied from Scilab prerequirements
    # JavaFX/openjfx is only shipped as JARs, no rebuild is needed for now
    curl -L --time-cond thirdparty-jar.zip -o thirdparty-jar.zip https://oos.eu-west-2.outscale.com/scilab-releases-dev/prerequirements-sources/thirdparty-jar-${BRANCH}.zip
    if ! unzip -t "thirdparty-jar.zip"; then
        # fallback to the default branch
        curl -L --time-cond thirdparty-jar.zip -o thirdparty-jar.zip https://oos.eu-west-2.outscale.com/scilab-releases-dev/prerequirements-sources/thirdparty-jar-${CI_DEFAULT_BRANCH}.zip
    fi

    [ ! -f libarchive-$LIBARCHIVE_VERSION.tar.xz ] && curl -LO https://oos.eu-west-2.outscale.com/scilab-releases-dev/prerequirements-sources/libarchive-$LIBARCHIVE_VERSION.tar.xz

    true;
}

make_all() {
    build_openjdk
    build_ant
    build_gluegen
    build_jogl
    build_openblas
    build_eigen
    build_zlib
    build_lzma
    build_hdf5
    build_pcre
    build_fftw
    build_libxml2
    build_arpack
    build_suitesparse
    build_tcl
    build_tk
    build_matio
    build_openssl
    build_curl
    build_ncurses
    build_openxlsx
    build_libarchive
}

make_binary_directory() {
    cd "$INSTALLROOTDIR" || exit 1

    ########################
    ##### TCL/TK stuff #####
    ########################
    TCL_DIR=$INSTALLROOTDIR/modules/tclsci/tcl/
    [ -d "$TCL_DIR/BWidget" ] && rm -fr "$TCL_DIR/BWidget"
    mkdir -p "$TCL_DIR/BWidget"
    tar -xzf "$DOWNLOADDIR/bwidget-$BWIDGET_VERSION.tar.gz" \
        -C "$TCL_DIR/BWidget" \
        --strip-components=1 \
        --exclude=demo \
        bwidget-$BWIDGET_VERSION/images bwidget-$BWIDGET_VERSION/lang --wildcards bwidget-$BWIDGET_VERSION/*.tcl
    # fix permissions to fix issue #17231
    chmod 644 $(find "$TCL_DIR/BWidget" -type f)
    chmod 755 $(find "$TCL_DIR/BWidget" -type d)

    #################
    ##### EIGEN #####
    #################
    mkdir -p "$INSTALLROOTDIR/lib/Eigen/include/"
    cp -R "$INSTALLUSRDIR/include/Eigen/" "$INSTALLROOTDIR/lib/Eigen/include/"

    #####################################
    ##### lib/thirdparty/ directory #####
    #####################################

    LIBTHIRDPARTYDIR=$INSTALLROOTDIR/lib/thirdparty
    mkdir -p "$LIBTHIRDPARTYDIR"

    # Provide OpenBLAS blas and lapack
    # ensure that ld.so always load the same "real" file to reduce overhead
    rm -f "$LIBTHIRDPARTYDIR"/libatlas.*
    rm -f "$LIBTHIRDPARTYDIR"/lib*blas.*
    rm -f "$LIBTHIRDPARTYDIR"/liblapack.*
    mv "$INSTALLUSRDIR"/lib/libopenblas.so* "$LIBTHIRDPARTYDIR/"
    ln -fs libopenblas.so.$OPENBLAS_VERSION "$LIBTHIRDPARTYDIR/libblas.so.3"
    ln -fs libopenblas.so.$OPENBLAS_VERSION "$LIBTHIRDPARTYDIR/liblapack.so.3"

    rm -f "$LIBTHIRDPARTYDIR"/libarpack.*
    cp -d "$INSTALLUSRDIR"/lib/libarpack.* "$LIBTHIRDPARTYDIR/"

    rm -f "$LIBTHIRDPARTYDIR"/libcrypto.*
    cp -d "$INSTALLUSRDIR"/lib/libcrypto.* "$LIBTHIRDPARTYDIR/"

    rm -f "$LIBTHIRDPARTYDIR"/libcurl.*
    cp -d "$INSTALLUSRDIR"/lib/libcurl.* "$LIBTHIRDPARTYDIR/"

    rm -f "$LIBTHIRDPARTYDIR"/libarchive.*
    cp -d "$INSTALLUSRDIR"/lib/libarchive.* "$LIBTHIRDPARTYDIR/"

    rm -f "$LIBTHIRDPARTYDIR"/libfftw3.*
    cp -d "$INSTALLUSRDIR"/lib/libfftw3.* "$LIBTHIRDPARTYDIR/"

    rm -f "$LIBTHIRDPARTYDIR"/libhdf5_hl.*
    cp -d "$INSTALLUSRDIR"/lib/libhdf5_hl.* "$LIBTHIRDPARTYDIR/"

    rm -f "$LIBTHIRDPARTYDIR"/libhdf5.*
    cp -d "$INSTALLUSRDIR"/lib/libhdf5.* "$LIBTHIRDPARTYDIR/"

    rm -f "$LIBTHIRDPARTYDIR"/libhdf5_hl_cpp.*
    cp -d "$INSTALLUSRDIR"/lib/libhdf5_hl_cpp.* "$LIBTHIRDPARTYDIR/"

    rm -f "$LIBTHIRDPARTYDIR"/libhdf5_cpp.*
    cp -d "$INSTALLUSRDIR"/lib/libhdf5_cpp.* "$LIBTHIRDPARTYDIR/"

    rm -f "$LIBTHIRDPARTYDIR"/libmatio.*
    cp -d "$INSTALLUSRDIR"/lib/libmatio.* "$LIBTHIRDPARTYDIR/"

    rm -f "$LIBTHIRDPARTYDIR"/libpcreposix.*
    cp -d "$INSTALLUSRDIR"/lib/libpcreposix.* "$LIBTHIRDPARTYDIR/"

    rm -f "$LIBTHIRDPARTYDIR"/libpcre.*
    cp -d "$INSTALLUSRDIR"/lib/libpcre.* "$LIBTHIRDPARTYDIR/"

    rm -f "$LIBTHIRDPARTYDIR"/libssl.*
    cp -d "$INSTALLUSRDIR"/lib/libssl.* "$LIBTHIRDPARTYDIR/"

    rm -f "$LIBTHIRDPARTYDIR"/libtcl*.*
    cp -d "$INSTALLUSRDIR"/lib/libtcl*.* "$LIBTHIRDPARTYDIR/"

    rm -f "$LIBTHIRDPARTYDIR"/libtk*.*
    cp -d "$INSTALLUSRDIR"/lib/libtk*.* "$LIBTHIRDPARTYDIR/"

    rm -f "$LIBTHIRDPARTYDIR"/libumfpack.*
    cp -d "$INSTALLUSRDIR"/lib/libumfpack.* "$LIBTHIRDPARTYDIR/"
    rm -f "$LIBTHIRDPARTYDIR"/libamd.*
    cp -d "$INSTALLUSRDIR"/lib/libamd.* "$LIBTHIRDPARTYDIR/"
    rm -f "$LIBTHIRDPARTYDIR"/libcholmod.*
    cp -d "$INSTALLUSRDIR"/lib/libcholmod.* "$LIBTHIRDPARTYDIR/"
    rm -f "$LIBTHIRDPARTYDIR"/libcolamd.*
    cp -d "$INSTALLUSRDIR"/lib/libcolamd.* "$LIBTHIRDPARTYDIR/"
    rm -f "$LIBTHIRDPARTYDIR"/libccolamd.*
    cp -d "$INSTALLUSRDIR"/lib/libccolamd.* "$LIBTHIRDPARTYDIR/"
    rm -f "$LIBTHIRDPARTYDIR"/libcamd.*
    cp -d "$INSTALLUSRDIR"/lib/libcamd.* "$LIBTHIRDPARTYDIR/"
    rm -f "$LIBTHIRDPARTYDIR"/libbtf.*
    cp -d "$INSTALLUSRDIR"/lib/libbtf.* "$LIBTHIRDPARTYDIR/"
    rm -f "$LIBTHIRDPARTYDIR"/libklu.*
    cp -d "$INSTALLUSRDIR"/lib/libklu.* "$LIBTHIRDPARTYDIR/"

    rm -f "$LIBTHIRDPARTYDIR"/libOpenXLSX.*
    cp -d "$INSTALLUSRDIR"/lib/libOpenXLSX.* "$LIBTHIRDPARTYDIR/"

    # Scilab dependencies where the system ones are not recent enough to be used.
    #
    # The system dependencies are supposed to be conformant to the latest 
    # Linux Standard Base 5.0.0 ; Scilab requires more recent versions.

    rm -fr "$LIBTHIRDPARTYDIR/redist" && mkdir "$LIBTHIRDPARTYDIR/redist/"

    rm -f "$LIBTHIRDPARTYDIR"/libz.* "$LIBTHIRDPARTYDIR"/libsciz.*
    rm -f "$LIBTHIRDPARTYDIR"/redist/libz.* "$LIBTHIRDPARTYDIR"/redist/libsciz.*
    cp -d "$INSTALLUSRDIR"/lib/libsciz.* "$LIBTHIRDPARTYDIR/redist/"

    rm -f "$LIBTHIRDPARTYDIR"/liblzma.* "$LIBTHIRDPARTYDIR"/libscilzma.*
    rm -f "$LIBTHIRDPARTYDIR"/redist/liblzma.* "$LIBTHIRDPARTYDIR"/redist/libscilzma.*
    cp -d "$INSTALLUSRDIR"/lib/libscilzma.* "$LIBTHIRDPARTYDIR/redist/"

    rm -f "$LIBTHIRDPARTYDIR"/libxml2.* "$LIBTHIRDPARTYDIR"/libscixml2.*
    rm -f "$LIBTHIRDPARTYDIR"/redist/libxml2.* "$LIBTHIRDPARTYDIR"/redist/libscixml2.*
    cp -d "$INSTALLUSRDIR"/lib/libscixml2.* "$LIBTHIRDPARTYDIR/redist/"
    
    rm -f "$LIBTHIRDPARTYDIR"/libncurses.* "$LIBTHIRDPARTYDIR"/libscincurses.*
    rm -f "$LIBTHIRDPARTYDIR"/redist/libncurses.* "$LIBTHIRDPARTYDIR"/redist/libscincurses.*
    cp -d "$INSTALLUSRDIR"/lib/libscincurses.so* "$LIBTHIRDPARTYDIR/redist/"

    # GCC libs could be there but are prefixed with "sci" to avoid clashing
    # system libraries static linked into scilab libraries instead.  This
    # avoid compilers (and support libraries) version mismatch between gcc
    # used here and user's gcc (probably more recent)
    cp -d /usr/local/lib/libsciquadmath.so* "$LIBTHIRDPARTYDIR/redist/"
    cp -d /usr/local/lib/libscigfortran.so* "$LIBTHIRDPARTYDIR/redist/"
    cp -d /usr/local/lib/libscigcc_s.so* "$LIBTHIRDPARTYDIR/redist/"
    cp -d /usr/local/lib/libscistdc++.so* "$LIBTHIRDPARTYDIR/redist/"

    cp -d /usr/local/lib/libsciquadmath.so* "$INSTALLUSRDIR/lib/"
    cp -d /usr/local/lib/libscigfortran.so* "$INSTALLUSRDIR/lib/"
    cp -d /usr/local/lib/libscigcc_s.so* "$INSTALLUSRDIR/lib/"
    cp -d /usr/local/lib/libscistdc++.so* "$INSTALLUSRDIR/lib/"

    # In case these libraries are not found on the system.
    #
    # The ".so" is not shipped on purpose for compilers support libraries,
    # the user should build on the reference system.
    # The mandatory libraries are the ones documented in the Linux Standard
    # Base 5.0 .

    # 1. Strip libraries (exporting the debuginfo to another file) to
    # reduce file size and thus startup time
    # 2. remove rpath as LD_LIBRARY_PATH is set on the startup script
    find "$LIBTHIRDPARTYDIR" -name '*.so*' -type f -not -name '*.debug'| while read -r file ;
    do
        objcopy --only-keep-debug "$file" "$file.debug"
        [ -f  "$file.debug" ] && objcopy --strip-debug "$file"
        [ -f  "$file.debug" ] && (objcopy --add-gnu-debuglink="$file.debug" "$file" || true)

        patchelf --remove-rpath "$file"
    done
}

make_jar() {
    # JAR management
    # we usually do not need to recompile JARs and we also re-use major jar 
    # dependencies (shipped into the binary zip)

    JAVATHIRDPARTYDIR=$INSTALLROOTDIR/thirdparty
    mkdir -p "$JAVATHIRDPARTYDIR"

    # XMLGraphics (included in FOP)
    # Batik (included in FOP)
    # FOP
    rm -f "$JAVATHIRDPARTYDIR/fop-*" 
    rm -fr fop-$FOP_VERSION
    unzip "$DOWNLOADDIR/fop-$FOP_VERSION-bin.zip" fop-$FOP_VERSION/build/*.jar fop-$FOP_VERSION/lib/*.jar
    rm -f "$JAVATHIRDPARTYDIR"/fop* 
    cp -a fop-$FOP_VERSION/build/fop.jar "$JAVATHIRDPARTYDIR/" 
    rm -f "$JAVATHIRDPARTYDIR/avalon-framework*" 
    cp -a fop-$FOP_VERSION/lib/avalon-framework-*.jar "$JAVATHIRDPARTYDIR/avalon-framework.jar" 
    rm -f "$JAVATHIRDPARTYDIR/batik-*" 
    cp -a fop-$FOP_VERSION/lib/batik-all-*.jar "$JAVATHIRDPARTYDIR/batik-all.jar" 
    rm -f "$JAVATHIRDPARTYDIR/commons-io-*" 
    cp -a fop-$FOP_VERSION/lib/commons-io-*.jar "$JAVATHIRDPARTYDIR/commons-io.jar" 
    rm -f "$JAVATHIRDPARTYDIR/commons-logging-*" 
    cp -a fop-$FOP_VERSION/lib/commons-logging-*.jar "$JAVATHIRDPARTYDIR/commons-logging.jar" 
    rm -f "$JAVATHIRDPARTYDIR/fontbox-*" 
    cp -a fop-$FOP_VERSION/lib/fontbox-*.jar "$JAVATHIRDPARTYDIR/fontbox.jar" 
    rm -f "$JAVATHIRDPARTYDIR/xml-apis-ext-*" 
    cp -a fop-$FOP_VERSION/lib/xml-apis-ext*.jar "$JAVATHIRDPARTYDIR/xml-apis-ext.jar" 
    rm -f "$JAVATHIRDPARTYDIR/xml-apis-1*" 
    cp -a fop-$FOP_VERSION/lib/xml-apis-1*.jar "$JAVATHIRDPARTYDIR/xml-apis.jar" 
    rm -f "$JAVATHIRDPARTYDIR/xmlgraphics-commons*" 
    cp -a fop-$FOP_VERSION/lib/xmlgraphics-commons-*.jar "$JAVATHIRDPARTYDIR/xmlgraphics-commons.jar" 
    rm -fr fop-$FOP_VERSION

    # copy .jar from scilab prerequirements
    cd "$DOWNLOADDIR" || exit 1
    rm -rf thirdparty-jar
    mkdir thirdparty-jar
    cd thirdparty-jar || exit 1
    unzip "$DOWNLOADDIR/thirdparty-jar.zip"
    # remove .jar already managed
    rm xml* fontbox* commons* batik* avalon* fop.jar gluegen2-rt.jar jogl2.jar gluegen-rt.jar jogl-all.jar
    # Copy all JARs from thirdparty-jar.zip
    cp -a ./* "$JAVATHIRDPARTYDIR"
    # Copy flexdock to be sure prerequirements archive will be regenerated when flexdock version changes
    # TODO: add all JARs below and remove global copy using ./*
    cp -a flexdock-1.2.5.jar "$JAVATHIRDPARTYDIR/flexdock-1.2.5.jar"
}

make_archive() {
    make_versions > "$INSTALLROOTDIR/version.txt"

    cd "$INSTALLROOTDIR/.." || exit 1
    echo "Creating archive..."

    export XZ_OPT="-9T0"
    tar -cJf "prerequirements-${SCI_VERSION_STRING}.bin.${ARCH}.tar.xz" -C "$INSTALLROOTDIR" \
        -- java lib modules thirdparty usr version.txt
}

####################
##### BUILDERS #####
####################

build_openblas() {
    cd "$BUILDDIR" || exit 1

    tar -xzf "$DOWNLOADDIR/OpenBLAS-$OPENBLAS_VERSION.tar.gz"
    cd OpenBLAS-$OPENBLAS_VERSION || exit 1
    make "-j$(nproc)" TARGET=NEHALEM

    # install openblas for runtime usage
    cp -a libopenblas_nehalemp-r$OPENBLAS_VERSION.so "$INSTALLUSRDIR/lib/libopenblas.so.$OPENBLAS_VERSION"

    # BLAS and LAPACK libs
    # TODO: only export BLAS / LAPACK ABI
    cp -a "$INSTALLUSRDIR/lib/libopenblas.so.$OPENBLAS_VERSION" "$INSTALLUSRDIR/lib/libblas.so.3"
    patchelf --set-soname libblas.so.3 "$INSTALLUSRDIR/lib/libblas.so.3"
    cp -a "$INSTALLUSRDIR/lib/libopenblas.so.$OPENBLAS_VERSION" "$INSTALLUSRDIR/lib/liblapack.so.3"
    patchelf --set-soname liblapack.so.3 "$INSTALLUSRDIR/lib/liblapack.so.3"
    cd "$INSTALLUSRDIR/lib" || exit 1
    ln -fs libblas.so.3 libblas.so
    ln -fs liblapack.so.3 liblapack.so
}

build_openjdk() {
    [ -e "$BUILDDIR/java" ] && rm -fr "$BUILDDIR/java"
    [ -d "$INSTALLROOTDIR/java/jdk-$JDK_VERSION-jre" ] && rm -fr "$INSTALLROOTDIR/java/jdk-$JDK_VERSION-jre"
    [ -e "$INSTALLROOTDIR/java/jre" ] && rm -fr "$INSTALLROOTDIR/java/jre"

    mkdir -p "$BUILDDIR/java/"
    cd "$BUILDDIR/java/" || exit 1
    tar -xzf "$DOWNLOADDIR/jdk-$JDK_VERSION.tar.gz" # Needed to build other dependencies such as JoGL
    tar -xzf "$DOWNLOADDIR/jre-$JRE_VERSION.tar.gz"
    
    cp -a "jdk-$JDK_VERSION-jre" "$INSTALLROOTDIR/java/jdk-$JRE_VERSION-jre"
    ln -s "jdk-$JRE_VERSION-jre" "$INSTALLROOTDIR/java/jre"
}

build_ant() {
    [ -d "$INSTALLROOTDIR/java/ant" ] && rm -fr "$INSTALLROOTDIR/java/ant"
    [ -d "$INSTALLROOTDIR/java/apache-ant-$ANT_VERSION" ] && rm -fr "$INSTALLROOTDIR/java/apache-ant-$ANT_VERSION"

    cd "$INSTALLROOTDIR/java/" || exit 1
    tar -xzf "$DOWNLOADDIR/apache-ant-$ANT_VERSION-bin.tar.gz"
    ln -s apache-ant-$ANT_VERSION ant

    cp -a apache-ant-$ANT_VERSION/etc/checkstyle "$INSTALLROOTDIR/thirdparty/"

    # cleanup folder
    rm -rf "$INSTALLROOTDIR/java/ant/manual"
    rm "$INSTALLROOTDIR"/java/ant/lib/*.pom
}

build_arpack() {
    cd "$BUILDDIR" || exit 1

    INSTALL_DIR=$BUILDDIR/arpack-ng-$ARPACK_VERSION/install_dir

    tar -xzf "$DOWNLOADDIR/arpack-ng-$ARPACK_VERSION.tar.gz"
    cd arpack-ng-$ARPACK_VERSION || exit 1
    rm -rf "$INSTALL_DIR" && mkdir "$INSTALL_DIR"
    ./configure --prefix=  F77=gfortran \
        --with-blas="$INSTALLUSRDIR/lib/libblas.so" \
        --with-lapack="$INSTALLUSRDIR/lib/liblapack.so"
    make "-j$(nproc)"
    make install DESTDIR="$INSTALL_DIR"

    cp -a "$INSTALL_DIR"/lib/libarpack.so* "$INSTALLUSRDIR/lib/"
}

build_eigen() {
    cd "$BUILDDIR" || exit 1

    mkdir -p eigen-$EIGEN_VERSION
    tar -zxf "$DOWNLOADDIR/eigen-$EIGEN_VERSION.tar.gz" --strip-components=1 -C eigen-$EIGEN_VERSION
    cd eigen-$EIGEN_VERSION || exit 1
    rm -fr "$INSTALLUSRDIR/include/Eigen"
    cp -a Eigen "$INSTALLUSRDIR/include/"
}

build_hdf5() {
    cd "$BUILDDIR" || exit 1

    INSTALL_DIR=$BUILDDIR/hdf5-$HDF5_VERSION/install_dir

    tar -xzf "$DOWNLOADDIR/hdf5-$HDF5_VERSION.tar.gz"
    cd hdf5-$HDF5_VERSION || exit 1
    sed -i -e 's|//int i1, i2;|/* int i1, i2; */|' tools/lib/h5diff.c

    mkdir -p build
    cd build || exit 1
    cmake .. -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" \
        -DBUILD_SHARED_LIBS=ON \
        -DHDF5_BUILD_CPP_LIB=ON \
        -DHDF5_BUILD_HL_LIB=ON
    cmake --build . --parallel --target install

    cp -a "$INSTALL_DIR"/lib/*.so* "$INSTALLUSRDIR/lib/"
    cp -a "$INSTALL_DIR"/include/* "$INSTALLUSRDIR/include/"
}

build_fftw() {
    cd "$BUILDDIR" || exit 1

    INSTALL_DIR=$BUILDDIR/fftw-$FFTW_VERSION/install_dir

    tar -xzf "$DOWNLOADDIR/fftw-$FFTW_VERSION.tar.gz"
    cd fftw-$FFTW_VERSION || exit 1
    ./configure --enable-shared --prefix=
    make "-j$(nproc)"
    make install DESTDIR="$INSTALL_DIR"

    cp -a "$INSTALL_DIR"/lib/*.so* "$INSTALLUSRDIR/lib/"
    cp -a "$INSTALL_DIR"/include/* "$INSTALLUSRDIR/include/"
}

build_zlib() {
    cd "$BUILDDIR" || exit 1

    INSTALL_DIR=$BUILDDIR/zlib-$ZLIB_VERSION/install_dir

    tar -xzf "$DOWNLOADDIR/zlib-$ZLIB_VERSION.tar.gz"
    cd zlib-$ZLIB_VERSION || exit 1
    ./configure --prefix=
    make "-j$(nproc)"
    make install DESTDIR="$INSTALL_DIR"

    cp -a "$INSTALL_DIR"/include/* "$INSTALLUSRDIR/include/"

    # Rename libz to scilibz
    cp "$INSTALL_DIR/lib/libz.so.$ZLIB_VERSION" "$INSTALLUSRDIR/lib/libsciz.so.$ZLIB_VERSION"
    cd "$INSTALLUSRDIR/lib" || exit 1
    ln -sf libsciz.so.$ZLIB_VERSION libz.so
    ln -sf libsciz.so.$ZLIB_VERSION libsciz.so.1
    ln -sf libsciz.so.1 libsciz.so
    patchelf --set-soname libsciz.so.1 libsciz.so.$ZLIB_VERSION
}

build_lzma() {
    cd "$BUILDDIR" || exit 1

    INSTALL_DIR=$BUILDDIR/xz-$XZ_VERSION/install_dir

    tar -xzf "$DOWNLOADDIR/xz-$XZ_VERSION.tar.gz"
    cd "xz-$XZ_VERSION" || exit 1
    ./configure --prefix=
    make "-j$(nproc)"
    make install DESTDIR="$INSTALL_DIR"

    cp -a "$INSTALL_DIR"/include/* "$INSTALLUSRDIR/include/"

    # Rename liblzma to sciliblzma
    cp "$INSTALL_DIR/lib/liblzma.so.$XZ_VERSION" "$INSTALLUSRDIR/lib/libscilzma.so.$XZ_VERSION"
    cd "$INSTALLUSRDIR/lib" || exit 1
    ln -sf "libscilzma.so.$XZ_VERSION" liblzma.so
    ln -sf "libscilzma.so.$XZ_VERSION" libscilzma.so.1
    ln -sf libscilzma.so.1 libscilzma.so
    patchelf --set-soname libscilzma.so.1 "libscilzma.so.$XZ_VERSION"
}

build_openssl() {
    cd "$BUILDDIR" || exit 1

    INSTALL_DIR=$BUILDDIR/openssl-$OPENSSL_VERSION/install_dir

    tar -xzf "$DOWNLOADDIR/openssl-$OPENSSL_VERSION.tar.gz"
    cd openssl-$OPENSSL_VERSION || exit 1
    ./config shared --prefix="$INSTALL_DIR" --openssldir="$INSTALL_DIR"
    make "-j$(nproc)" depend all
    make install

    # install at the right location
    cp -a "$INSTALL_DIR"/lib/libssl.so* "$INSTALLUSRDIR/lib/"
    cp -a "$INSTALL_DIR"/lib/libcrypto.so* "$INSTALLUSRDIR/lib/"
    cp -a "$INSTALL_DIR"/include/* "$INSTALLUSRDIR/include/"
}


build_tcl() {
    cd "$BUILDDIR" || exit 1

    INSTALL_DIR=$BUILDDIR/tcl$TCL_VERSION/install_dir

    tar -xzf "$DOWNLOADDIR/tcl$TCL_VERSION-src.tar.gz"
    cd tcl$TCL_VERSION/unix || exit 1
    ./configure --prefix=
    make "-j$(nproc)"
    make install DESTDIR="$INSTALL_DIR"

    cp -a "$INSTALL_DIR"/lib/libtcl*.so* "$INSTALLUSRDIR/lib/"
    chmod 755 "$INSTALLUSRDIR"/lib/libtcl*.so*

    cp -a "$INSTALL_DIR"/include/* "$INSTALLUSRDIR/include/"

    TCL_DIR=$INSTALLROOTDIR/modules/tclsci/tcl/
    mkdir -p "$TCL_DIR"
    # install in module
    cp -a "$INSTALL_DIR"/lib/tcl* "$TCL_DIR"
    rm "$TCL_DIR/tclConfig.sh"
    rm -rf "$TCL_DIR/tcl*/tzdata"
    # install in usr/lib
    cp -a "$INSTALL_DIR"/lib/tcl* "$INSTALLUSRDIR/lib/"
    rm "$INSTALLUSRDIR/lib/tclConfig.sh"
    rm -rf "$INSTALLUSRDIR/tcl*/tzdata"
}

build_tk() {
    cd "$BUILDDIR" || exit 1

    INSTALL_DIR=$BUILDDIR/tcl$TCL_VERSION/install_dir

    tar -xzf "$DOWNLOADDIR/tk$TK_VERSION-src.tar.gz"
    cd tk$TK_VERSION/unix || exit 1
    ./configure --prefix=
    make "-j$(nproc)"
    make install DESTDIR="$INSTALL_DIR"

    cp -a "$INSTALL_DIR"/lib/libtk*.so* "$INSTALLUSRDIR/lib/"
    chmod 755 "$INSTALLUSRDIR"/lib/libtk*.so*

    cp -a "$INSTALL_DIR"/include/* "$INSTALLUSRDIR/include/"

    TCL_DIR=$INSTALLROOTDIR/modules/tclsci/tcl/
    mkdir -p "$TCL_DIR"
    # install in module
    cp -a "$INSTALL_DIR"/lib/tk* "$TCL_DIR"
    rm "$TCL_DIR/tkConfig.sh"
    rm -rf "$TCL_DIR/tk8.5/demos/" # See bug #3869
    # install in usr/lib
    cp -a "$INSTALL_DIR"/lib/tk* "$INSTALLUSRDIR/lib/"
    rm "$INSTALLUSRDIR/lib/tkConfig.sh"
    rm -rf "$INSTALLUSRDIR/tk8.5/demos/"
}

build_matio() {
    cd "$BUILDDIR" || exit 1

    INSTALL_DIR=$BUILDDIR/matio-$MATIO_VERSION/install_dir

    rm -rf matio-$MATIO_VERSION
    tar -xzf "$DOWNLOADDIR/matio-$MATIO_VERSION.tar.gz"
    cd matio-$MATIO_VERSION || exit 1

    ./autogen.sh
    ./configure --enable-shared --with-hdf5="$INSTALLUSRDIR" --with-zlib="$INSTALLUSRDIR" --prefix=
    make "-j$(nproc)"
    make install DESTDIR="$INSTALL_DIR"

    cp -a "$INSTALL_DIR"/lib/*.so* "$INSTALLUSRDIR/lib/"
    cp -a "$INSTALL_DIR"/include/* "$INSTALLUSRDIR/include/"
}

build_ncurses() {
    cd "$BUILDDIR" || exit 1

    INSTALL_DIR=$BUILDDIR/ncurses-$NCURSES_VERSION/install_dir

    tar -xzf "$DOWNLOADDIR/ncurses-$NCURSES_VERSION.tar.gz"
    cd ncurses-$NCURSES_VERSION || exit 1
    ./configure --with-shared --without-cxx --with-terminfo-dirs="/etc/terminfo:/lib/terminfo:/usr/share/terminfo:/usr/lib/terminfo" --prefix=
    make "-j$(nproc)"
    make install DESTDIR="$INSTALL_DIR"

    cp -a "$INSTALL_DIR"/include/* "$INSTALLUSRDIR/include/"

    # Rename ncurses to scincurses
    cp "$INSTALL_DIR/lib/libncurses.so.$NCURSES_VERSION" "$INSTALLUSRDIR/lib/libscincurses.so.$NCURSES_VERSION"
    cd "$INSTALLUSRDIR/lib" || exit 1
    ln -sf libscincurses.so.$NCURSES_VERSION libncurses.so
    ln -sf libscincurses.so.$NCURSES_VERSION libscincurses.so.6
    ln -sf libscincurses.so.6 libscincurses.so
    patchelf --set-soname libscincurses.so.6 "$INSTALLUSRDIR/lib/libscincurses.so.$NCURSES_VERSION"
}

build_pcre() {
    cd "$BUILDDIR" || exit 1

    INSTALL_DIR=$BUILDDIR/pcre-$PCRE_VERSION/install_dir

    tar -xzf "$DOWNLOADDIR/pcre-$PCRE_VERSION.tar.gz"
    cd pcre-$PCRE_VERSION || exit 1
    ./configure --enable-utf8 --enable-unicode-properties --prefix=
    make "-j$(nproc)"
    make install DESTDIR="$INSTALL_DIR"

    # shellcheck disable=SC2016
    sed -i -e 's|^prefix=.*|prefix=$( cd -- "$(dirname "$0")" >/dev/null 2>\&1 ; pwd -P )/..|' "$INSTALL_DIR/bin/pcre-config"
    cp "$INSTALL_DIR/bin/pcre-config" "$INSTALLUSRDIR/bin/"

    cp -a "$INSTALL_DIR"/lib/*.so* "$INSTALLUSRDIR/lib/"
    cp -a "$INSTALL_DIR"/include/* "$INSTALLUSRDIR/include/"
}

build_libxml2() {
    cd "$BUILDDIR" || exit 1

    INSTALL_DIR=$BUILDDIR/libxml2-$LIBXML2_VERSION/install_dir

    tar -xzf "$DOWNLOADDIR/libxml2-$LIBXML2_VERSION.tar.gz"
    cd libxml2-$LIBXML2_VERSION || exit 1
    rm -rf "$INSTALL_DIR" && mkdir "$INSTALL_DIR"
    ./configure --without-python --with-zlib="$INSTALLUSRDIR" --without-lzma --prefix=
    make "-j$(nproc)"
    make install DESTDIR="$INSTALL_DIR"

    # shellcheck disable=SC2016
    sed -i -e 's|^prefix=.*|prefix=$( cd -- "$(dirname "$0")" >/dev/null 2>\&1 ; pwd -P )/..|' "$INSTALL_DIR/bin/xml2-config"
    cp "$INSTALL_DIR/bin/xml2-config" "$INSTALLUSRDIR/bin/"
    cp -a "$INSTALL_DIR"/include/* "$INSTALLUSRDIR/include/"

    # Rename xml2 to scixml2
    cp "$INSTALL_DIR/lib/libxml2.so.$LIBXML2_VERSION" "$INSTALLUSRDIR/lib/libscixml2.so.$LIBXML2_VERSION"
    cd "$INSTALLUSRDIR/lib" || exit 1
    ln -sf libscixml2.so.$LIBXML2_VERSION libxml2.so
    ln -sf libscixml2.so.$LIBXML2_VERSION libscixml2.so.2
    ln -sf libscixml2.so.2 libscixml2.so
    ln -sf libscixml2.so.2 libxml2.so
    patchelf --set-soname libscixml2.so.2 libscixml2.so.$LIBXML2_VERSION
}

build_curl() {
    cd "$BUILDDIR" || exit 1

    INSTALL_DIR=$BUILDDIR/curl-$CURL_VERSION/install_dir

    tar -zxf "$DOWNLOADDIR/curl-$CURL_VERSION.tar.gz"
    cd curl-$CURL_VERSION || exit 1
    ./configure \
        --without-ca-bundle --with-ca-fallback \
        --with-ssl="$INSTALLUSRDIR" --without-nss \
        --with-zlib="$INSTALLUSRDIR" \
	    --disable-ldap \
        --prefix= \
        CFLAGS="-O2 -g"
    make "-j$(nproc)"
    make install DESTDIR="$INSTALL_DIR"

    # shellcheck disable=SC2016
    sed -i -e 's|^prefix=.*|prefix=$( cd -- "$(dirname "$0")" >/dev/null 2>\&1 ; pwd -P )/..|' "$INSTALL_DIR/bin/curl-config"
    cp "$INSTALL_DIR/bin/curl-config" "$INSTALLUSRDIR/bin/"

    cp -a "$INSTALL_DIR"/lib/*.so* "$INSTALLUSRDIR/lib/"
    cp -a "$INSTALL_DIR"/include/* "$INSTALLUSRDIR/include/"
}

build_libarchive() {
    cd "$BUILDDIR" || exit 1

    INSTALL_DIR=$BUILDDIR/libarchive-$LIBARCHIVE_VERSION/install_dir

    tar -xf "$DOWNLOADDIR/libarchive-$LIBARCHIVE_VERSION.tar.xz"
    cd libarchive-$LIBARCHIVE_VERSION || exit 1
    
    # this configure does not support passing path, overwrite variables
    saved_CFLAGS="$CFLAGS"
    saved_LDFLAGS="$LDFLAGS"
    CFLAGS="$CFLAGS -I$INSTALLUSRDIR/include -I$INSTALLUSRDIR/include/libxml2"
    LDFLAGS="$LDFLAGS -L$INSTALLUSRDIR/lib"

    ./configure --prefix= \
        --enable-posix-regex-lib=libpcreposix
    make "-j$(nproc)"
    make install DESTDIR="$INSTALL_DIR"

    CFLAGS="$saved_CFLAGS"
    LDFLAGS="$saved_LDFLAGS"

    cp -a "$INSTALL_DIR"/lib/*.so* "$INSTALLUSRDIR/lib/"
    cp -a "$INSTALL_DIR"/include/* "$INSTALLUSRDIR/include/"
}

build_suitesparse() {
    cd "$BUILDDIR" || exit 1

    INSTALL_DIR=$BUILDDIR/SuiteSparse/install_dir
    rm -rf "$INSTALL_DIR"
    mkdir -p "$INSTALL_DIR/lib"
    mkdir -p "$INSTALL_DIR/include"

    tar -zxf "$DOWNLOADDIR/SuiteSparse-$SUITESPARSE_VERSION.tar.gz"
    cd SuiteSparse || exit 1
    sed -i -e 's|^\INSTALL_LIB = .*|\INSTALL_LIB = '"$INSTALL_DIR"'\/lib\/|' SuiteSparse_config/SuiteSparse_config.mk
    sed -i -e 's|^\INSTALL_INCLUDE = .*|\INSTALL_INCLUDE = '"$INSTALL_DIR"'\/include\/|' SuiteSparse_config/SuiteSparse_config.mk
    make "-j$(nproc)" library
    make install

    # cp -a "$INSTALL_DIR"/lib/*.so* "$INSTALLUSRDIR/lib/"
    cp -a "$INSTALL_DIR"/include/* "$INSTALLUSRDIR/include/"

    UMFPACK_VERSION=$(grep -m1 VERSION UMFPACK/Makefile | sed -e "s|\VERSION = ||")

    # See http://slackware.org.uk/slacky/slackware-12.2/development/suitesparse/3.1.0/src/suitesparse.SlackBuild
    # libamd.so
    AMD_VERSION=$(grep -m1 VERSION AMD/Makefile | sed -e "s|\VERSION = ||")
    AMD_MAJOR_VERSION=$(echo "$AMD_VERSION" | awk -F \. '{ print $1}')
    cd AMD/Lib/ || exit 1
    # shellcheck disable=SC2046
    gcc -shared "-Wl,-soname,libamd.so.${AMD_MAJOR_VERSION}" -o "libamd.so.${AMD_VERSION}" $(ls ./*.o)
    rm -f "$INSTALLUSRDIR"/lib/libamd.so*
    cp "libamd.so.${AMD_VERSION}" "$INSTALLUSRDIR/lib/"
    cd ../..

    # libcamd.so
    CAMD_VERSION=$(grep -m1 VERSION CAMD/Makefile | sed -e "s|\VERSION = ||")
    CAMD_MAJOR_VERSION=$(echo "$CAMD_VERSION" | awk -F \. '{print $1}')
    cd CAMD/Lib/ || exit 1
    # shellcheck disable=SC2046
    gcc -shared "-Wl,-soname,libcamd.so.${CAMD_MAJOR_VERSION}" -o "libcamd.so.${CAMD_VERSION}" $(ls ./*.o)
    rm -f "$INSTALLUSRDIR"/lib/libcamd.so*
    cp "libcamd.so.${CAMD_VERSION}" "$INSTALLUSRDIR/lib/"
    cd ../..

    # libcolamd.so
    COLAMD_VERSION=$(grep -m1 VERSION COLAMD/Makefile | sed -e "s|\VERSION = ||")
    COLAMD_MAJOR_VERSION=$(echo "$COLAMD_VERSION" | awk -F \. '{print $1}')
    cd COLAMD/Lib/ || exit 1
    # shellcheck disable=SC2046
    gcc -shared "-Wl,-soname,libcolamd.so.${COLAMD_MAJOR_VERSION}" -o "libcolamd.so.${COLAMD_VERSION}" $(ls ./*.o)
    rm -f "$INSTALLUSRDIR"/lib/libcolamd.so*
    cp "libcolamd.so.${COLAMD_VERSION}" "$INSTALLUSRDIR/lib/"
    cd ../..

    # libccolamd.so
    CCOLAMD_VERSION=$(grep -m1 VERSION CCOLAMD/Makefile | sed -e "s|\VERSION = ||")
    CCOLAMD_MAJOR_VERSION=$(echo "$CCOLAMD_VERSION" | awk -F \. '{print $1}')
    cd CCOLAMD/Lib/ || exit 1
    # shellcheck disable=SC2046
    gcc -shared "-Wl,-soname,libccolamd.so.${CCOLAMD_MAJOR_VERSION}" -o "libccolamd.so.${CCOLAMD_VERSION}" $(ls ./*.o)
    rm -f "$INSTALLUSRDIR"/lib/libccolamd.so*
    cp "libccolamd.so.${CCOLAMD_VERSION}" "$INSTALLUSRDIR/lib/"
    cd ../..

    # libcholmod.so
    CHOLMOD_VERSION=$(grep -m1 VERSION CHOLMOD/Makefile | sed -e "s|\VERSION = ||")
    CHOLMOD_MAJOR_VERSION=$(echo "$CHOLMOD_VERSION" | awk -F \. '{print $1}')
    cd CHOLMOD/Lib/ || exit 1
    # shellcheck disable=SC2046
    gcc -shared "-Wl,-soname,libcholmod.so.${CHOLMOD_MAJOR_VERSION}" -o "libcholmod.so.${CHOLMOD_VERSION}" $(ls ./*.o)
    rm -f "$INSTALLUSRDIR"/lib/libcholmod.so*
    cp "libcholmod.so.${CHOLMOD_VERSION}" "$INSTALLUSRDIR/lib/"
    cd ../..

    # libbtf.so
    BTF_VERSION=$(grep -m1 VERSION BTF/Makefile | sed -e "s|\VERSION = ||")
    BTF_MAJOR_VERSION=$(echo "$BTF_VERSION" | awk -F \. '{print $1}')
    cd BTF/Lib/ || exit 1
    # shellcheck disable=SC2046
    gcc -shared "-Wl,-soname,libbtf.so.${BTF_MAJOR_VERSION}" -o "libbtf.so.${BTF_VERSION}" $(ls ./*.o)
    rm -f "$INSTALLUSRDIR"/lib/libbtf.so*
    cp "libbtf.so.${BTF_VERSION}" "$INSTALLUSRDIR/lib/"
    cd ../..

    # libklu.so
    KLU_VERSION=$(grep -m1 VERSION KLU/Makefile | sed -e "s|\VERSION = ||")
    KLU_MAJOR_VERSION=$(echo "$KLU_VERSION" | awk -F \. '{print $1}')
    cd KLU/Lib/ || exit 1
    # shellcheck disable=SC2046
    gcc -shared "-Wl,-soname,libklu.so.${KLU_MAJOR_VERSION}" -o "libklu.so.${KLU_VERSION}" $(ls ./*.o) \
        "$INSTALLUSRDIR/lib/libamd.so.${AMD_VERSION}" "$INSTALLUSRDIR/lib/libcolamd.so.${COLAMD_VERSION}" \
        "$INSTALLUSRDIR/lib/libbtf.so.${BTF_VERSION}"
    rm -f "$INSTALLUSRDIR"/lib/libklu.so*
    cp "libklu.so.${KLU_VERSION}" "$INSTALLUSRDIR/lib/"
    cd ../..

    # libumfpack.so
    UMFPACK_VERSION=$(grep -m1 VERSION UMFPACK/Makefile | sed -e "s|\VERSION = ||")
    UMFPACK_MAJOR_VERSION=$(echo "$UMFPACK_VERSION" | awk -F \. '{print $1}')
    cd UMFPACK/Lib || exit 1
    # shellcheck disable=SC2046
    gcc -shared "-Wl,-soname,libumfpack.so.${UMFPACK_MAJOR_VERSION}" -o "libumfpack.so.${UMFPACK_VERSION}" $(ls ./*.o) \
      "$INSTALL_DIR/lib/libsuitesparseconfig.a" \
      /usr/local/lib/libscigfortran.so.5 /usr/local/lib/libsciquadmath.so.0 \
      "$INSTALLUSRDIR/lib/libblas.so.3" "$INSTALLUSRDIR/lib/liblapack.so.3" -lm -lrt \
      "$INSTALLUSRDIR/lib/libcholmod.so.${CHOLMOD_VERSION}" "$INSTALLUSRDIR/lib/libcolamd.so.${COLAMD_VERSION}" \
      "$INSTALLUSRDIR/lib/libccolamd.so.${CCOLAMD_VERSION}" "$INSTALLUSRDIR/lib/libcamd.so.${CAMD_VERSION}" \
      "$INSTALLUSRDIR/lib/libbtf.so.${BTF_VERSION}" "$INSTALLUSRDIR/lib/libklu.so.${KLU_VERSION}" \
      "$INSTALLUSRDIR/lib/libamd.so.${AMD_VERSION}"
    rm -f "$INSTALLUSRDIR"/lib/libumfpack.so*
    cp "libumfpack.so.${UMFPACK_VERSION}" "$INSTALLUSRDIR/lib/"
    cd ../..

    cd "$INSTALLUSRDIR/lib/" || exit 1
    ln -fs "libamd.so.${AMD_VERSION}" libamd.so
    ln -fs "libamd.so.${AMD_VERSION}" "libamd.so.${AMD_MAJOR_VERSION}"
    ln -fs "libcamd.so.${CAMD_VERSION}" libcamd.so
    ln -fs "libcamd.so.${CAMD_VERSION}" "libcamd.so.${AMD_MAJOR_VERSION}"
    ln -fs "libcolamd.so.${COLAMD_VERSION}" libcolamd.so
    ln -fs "libcolamd.so.${COLAMD_VERSION}" "libcolamd.so.${COLAMD_MAJOR_VERSION}"
    ln -fs "libccolamd.so.${CCOLAMD_VERSION}" libccolamd.so
    ln -fs "libccolamd.so.${CCOLAMD_VERSION}" "libccolamd.so.${CCOLAMD_MAJOR_VERSION}"
    ln -fs "libcholmod.so.${CHOLMOD_VERSION}" libcholmod.so
    ln -fs "libcholmod.so.${CHOLMOD_VERSION}" "libcholmod.so.${CHOLMOD_MAJOR_VERSION}"
    ln -fs "libbtf.so.${BTF_VERSION}" libbtf.so
    ln -fs "libbtf.so.${BTF_VERSION}" "libbtf.so.${BTF_MAJOR_VERSION}"
    ln -fs "libklu.so.${KLU_VERSION}" libklu.so
    ln -fs "libklu.so.${KLU_VERSION}" "libklu.so.${KLU_MAJOR_VERSION}"
    ln -fs "libumfpack.so.${UMFPACK_VERSION}" libumfpack.so
    ln -fs "libumfpack.so.${UMFPACK_VERSION}" "libumfpack.so.${UMFPACK_MAJOR_VERSION}"
}

build_gluegen() {
    cd "$BUILDDIR" || exit 1

    tar -xJf "$DOWNLOADDIR/gluegen-v$JOGL_VERSION.tar.xz"
    cd gluegen-v$JOGL_VERSION || exit 1
    tar -xJf "$DOWNLOADDIR/jcpp-v$JOGL_VERSION.tar.xz"
    rm -fr jcpp && mv jcpp-v$JOGL_VERSION jcpp

    cd make || exit 1
    "$ANT_HOME/bin/ant"

    cd "$BUILDDIR/gluegen-v$JOGL_VERSION" || exit 1
    cp -a build/obj/libgluegen_rt.so "$INSTALLROOTDIR/lib/thirdparty"
    cp -a build/gluegen-rt.jar "$INSTALLROOTDIR/thirdparty"
}

build_jogl() {
    cd "$BUILDDIR" || exit 1

    tar -xJf "$DOWNLOADDIR/jogl-v$JOGL_VERSION.tar.xz"
    ln -fs gluegen-v$JOGL_VERSION gluegen

    cd jogl-v$JOGL_VERSION/make || exit 1

    "$ANT_HOME/bin/ant"

    cd "$BUILDDIR/jogl-v$JOGL_VERSION" || exit 1
    cp -a -t "$INSTALLROOTDIR/lib/thirdparty" build/lib/libjogl_desktop.so build/lib/libnativewindow_awt.so build/lib/libnativewindow_drm.so build/lib/libnativewindow_x11.so build/lib/libnewt_drm.so build/lib/libnewt_head.so
    cp -a build/jar/jogl-all.jar "$INSTALLROOTDIR/thirdparty"
}

build_openxlsx() {
    cd "$BUILDDIR" || exit 1

    tar -xzf "$DOWNLOADDIR/OpenXLSX-$OPENXLSX_VERSION.tar.gz"
    cd OpenXLSX-$OPENXLSX_VERSION || exit 1

    mkdir -p build
    cd build || exit 1
    cmake ..
    cmake --build . --parallel --target OpenXLSX --config Release

    cd ../
    cp -a OpenXLSX/headers "$INSTALLUSRDIR/include/OpenXLSX"

    cd build/output || exit 1
    gcc -shared -o libOpenXLSX.so \
        -Wl,--whole-archive       \
        libOpenXLSX.a             \
        -Wl,--no-whole-archive

    cp -a libOpenXLSX.so "$INSTALLUSRDIR/lib/"
}

#########################
##### DEFAULT FLAGS #####
#########################
export CFLAGS="-O2 -g"
export CXXFLAGS="-O2 -g"
export FFLAGS="-O2 -g"
export LDFLAGS="-O2 -g"

###############################
##### ARGUMENT MANAGEMENT #####
###############################
while [ $# -gt 0 ]
do
  case "$1" in
    "versions")
        make_versions
        shift
        ;;

    "fromscratch")
        echo "Create prerequirement folder tree"
        rm -rf "$INSTALLROOTDIR"
        create_folders
        echo "Download prerequirements sources"
        download_dependencies > "$LOGDIR/downloads.log" 2>&1 || (tail --lines=100 "$LOGDIR/downloads.log/log"; exit 1)
        echo "Build prerequirements"
        make_all > "$LOGDIR/build_all.log" 2>&1 || (tail --lines=100 "$LOGDIR/build_all.log"; exit 1)
        echo "Create binary"
        make_binary_directory > "$LOGDIR/binary.log" 2>&1 || (tail --lines=100 "$LOGDIR/binary.log"; exit 1)
        echo "Make jar"
        make_jar > "$LOGDIR/jar.log" 2>&1 || (tail --lines=100 "$LOGDIR/jar.log"; exit 1)
        make_archive
        shift
        ;;

    "download")
        create_folders
        download_dependencies
        shift
        ;;

    "binary")
        create_folders
        make_all
        make_binary_directory
        shift
        ;;

    "jar")
        create_folders
        make_jar
        shift
        ;;

    "all")
        create_folders
        make_all
        shift
        ;;

    "archive")
        create_folders
        make_archive
        shift
        ;;
    *)
        create_folders
        eval "build_$1"
        shift
        ;;
  esac
done
