#!/bin/sh

if test `uname` = Darwin; then
    cachedir=~/Library/Caches/KBuild
else
    if x$XDG_DATA_HOME = x; then
	cachedir=$HOME/.local/share
    else
	cachedir=$XDG_DATA_HOME;
    fi
fi
mkdir -p $cachedir

url=https://www.nuget.org/nuget.exe

if test ! -f $cachedir/nuget.exe; then
    wget -o $cachedir/nuget.exe $url 2>/dev/null || curl -o $cachedir/nuget.exe --location $url /dev/null
fi

if test ! -e .nuget; then
    mkdir .nuget
    cp $cachedir/nuget.exe .nuget
fi

if ! type k > /dev/null 2>&1; then
  source build/kvm.sh
fi

if ! type k > /dev/null 2>&1; then
  kvm upgrade
fi


mono packages/Sake/tools/Sake.exe -I packages/KoreBuild/build -f makefile.shade "$@"
