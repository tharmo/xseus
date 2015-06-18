#!/bin/bash
# Installation script for "yle-dl"
# Checks bit width and installs related package, 32 or 64 bits 
# Author: ajaaskel(at)forum.ubuntu-fi.org temp001(at)pp.inet.fi
#
# Change log:
# V1.15 2012-05-23  1) New YLE Areena .deb files 2) Uninstall of old version 3) ldconfig
# V1.16 2012-05-24 "apt-get purge" instead of "apt-get remove"
# V1.17 2012-05-25 New version of rtmpdump-yle
# V1.18 2012-06-06 New version of rtmpdump-yle
# V1.19 2012-06-07 Dependency on python-crypto added
# V1.20 2012-06-21 Both new version and new package name "yle-dl", "rtmpdump" re-build to avoid old dependencies  
# V1.21 2012-12-07 yle-dl V2.0.2 
# V1.22 2012-12-07 Remove previous yle-dl packages at current dir 
# V1.23 2013-05-22 yle-dl V2.1.0
#
#**********************************************

NEW_32="yle-dl_2.1.0-1_i386.deb"
NEW_64="yle-dl_2.1.0-1_amd64.deb"
DL_HTTP="http://www.homelinuxpc.com/download"

#***********************************************

GET_BITS()
#Entry: none return: BIT_AMOUNT
{
BITS=`uname -m` 
case $BITS in
i686 )
  BIT_AMOUNT='32 bits';;
x86_64 )
  BIT_AMOUNT='64 bits';;
* )
  BIT_AMOUNT='Unknown';;
esac
}

GET_DESKTOP()
#Detect desktop
{
if [ -n "$(pgrep gnome-session)" ] ; then
  DESKTOP="gnome"
elif [ -n "$(pgrep ksmserver)" ] ; then
  DESKTOP="kde"
elif [ -n "$(pgrep xfce-msc-manage)" ] ; then
  DESKTOP="xfce"
else
DESKTOP="unknown"
fi
}

GET_SUDO()
#Which graphical sudo to use ?
{
GET_DESKTOP
if [ "$DESKTOP" = "gnome" ] ; then
_SUDO="gksudo"
elif [ "$DESKTOP" = "kde" ] ; then
_SUDO="kdesudo"
else
_SUDO="sudo"
fi
}

cd ~
GET_BITS
GET_SUDO

if [ "$BIT_AMOUNT" = "32 bits" ] ; then
  echo "32 bits o/s detected."
  rm  ./yle-dl_* 2>/dev/null
  wget -r -O"$NEW_32" "$DL_HTTP/$NEW_32"
  $_SUDO "YLE Areenan latauksen asennus"
  sudo apt-get -y purge rtmpdump-yle
  sudo apt-get install gdebi-core
  sudo gdebi -n ./$NEW_32
  sudo ldconfig
elif [ "$BIT_AMOUNT" = "64 bits" ] ; then
  echo "64 bits o/s detected."
  rm  ./yle-dl_* 2>/dev/null
  wget -r -O"$NEW_64" "$DL_HTTP/$NEW_64"
  $_SUDO "YLE Areenan latauksen asennus"
  sudo apt-get -y purge rtmpdump-yle
  sudo apt-get install gdebi-core
  sudo gdebi -n ./$NEW_64
  sudo ldconfig
else
  echo "*** Error: Cannot detect bit width --- application not compatible with this o/s. ***"
  exit
fi





