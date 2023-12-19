#!/bin/bash

# Load the GROMACS environment (adjust this path according to your setup)
source /home/pkg/gromacs2021/bin

# Define variables
protein_file="L718Q"       # Protein structure file
#ligand_file="ligand.pdb"         # Ligand structure file
#forcefield="ffamber99sb-ildn"   # Force field name (choose the appropriate one)
water_model="spc216"             # Water model (choose the appropriate one)

# Step 1: Generate Topology Files
echo 1 | gmx_gpu pdb2gmx -f $protein_file.pdb  -o $protein_file.gro -p $protein_file.top -ignh -ter -ff amber14sb_OL15

#gmx pdb2gmx -f $ligand_file -o ligand.gro -p ligand.top -ignh -ff $forcefield

# Step 2: Combine Topology Files
#cat protein.top ligand.top > system.top

# Step 2: Create simulation box
gmx_gpu editconf -f $protein_file.gro -o $protein_file-box.gro -c -d 1.0 -bt cubic

# Step 3: Create Solvent Box
gmx_gpu solvate -cp $protein_file-box.gro -cs $water_model.gro -o $protein_file-sol.gro -p $protein_file.top -shell 3 

# Step4: Create an index file
echo q 1 | gmx_gpu make_ndx -f $protein_file-sol.gro 

#Step 5: Create a .tpr file
gmx_gpu grompp -f mdp.mdp -c $protein_file-sol.gro -n index.ndx -p $protein_file.top -o $protein_file-sol.tpr -maxwarn 2

cat $protein_file.top > $protein_file-sol.top

# Step 6: Ionize the System (if necessary)
echo 13 |  gmx_gpu genion -s $protein_file-sol.tpr -o $protein_file-sol1.gro -p $protein_file-sol.top -neutral

#Step 7: Create index file
echo q 1 | gmx_gpu make_ndx -f $protein_file-sol1.gro -o $protein_file-sol.ndx

#
#
#Renaming the mdp files (not necessary)

cat mdp1.mdp > $protein_file-sol1.mdp

cat mdp2.mdp > $protein_file-sol2.mdp

cat mdp3.mdp > $protein_file-sol3.mdp

#
#
#

