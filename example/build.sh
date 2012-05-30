#!/bin/bash
find . -mindepth 2 -maxdepth 2 -type d -print0 | while read -d $'\0' file
do
  if [ -f "$file"/build.hxml ]

  	then
	{
	    cd ${file:2} 
	    echo `pwd`
	    haxe build.hxml
	    cd ../../
	}	 
  fi

done
