#!/usr/bin/env bash

filein=LC80140342014091LGN00_MTL.txt
fileou=LC80140342014091_CBay.L2

parfile=landsat_cbay.par
# Make the parfile
echo 'ifile=' "$filein" > $parfile
echo 'ofile=' "$fileou" >> $parfile
echo 'ctl_pt_incr=1' >> $parfile
echo 'maskglint=1' >> $parfile
#echo 'aer_opt=1' >> $parfile
#echo 'aer_models=r75f10v01' >> $parfile
#echo 'aer_wave_long=2201' >> $parfile
#echo 'maskland=1' >> $parfile
#echo 'maskhilt=0' >> $parfile
#echo 'maskcloud=1' >> $parfile
#echo 'cloud_thresh=0.018' >> $parfile
#echo 'filter_opt=1' >> $parfile
#echo 'filter_file=$OCDATAROOT/oli/msl12_filter.dat' >> $parfile
echo 'l2prod="chl_oc3,Rrs_443,Rrs_482,Rrs_561,Rrs_655,Lw_443,Lw_561,Lw_655,Lt_443,Lt_561,Lt_655,Lt_2201,La_443,La_561,La_655,La_2201,ag_412_mlrc"' >> $parfile

l2gen par=$parfile
