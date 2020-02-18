#!/bin/bash

echo "NO WERROR CRAP"

find -name "configure" -print0 | xargs -0 sed -i 's#GCC_WARN_CFLAGS="$GCC_WARN_CFLAGS -Werror"##g'
find -name "warning.m4" -print0 | xargs -0 sed -i 's#GCC_WARN_CFLAGS="$GCC_WARN_CFLAGS -Werror"##g'

echo "FIX GCC PATCH"
chown root:root "gcc-4.5.1" -R
cd "gcc-4.5.1"
patch -p1 < ../0001-patch-gcc-fix-gnu-inline.patch

echo "FIX / REMOVE TEXI FILES"
find -name "*.texi" -print0 | xargs -0 sed -i 's#@itemx#@item#g'
echo > ./gcc/doc/gcc.texi

cd ..

echo "DONE"
sleep 1

