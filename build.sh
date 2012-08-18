set -e

#!/bin/bash
haxelib run mlib allClasses
haxe buildAllClasses.hxml


day=$( date +%s )
fname="src/stamp.txt"

echo  $( date -r ${day} ) | md5 >${fname}

haxelib run mlib install


# cd example
# bash build.sh
# cd ../

haxelib run munit test -neko -coverage
