FROM debian:buster
MAINTAINER Leseratte

# This Dockerfile compiles devkitARM r32 for Linux.

# Update and install a bunch of crap: 
RUN apt-get update -y --force-yes && \
apt-get install -y --force-yes \
make autoconf automake bison flex libreadline-dev libncurses5-dev \
texinfo libgmp3-dev libmpfr-dev libmpc-dev libelf-dev gawk wget \
bzip2 patch zlib1g-dev unzip dos2unix g++

# Download buildscrips (buildscripts-20101023-custom.tar.bz2)
# This is a custom buildscripts archive by Leseratte
# based on the buildscripts commit 4820198744980166675287d29431400345abffe2
# No changes have been made to this archive (directly created from this commit), 
# I just added "custom" to the file name to differenciate it from official 
# devkitPro buildscript archives. 
# If you wanted, you could checkout that particular commit from the git repository
# instead and it would work just fine. 

# Copy the custom build scripts into the container
ADD https://github.com/Leseratte10/compile-devkitARM-r32/releases/download/helpers/buildscripts-20101023-custom.tar.bz2 /

RUN tar -xvf buildscripts-20101023-custom.tar.bz2 

# Download all source code files we need. 
# The Compile script would usually do this automatically, but for some reason that's unreliable. 

ADD https://github.com/Leseratte10/compile-devkitARM-r32/releases/download/helpers/binutils-2.20.1.tar.bz2 /buildscripts/
ADD https://github.com/Leseratte10/compile-devkitARM-r32/releases/download/helpers/gcc-core-4.5.1.tar.bz2 /buildscripts/
ADD https://github.com/Leseratte10/compile-devkitARM-r32/releases/download/helpers/gcc-g++-4.5.1.tar.bz2 /buildscripts/
ADD https://github.com/Leseratte10/compile-devkitARM-r32/releases/download/helpers/gcc-objc-4.5.1.tar.bz2 /buildscripts/
ADD https://github.com/Leseratte10/compile-devkitARM-r32/releases/download/helpers/gdb-7.2.tar.bz2 /buildscripts/
ADD https://github.com/Leseratte10/compile-devkitARM-r32/releases/download/helpers/newlib-1.18.0.tar.gz /buildscripts/
ADD https://github.com/Leseratte10/compile-devkitARM-r32/releases/download/helpers/libfat-src-1.1.0.tar.bz2 /buildscripts/
ADD https://github.com/Leseratte10/compile-devkitARM-r32/releases/download/helpers/libnds-src-1.5.10.tar.bz2 /buildscripts/
ADD https://github.com/Leseratte10/compile-devkitARM-r32/releases/download/helpers/libgba-src-20150106.tar.bz2 /buildscripts/
ADD https://github.com/Leseratte10/compile-devkitARM-r32/releases/download/helpers/dswifi-src-0.3.17.tar.bz2 /buildscripts/
ADD https://github.com/Leseratte10/compile-devkitARM-r32/releases/download/helpers/libmirko-src-0.9.7.tar.bz2 /buildscripts/
ADD https://github.com/Leseratte10/compile-devkitARM-r32/releases/download/helpers/default_arm7-src-0.5.27.tar.bz2 /buildscripts/
ADD https://github.com/Leseratte10/compile-devkitARM-r32/releases/download/helpers/maxmod-src-1.0.9.tar.bz2 /buildscripts/
ADD https://github.com/Leseratte10/compile-devkitARM-r32/releases/download/helpers/libfilesystem-src-0.9.11.tar.bz2 /buildscripts/

RUN echo > /buildscripts/downloaded_sources

# Patch a bunch of library versions in the script. 
# We don't have sources for most of the versions used here so we can't use them, 
# but they aren't really needed anyways, so just pick a similar version
# which we do have sources for. 
# If, at some point, we find sources for the actual versions (which would be
# a lot cleaner) these sed statements can be removed.


RUN cd buildscripts && \
sed -i 's#LIBGBA_VER=20081210#LIBGBA_VER=20150106#g' ./build-devkit.sh && \
sed -i 's#LIBNDS_VER=1.4.8#LIBNDS_VER=1.5.10#g' ./build-devkit.sh && \
sed -i 's#DEFAULT_ARM7_VER=0.5.17#DEFAULT_ARM7_VER=0.5.27#g' ./build-devkit.sh && \
sed -i 's#DSWIFI_VER=0.3.13#DSWIFI_VER=0.3.17#g' ./build-devkit.sh && \
sed -i 's#MAXMOD_VER=1.0.6#MAXMOD_VER=1.0.9#g' ./build-devkit.sh && \
sed -i 's#FILESYSTEM_VER=0.9.6#FILESYSTEM_VER=0.9.11#g' ./build-devkit.sh && \
sed -i 's#LIBFAT_VER=1.0.8#LIBFAT_VER=1.1.0#g' ./build-devkit.sh && \
#
# Also fix the link so that it points to Github
sed -i 's#http://downloads.sourceforge.net/devkitpro#https://github.com/Leseratte10/compile-devkitARM-r32/releases/download/helpers#g' ./build-devkit.sh && \
#sed -i 's#FETCH=wget#FETCH="wget --no-check-certificate"#g' ./build-devkit.sh && \#
#
# Now make sure we get rid of the fucking -Werror parameter
sed -i 's#touch patched_sources#touch patched_sources; bash ./fix-compile-errors.sh#g' ./build-devkit.sh

COPY fix-compile-errors.sh /buildscripts/fix-compile-errors.sh
COPY 0001-patch-gcc-fix-gnu-inline.patch /buildscripts/0001-patch-gcc-fix-gnu-inline.patch

# Now that that's done, set a few environment variables so that the
# installer knows what to do
# package: 1 = devkitARM, 2=devkitPPC, 3=devkitA64
ENV BUILD_DKPRO_INSTALLDIR=/opt/ \
BUILD_DKPRO_AUTOMATED=1 \
BUILD_DKPRO_DOWNLOAD=1 \
BUILD_DKPRO_PACKAGE=1 \
BUILD_DKPRO_SRCDIR=/buildscripts

# We don't need to build the tools, we only need GCC. 
# In fact, trying to build tools does actually fail.
# Remove the script so compiling doesn't run into an error, 
# then run the compiling script: 
RUN rm buildscripts/dkarm-eabi/scripts/build-tools.sh && cd buildscripts && ./build-devkit.sh


# Put compiled devkitARM into archive: 
RUN tar -cvzf /opt/devkitARM-r32-linux_debian-buster.tar.gz -C /opt/ devkitARM/

COPY dist.sh /dist.sh

ENTRYPOINT ["/dist.sh"]




