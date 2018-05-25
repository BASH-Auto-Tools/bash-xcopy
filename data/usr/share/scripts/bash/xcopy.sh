#!/bin/sh

#xcopy.sh
#2018-05-25

echo "XCopy 0.20180525"

tnocomp=""
tcomp="/bin/cpio"
tdeb="cpio_*.deb"
if [ ! -f "$tcomp" ]
then
    tnocomp="$tnocomp $tcomp($tdeb)"
fi
tcomp="/usr/bin/find"
tdeb="findutils_*.deb"
if [ ! -f "$tcomp" ]
then
    tnocomp="$tnocomp $tcomp($tdeb)"
fi
tcomp="/usr/bin/sort"
tdeb="coreutils_*.deb"
if [ ! -f "$tcomp" ]
then
    tnocomp="$tnocomp $tcomp($tdeb)"
fi
tcomp="/bin/ln"
tdeb="coreutils_*.deb"
if [ ! -f "$tcomp" ]
then
    tnocomp="$tnocomp $tcomp($tdeb)"
fi
if [ "x$tnocomp" != "x" ]
then
    echo "Not found $tnocomp !"
    echo ""
    exit 1
fi

fln="false"
fnc="false"
fhlp="false"
while getopts ":lnh" opt
do
    case $opt in
        l) fln="true"
            ;;
        n) fnc="true"
            ;;
        h) fhlp="true"
            ;;
        *) echo "Unknown option -$OPTARG"
            exit 1
            ;;
    esac
done
shift "$(($OPTIND - 1))"
tdir=`pwd`;
srcdir="$1";
dstdir="$2";

if [ "x$srcdir" = "x" -o "x$dstdir" = "x" -o "x$fhlp" = "xtrue" ]
then
    echo "Usage:"
    echo "$0 [options] srcdir destdir"
    echo "Options:"
    echo "    -l    hardlink files"
    echo "    -n    no copy files (only directory)"
    echo "    -h    help"    
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

# copy/link file
if [ "x$fnc" = "xfalse" ]
then
    if [ "x$fln" = "xfalse" ]
    then
        find "$srcdir" -xtype f | sort | cpio -padv "$dstdir";
    else
        find "$srcdir" -xtype f -printf "%p\n" | sort | while read tfile
        do
            ln -fv "$tfile" "$dstdir/$tfile"
        done
    fi
fi
