#!/bin/bash

#SBATCH -t 72:00:00                             #Time for the job to run
#SBATCH --job-name=                  #Name of the job
#SBATCH -N 1                                    #Number of nodes required
#SBATCH --ntasks 10                            #Number of cores needed for the job
#SBATCH --partition=V4V32_CAS40M192_L                           #Name of the queue
##SBATCH --partition=V4V32_SKY32M192_L                           #Name of the queue
#SBATCH --gres=gpu:1                    #Number of GPU's

#SBATCH --mail-type ALL                         #Send email on start/end
#SBATCH --mail-user iaim223@uky.edu               #Where to send email
#SBATCH --account=gol_qsh226_uksr               #Name of account to run under

##SBATCH --nodelist=gvnode004

#module --force purge
#module load gnu/5.4.0
#module load openmpi/1.10.7
#module load ccs/gromacs/skylake-gpu/2019
#source /opt/ohpc/pub/libs/gnu/openmpi/ccs/gromacs/2019/skylake-gpu/bin/GMXRC

module --force purge
module load gnu7/7.3.0
module load openmpi3/3.1.0
module load ccs/cuda/10.0.130


echo "Job running on SLURM NODELIST: $SLURM_NODELIST " 
export GROMACS=/project/qsh226_uksr/gromacs2022/bin

#export CUDA_VISIBLE_DEVICES=1

#GROMACS single node with 4 GPUs using thread-MPI and allow GROMACS to determine the launch parameters (ntmpi, ntomp) on it's own.
#gmx grompp -f pme.mdp
#gmx mdrun  -nsteps 4000 -v -pin on -nb gpu

options_md2=" "
options_md="-update gpu -nice 1 -nb gpu -ntomp 10"
#options=" -nice 1 -nb gpu -ntomp 4 -ntmpi 3 -gputasks 001"
#options=" -nice 1 -ntomp 16"

a=1
OMP_NUM_THREADS=16
for file in L718Q-sol
do
{
#for equilibrium
# end of equilibrium
#cd $file-test
for number in 2 3
do
{
let num2=number+1
#node1=4
#node2=$((node1*(a-1)))
#a=$((a+1))
$GROMACS/gmx_gpu grompp -f $file$number -c $file$number.gro -n $file.ndx -p $file.top -o $file$number.tpr -maxwarn 2
$GROMACS/gmx_gpu mdrun -s $file$number -o $file$num2.trr -c $file$num2.gro -e $file$number.edr -g $file$number.log $options_md
#mpiexec -np $node1 -cpus-per-proc $OMP_NUM_THREADS $GROMACS/gmx_gpu mdrun -s $file$number -o $file$num2.trr -c $file$num2.gro -e $file$number.edr -g $file$number.log $options

}
done
}
done

