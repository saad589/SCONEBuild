#!/bin/bash
# This script generates the XS directory file for SCONE
# 
# the directory file has the following structure,
# ! comment 
# <ZA>.<id><lib_type>  <starting_line_no.>  <absolute_path>
#
# expects "acedata" folder on the . directory
# will search at most two levels deep, i.e., ./acedata/*/*
# "acedata" folder should contain ASCII encoded ACE files 
# binary tables are not supported 
# reads 'old-style' ACE and numerates neutron XS only (for now)
# 
# Written by Saad Islam 
# For instruction visit the release, 
# https://github.com/saad589/SCONEBuild

# Vars
dirPath="acedata" 
outFile="foo.aceXS"

# Make the path to library directory absolute 
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
    echo "Plese rename the folder that contains the ACE tables to "$dirPath" and put the folder on the same directory as this script. Further instruction is provided at: https://github.com/saad589/SCONEBuild"
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


