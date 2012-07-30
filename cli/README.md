MCover CLI
==============

##Goal

Provide a mechanism for converting raw coverage data into standalone reports

## Approach

Pass through a mcover data file along with the matching src directores

	mcover report [file] [classpath]

E.g.

	mcover report mcover.dat src
