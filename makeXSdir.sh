#!/bin/bash
# This script generates the XS entry file for SCONE
# 
# the entry file has the following structure,
# ! comment 
# <ZA.id>c   <line no.>   <absolute path>
#
# expects "acedata" folder on the . directory
# will search at most two levels deep, i.e., ./acedata/*/*
# "acedata" folder should contain ASCII encoded ACE files 
# binary tables are not supported 
# reads 'old-style' ACE and numerates neutron XS only
# 
# Written by Saad Islam on 05 MAY 22
# For instruction follow the release at, 
# https://github.com/saad589/SCONEBuild

# Vars
dirPath="acedata" 
outFile="foo.aceXS"

# Make sure path to library directory is absolute 
dirPath=$PWD/$dirPath

# Check whether "acedata"  exists
echo "Expecting the ACE files in the following location..." 
echo $dirPath

if [ -d $dirPath ] 
then
    echo 
    echo "Directory exists" 
else
    echo
    echo "Error: directory does not exist"
    echo "Plese rename the folder that contains the ACE "
	echo "tables to "$dirPath" and put the folder on the same "
	echo "directory as this script."
	echo "Further instruction is provided at: "
	echo "https://github.com/saad589/SCONEBuild"
	exit 1 
fi

# Write output
echo
echo "Writing output..."
for filePath in $dirPath/* $dirPath/**/*; do
	# -P (perl) must be provided otherwise \d (any number) won't work 
	grep -nP ".\d\dc" $filePath | while read line; do
		# echo $line
		# echo $( echo $line | cut -d : -f 2 | awk {'print $1'}) 
		aceId=$( echo $line | cut -d : -f 2 | awk {'print $1'} ); echo $aceId
		# aceId=$( echo $line | awk {'print $2'} ); echo $aceId
		i=$( echo $line | awk {'print $1'} | cut -d : -f 1 )
		printf "%s\t%8u\t%s\n" $aceId $i $filePath >> $outFile
	done
done
echo
echo Done!
echo "Output saved to "$outFile


