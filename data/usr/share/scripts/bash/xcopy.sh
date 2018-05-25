#!/bin/sh

#xcopy.sh
#2015-11-18

tdir=`pwd`;
srcdir="$1";
dstdir="$2";
flgcp="$3";

if [ "x$srcdir" = "x" -o "x$dstdir" = "x" ]
then
    echo "Usage:"
    echo "$0 srcdir destdir [nc|ln]"
    exit 0
fi

if [ ! -d "$srcdir" ]
then
    echo "Not find source $srcdir!"
    exit 1
fi

if [ ! -d "$dstdir" ]
then
    mkdir -pv "$dstdir"
fi

# tree dirs
find "$srcdir" -xtype d | sort | cpio -padv "$dstdir" ;

# copy file
if [ "x$flgcp" = "x" ]
then
    find "$srcdir" -xtype f | sort | cpio -padv "$dstdir";
elif [ "x$flgcp" = "xln" ]
then
    find "$srcdir" -xtype f -printf "%p\n" | sort | while read tfile
    do
        ln -fv "$tfile" "$dstdir/$tfile"
    done
fi
