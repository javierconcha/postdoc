#!/bin/bash

for file in `cat file_list.txt`
do
	file_name=$(basename $file .he5)
	echo $file_name
	mkdir $file_name
	mv $file_name.he5 $file_name
	cat l2gen_test.param | sed 's"filename"'$file_name'"g' > $file_name/l2gen_test_aux.param
	cd $file_name
	l2gen par=l2gen_test_aux.param
	
	val_extract ifile=$file_name.L2 ofile=$file_name.L2.o ignore_flags="LAND HIGLINT HILT STRAYLIGHT CLDICE ATMFAIL LOWLW FILTER NAVFAIL NAVWARN" 

	cd ..
done
