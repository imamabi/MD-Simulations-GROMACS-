#!/bin/bash

# Specify the path to the main directory containing subdirectories
main_directory="/Users/ibrahimimam/Desktop/Paper_materials/protein/sim_out"

export DSSP="/Users/ibrahimimam/opt/anaconda3/envs/dsspenv/bin/mkdssp"

# Iterate through subdirectories in the main directory
for subdirectory in "$main_directory"/*; do
    if [ -d "$subdirectory" ]; then
        cd "$subdirectory" || exit

        # Extract the directory name for naming files
        directory_name=$(basename "$subdirectory")

        # Run your gmx command here with the appropriate input and output files 
	
	#Root mean square deviation analysis: least square distances gmx
	echo 3 3 | gmx rms -f "$directory_name-sol4.trr" -n index_active.ndx  -s "$directory_name-sol3.tpr" -o "$directory_name-rmsd.xvg -tu ns

	#Root mean square Fluctuation: C-alpha
	echo 3 | gmx rmsf -f "$directory_name-sol4.trr" -n index_active.ndx  -s "$directory_name-sol3.tpr" -o "$directory_name-Ca-rmsf.xvg -res

	#Solvent accessible surface area (surface protein and sub-surface cleft)        ----- Note: output but be subset of surface
	gmx sasa -f "$directory_name-sol4.trr" -n index_active.ndx  -s "$directory_name-sol3.tpr" -o "$directory_name-SASA.xvg" -or "$directory_name-SASA-ave.xvg"  -surface 2

	#Contact map analysis: Alpha-Carbon contact
	echo 3 | gmx mdmat -f "$directory_name-sol4.trr" -n index_active.ndx  -s "$directory_name-sol3.tpr" -mean "$directory_name-Ca-contact.xvg" -t 5


        #DSSP Analysis
	#echo 7 | gmx do_dssp -f "$directory_name-sol4.trr" -s "$directory_name-sol3.tpr" -o "$directory_name-ss.xpm" -sc "$directory_name-scount.xvg" -tu ns -dt 2

        #hbond analysis - mutated residue vs solvent 
        #echo 18 13 | gmx hbond -f "$directory_name-sol4.trr" -s "$directory_name-sol3.tpr" -n index_active.ndx -num "$directory_name-hbond-BDsol.xvg" 
        echo 21 13 | gmx hbond -f "$directory_name-sol4.trr" -s "$directory_name-sol3.tpr" -n index_active.ndx -num "$directory_name-hbond-718.xvg" -ac "$directory_name-hlife-718.xvg"
        echo 22 13 | gmx hbond -f "$directory_name-sol4.trr" -s "$directory_name-sol3.tpr" -n index_active.ndx -num "$directory_name-hbond-792.xvg" -ac "$directory_name-hlife-792.xvg"
        #echo 23 13 | gmx hbond -f "$directory_name-sol4.trr" -s "$directory_name-sol3.tpr" -num "$directory_name-hbond-796.xvg" 
	

	#echo 19 19 | gmx hbond -f "$directory_name-sol4.trr" -s "$directory_name-sol3.tpr" -n index_active.ndx -num "$directory_name-BD-hbond.xvg" 
	echo 18 21 | gmx hbond -f "$directory_name-sol4.trr" -s "$directory_name-sol3.tpr" -n index_active1.ndx -num "$directory_name-res1-BD-hbond.xvg" -ac "$directory_name-res1-BD-hlife.xvg"
	echo 23 22 | gmx hbond -f "$directory_name-sol4.trr" -s "$directory_name-sol3.tpr" -n index_active1.ndx -num "$directory_name-res2-BD-hbond.xvg" -ac "$directory_name-res2-BD-hlife.xvg"
	
	#SASA analysis res
	#gmx sasa -f "$directory_name-sol4.trr" -s "$directory_name-sol3.tpr" -n index_active.ndx -o "$directory_name-res-sasa-time.xvg" -or "$directory_name-res-sasa-avg.xvg" -surface 1 -output 20

	#convert to xpm
	#gmx xpm2ps -f "$directory_name-all-ss.xpm" -di dssp.m2p -o "$directory_name-all-ss.eps" 
	#gmx xpm2ps -f "$directory_name-748-ss.xpm" -di sub_dssp.m2p -o "$directory_name-748-ss.eps"
	#gmx xpm2ps -f "$directory_name-862-ss.xpm" -di sub_dssp.m2p -o "$directory_name-862-ss.eps"
	#mogrify -format png *.eps

        cd "$main_directory" || exit
    fi
done


