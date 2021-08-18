#!/bin/bash

echo "*******************************************"
echo "This old version of GCC has a bunch of stuff"
echo "that doesn't compile with new GCC versions. "
echo ""

echo -n "NO WERROR"
find -name "configure" -print0 | xargs -0 sed -i 's#GCC_WARN_CFLAGS="$GCC_WARN_CFLAGS -Werror"##g'
find -name "warning.m4" -print0 | xargs -0 sed -i 's#GCC_WARN_CFLAGS="$GCC_WARN_CFLAGS -Werror"##g'
echo "done"

echo -n "USE FCOMMON"
find -name "Makefile.in" -print0 | xargs -0 sed -i 's#CFLAGS = @CFLAGS@#CFLAGS = @CFLAGS@ -fcommon#g'
echo done

echo -n "FIX GCC PATCH ... "
chown root:root "gcc-4.5.1" -R
cd "gcc-4.5.1"
patch -p1 < ../0001-patch-gcc-fix-gnu-inline.patch
echo "done"

echo -n "FIX / REMOVE TEXI FILES ... "
find -name "*.texi" -print0 | xargs -0 sed -i 's#@itemx#@item#g'
echo > ./gcc/doc/gcc.texi
cd ..

echo "done"
echo "Patching done"
echo "*******************************************"

