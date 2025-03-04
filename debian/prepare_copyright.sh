#!/bin/sh

if [ -e debian/copyright.new ]; then rm debian/copyright.new; fi
touch debian/copyright.new

WORKDIR=$PWD
TMPDIR=$(mktemp -d)
cp -a . $TMPDIR
cd $TMPDIR
for dir in $(find scilab/modules -mindepth 1 -maxdepth 1 -type d); do
    rm -rf $dir
done
scan-copyrights > $WORKDIR/debian/copyright.new
cd $WORKDIR
rm -rf $TMPDIR

for dir in $(find scilab/modules -mindepth 1 -maxdepth 1 -type d); do
    (cd $dir; scan-copyrights > ../../../debian/copyright.temp);
    sed -i "s,^\(Files: \),\1$dir/," debian/copyright.temp
    sed -i "s,^ \([0-9a-zA-Z/]*\), $dir/\1," debian/copyright.temp
    cat debian/copyright.temp >> debian/copyright.new
    echo "" >> debian/copyright.new #empty line between sections
    rm debian/copyright.temp
done
