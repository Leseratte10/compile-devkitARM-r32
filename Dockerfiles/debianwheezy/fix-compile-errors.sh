#!/bin/bash

echo "*******************************************"
echo "This old version of GCC has a bunch of stuff"
echo "that doesn't compile with new GCC versions. "
echo ""

echo -n "NO WERROR ... "
find -name "configure" -print0 | xargs -0 sed -i 's#GCC_WARN_CFLAGS="$GCC_WARN_CFLAGS -Werror"##g'
find -name "warning.m4" -print0 | xargs -0 sed -i 's#GCC_WARN_CFLAGS="$GCC_WARN_CFLAGS -Werror"##g'
echo "done"

echo "Patching done"
echo "*******************************************"

