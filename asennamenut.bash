#!/bin/bash
########################################################################
#
# A script to install menu choices for YLE Areena making use of Launchy add-on for FireFox.
#
# Installation runs under /tmp and stores files to <home>/.menut
# Author: ajaaskel(at)forum.ubuntu-fi.org  temp001(at)pp.inet.fi
# 
# v1.24  2012-02-29 Installs: "mimms" to support mms-recording and "libnotify-bin" to support "notify-send".
#                   Installs to all users (except Launchy app still needs to be manually installed for other users) 
#                   Bug fix:  Using "find" instead of "locate".
# v1.25  2012-06-22 New: Better file name support for "Katsomo" downloads
#                   New: Installs "recode" for html entity -> text conversion
#                   Fix: Owner/group for .menut, chrome, Videot
# v1.26  2012-07-19 Fix: Owner/group when homedir is 700, create "Videot" for all users if no "Video?" 
# v1.27  2012-09-26 "updatedb" no more needed, removed
# v1.28  2012-11-09 mimms no more needed, installs "libav-tools", "vlc"
# v1.3   2013-01-07 Auto DL aware 
# v1.4   2013-01-16 Bug fix, Auto DL detection
# v1.41  2013-02-09 no more backgrounding launchy installation to Firefox
# v2.0   2013-02-26 login.defs uid limits, /etc/passwd enquiry
# v2.1   2013-04-04 Static ffmpeg
#
########################################################################

GET_BITS()
#Entry: none return: BIT_AMOUNT
{
BITS=`uname -m` 
case $BITS in
i586 | i686 )
  BIT_AMOUNT='32';;
x86_64 )
  BIT_AMOUNT='64';;
* )
  BIT_AMOUNT='Unknown';;
esac
}

GET_DESKTOP()
#Detect desktop
{
if [ $(pgrep -c gnome-session) != 0 ] ; then
  DESKTOP="gnome"
elif [ $(pgrep -c ksmserver) != 0 ] ; then
  DESKTOP="kde"
elif [ $(pgrep -c xfce-msc-manage) != 0 ] ; then
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

select_by_num()
# Entry:
# $1=filename
# $2=testfield #
# $3=minimum value
# $4=maximum value
# $5=printfield #
# $6=separator character, default ":"
{
[[ -z "$1" ]] && exit 81
[[ -z "$2" ]] && exit 82
[[ -z "$3" ]] && exit 83
[[ -z "$4" ]] && exit 84
[[ -z "$5" ]] && exit 85
[[ -z "$6" ]] && sep=":" || sep="$6"
unset response
response=$(awk -v"t_field=$2" -v"min=$3" -v"max=$4" -v"p_field=$5" -F"$sep" '{ if ( $t_field >= min && $t_field <= max ) print $p_field }' "$1")
# Returns single cell array of strings in global "response"
}

select_by_st()
# Entry:
# $1=filename
# $2=testfield #
# $3=string to test
# $4=printfield #
# $5=separator character, default ":"
{
[[ -z "$1" ]] && exit 81
[[ -z "$2" ]] && exit 82
[[ -z "$3" ]] && exit 83
[[ -z "$4" ]] && exit 84
[[ -z "$5" ]] && sep=":" || sep="$5"
unset response
response=$(awk -v"t_field=$2" -v"st=$3" -v"p_field=$4" -F"$sep" '{ if ( $t_field == st ) print $p_field }' "$1")
# Returns single cell array of strings in global "response"
}

# Main ##################################################################
if [ $(id -u) = 0 ]; then
	echo -e "\nAsennus käynnistetään tavallisena käyttäjänä (ei sudo: n kanssa tai root)."
	echo -e "Asennusohjelma itse kysyy salasanaa silloin kun tarvitaan korotettuja oikeuksia.\n"
	exit 1
fi
echo "Tarkastetaan löytyykö yle-dl (komentoriviohjelma) koneesta ja asennetaan jos puuttuu:"
if [ -z $(which yle-dl) ]; then
	echo "Ei löytynyt, asennetaan ensin"
	cd /tmp
	wget -r -O"asenna_yle-dl.bash" http://www.homelinuxpc.com/download/asenna_yle-dl.bash
	chmod +x asenna_yle-dl.bash
	./asenna_yle-dl.bash
	else
	echo "Löytyi, jatketaan menujen asennukseen" 
fi
GET_SUDO
$_SUDO "YLE Areenan ja Katsomon menujen asennus Firefox: lle"
mkdir -p /tmp/menut
cd /tmp/menut
rm /tmp/menut/nauhoitus.zip 2>/dev/null
rm /tmp/menut/ffmpeg??.zip 2>/dev/null
echo -e "\nHaetaan nauhoitus.zip ja ffmpegXX asennuspalvelimelta:"
wget http://www.homelinuxpc.com/download/nauhoitus.zip

GET_BITS
case $BIT_AMOUNT in
32)
	echo "32 bits o/s detected."
	ffmpeg="ffmpeg32.zip" ;;
64)
	echo "64 bits o/s detected."
	ffmpeg="ffmpeg64.zip" ;;
esac

wget http://www.homelinuxpc.com/download/$ffmpeg

echo "Puretaan nauhoitus.zip ja ffmpegXX --> /tmp/menut:"
unzip -o nauhoitus.zip
unzip -o ffmpeg??.zip
chmod +x ./*
# Auto DL detection to select correct launchy.xml
if [ -f ./launchy_adl.xml ]; then #Auto DL version of launchy.xml ?
	if [ -f /opt/auto_dl/auto_dld ]; then    #Select correct launchy.xml 
	echo -e "\nAuto DL löytyi koneesta, käytetään sille tarkoitettua launchy.xml tiedostoa.\n"
	cp -p ./launchy_adl.xml ./launchy.xml
	else
	echo -e "\nAuto DL ei löytynyt koneesta asennettuna, käytetään lyhyempää launchy.xml tiedostoa.\n"
	cp -p ./launchy_no_adl.xml ./launchy.xml
	fi
	rm ./launchy_adl.xml ./launchy_no_adl.xml 
fi
# Check for uid range
uid_min=$(grep "^UID_MIN" /etc/login.defs | sed 's/[^0-9]*//g')
uid_max=$(grep "^UID_MAX" /etc/login.defs | sed 's/[^0-9]*//g')
# Find users belonging to uid range 
select_by_num /etc/passwd 3 $uid_min $uid_max 1
userlist=$response
echo "Löydettiin tunnukset:"
echo -e "$userlist\n"
# Create folders and copy files
echo "Luodaan mahdollisesti puuttuva \"chrome\" -kansio käyttäjille joilla on \"~/.mozilla\" olemassa,"
echo "kopioidaan launchy.xml \"chrome\" -kansioihin, kopioidaan menutiedostot kaikille tunnuksille"
echo "ja näytetään \"chrome\" -kansion ominaisuudet ja sisältö"
while read -r usr
do
	select_by_st /etc/passwd 1 "$usr" 6
	userhome=$response
	echo -e "\n$userhome"
	export usr
	[[ -d "$userhome/.mozilla" ]] && sudo find $userhome/.mozilla -name "*.default" -prune\
	| xargs -r -n 1 -I{} bash -c 'sudo mkdir -p {}/chrome;\
	sudo stat -c "%A %U %G %n" {}/chrome; sudo cp -p /tmp/menut/launchy.xml {}/chrome;\
	sudo chown -R $usr:$usr {}/chrome; sudo stat -c "%A %U %G %n" {}/chrome/*'
	sudo mkdir -p $userhome/.menut
	sudo cp -p /tmp/menut/* $userhome/.menut
	sudo chown -R $usr:$usr $userhome/.menut
done <<< "$userlist"
echo -e "\nKansiot ja kopioinnit tehty\n"
# Install .deb packages
echo "Asennetaan tarvittavat .deb -paketit joista yksi on VLC:"
sudo apt-get install libnotify-bin -y
sudo apt-get install recode -y
sudo apt-get install libav-tools -y
sudo apt-get install vlc -y

#Install Launchy to Firefox
if [ -n "$(which firefox)" ]; then
echo -e "Firefox löytyi, haetaan viimeisin Launchy ja asennetaan se.\n"
echo "  Menuihin tarvittavan Launchy-ohjelman asennus vain käyttäjätunnuksellesi."
echo "  Muille käyttäjätunnuksille se asennetaan niin että kirjaudutaan kyseisellä"
echo -e "  tunnuksella, käynnistetään Firefox ja annetaan linkkikenttään:\n"
echo -e "  /tmp/menut/addon-81-latest.xpi\n" 
rm  ./addon-81-latest.* 2>/dev/null
wget -q https://addons.mozilla.org/firefox/downloads/latest/81/addon-81-latest.xpi
firefox /tmp/menut/addon-81-latest.xpi
else
echo "Firefox ei löytynyt asennettuna. Jos se on kuitenkin jo jossain"
echo "niin menuihin tarvittavan Launchy-ohjelman voi asentaa niin"
echo -e "että käynnistät Firefox: in ja annat linkkikenttään:"
echo -e "  /tmp/menut/addon-81-latest.xpi\n" 
echo "Muille olemassaoleville käyttäjätunnuksille se asennetaan samalla tavalla."
fi


 
 
