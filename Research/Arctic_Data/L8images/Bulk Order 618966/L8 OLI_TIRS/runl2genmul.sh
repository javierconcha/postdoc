#!/bin/bash
# Script to run multiple l2gen sequentially
# Javier A. Concha
# 2016-02-09

#echo "Type the range that you want to run (4 digits), followed by [ENTER]:"

#read range

for FILE in `cat file_list.txt`
do 	
	echo running l2gen on $FILE 	
	l2gen ifile=./"$FILE"/"$FILE"_MTL.txt ofile1=./"$FILE"/"$FILE"_L2n1.nc aer_opt=-1 l2prod="chl_oc3,Rrs_443,Rrs_482,Rrs_561,Rrs_655,Lw_443,Lw_561,Lw_655,Lt_443,Lt_561,Lt_655,Lt_2201,La_443,La_561,La_655,La_2201,ag_412_mlrc"

	let i++
	echo $i
done
echo l2gen run in multiple files finished...
