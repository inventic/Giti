#!/usr/bin/env bash
######################################################
#
# Author: Krzysztof Antczak
# Email : k.antczak@inventic.it
#
# Giti version 0.1.2
# Script license GNU AGPLv3
#
######################################################

GITI_HOME="/tmp/backup"

function giti_setup
{
    while [ "$home" == "" ] ; do

	echo -n "Enter giti target directory [$GITI_HOME]: "
	read home
	
	if [ ! -d $home ] ; then
	    echo "Target directory doesn't exists. Creating..."
	    mkdir $home
	    echo "GITI_HOME='$home'" > ~/.giti
	    exit 1
	else
	    echo "Target directory already exists. Exiting..."
	    echo "GITI_HOME='$home'" > ~/.giti
	    exit 1
	fi;

    done;

}

function repo_setup
{
    while [[ "$ca" != "y" && "$ca" != "n" ]] ;
    do
	echo -n "Do You wanna create it [y/n]? "
	read ca
    done;
    
    if [ "$ca" == "n" ] ; then exit 1; fi;
    
    while [ "$gitpath" == "" ] ; do
	echo -n "Enter full git clone/push repository path: "
	read gitpath
    done
    
    echo "Creating working dir in $WORKDIR from $gitpath..."
    cd $WORKDIR;git clone $gitpath $TARGET
}

if [ -f ~/.giti ] ; then . ~/.giti; else giti_setup; fi;

WORKDIR="$GITI_HOME/workdir"
TMPDIR="$GITI_HOME/tmp"

HOSTNAME=`hostname`
PWD=`pwd`

args=`getopt rhlt: $*`
if test $# = 0
then
    echo 'Usage: -t file [-r -h -l]'; exit 1
fi
set -- $args
for i do
  case "$i" in
        -t) shift;TARGET=$1;shift;;
        -r) shift;REMOVE=true;;
        -h) shift;echo "Usage: -t file [-r -h -s]";;
        -l) shift;ls $WORKDIR/; exit 1;;
        --) shift;;
  esac
done

if [ ! -d $GITI_HOME                 ] ; then echo "Giti not installed..."; giti_setup; exit 1; fi;
if [ ! -d $WORKDIR                   ] ; then mkdir $WORKDIR; fi;
if [ ! -d $WORKDIR/$TARGET           ] ; then echo "Target directory $WORKDIR/$TARGET doesn't exists."; repo_setup; exit 1; fi;
if [ ! -d $WORKDIR/$TARGET/.git      ] ; then echo "Target directory isn't a git repository."; exit 1; fi;
if [ ! -d $WORKDIR/$TARGET/$HOSTNAME ] ; then mkdir $WORKDIR/$TARGET/$HOSTNAME; fi;

type=""
remove=""

for i
do
    if [ -f "$i" ] ; then type="file"; fi;
    if [ -d "$i" ] ; then type="dir";  fi;

    if [ "$type" != "" ]; then

	i=`realpath $i`

	if [ "${i:0:1}" == "/" ] ; then
	    spath=$WORKDIR/$TARGET/$HOSTNAME$i;
	else
	    spath=$WORKDIR/$TARGET/$HOSTNAME$PWD/$i;
	fi
	
	if [ "$REMOVE" == "true" ] ;
	then 
	    if [[ -d "$spath" || -f "$spath" ]] ; then cd `dirname $spath`;git rm -r $spath; remove=" [cleanup]"; fi;
	else
	
	    tdir=`dirname $spath`
	    
	    if [ ! -d $tdir ] ; then mkdir -p $tdir; fi;
	    
	    echo "Copy [$type] $i to $tdir/"
	    cp -RpL $i $tdir/
	
	fi;
	
    else
	echo "$i doesn't exists"
    fi;
    
    type=""
done

cd $WORKDIR/$TARGET;
git pull
git add .
git commit -am "Backup on `date`$remove [`hostname`]"
git push origin master
