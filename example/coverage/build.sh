#!/bin/bash
set -e

find . -mindepth 1 -maxdepth 1 -type d -print0 | while read -d $'\0' file
do
  if [ -f "$file"/build.hxml ]

  	then
	{
	    cd ${file:2} 
	    echo `pwd`
	    mkdir -p bin
	    haxe build.hxml
	    cd ../
	}	 
  fi

done
