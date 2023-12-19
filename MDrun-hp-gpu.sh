#! /bin/bash
#SBATCH  --partition=GPU2
#SBATCH  --job-name=ps-50-10
#SBATCH --output=st.out
#SBATCH  --time=70:00:00
#SBATCH  --mail-user=qshao@uky.edu
#SBATCH  --mail-type=ALL


#module load gcc/4.9.1
#module load mpi/openmpi/gcc/1.8.2
#module load cuda/7.0

#export GROMACS=/home/local/AD/qsh226/gromacs2021/bin
export GROMACS=/home/pkg/gromacs2021/bin
#export GROMACS=/usr/local/gromacs/bin

#options=" -nice 1 -bonded gpu -nb gpu -pme gpu -npme 1 -ntomp 4 -ntmpi 5 -gputasks"
options="-nice 1 -ntmpi 1 -nb gpu -ntomp 10 -gpu_id 0"
#options="-nice 1 -ntmpi 1 -ntomp 20"
#options="-bonded gpu -pme gpu -update gpu -nice 1 -ntmpi 1 -nb gpu -ntomp 10 -gpu_id 0"
#options=" -nice 1 -v -nb gpu -ntomp 8 -ntmpi 1 -gpu_id 3"
#options=" -nice 1 -nb gpu -ntomp 4 -ntmpi 3 -gputasks 001"
#options=" -nice 1 -ntomp 16"

a=1
OMP_NUM_THREADS=10
for file in T790M-sol
do
{
#for equlibrium
# end of equilibrium
#cd $file-test
for number in 1
do
{
let num2=number+1 
#node1=4
#node2=$((node1*(a-1)))
#a=$((a+1))
$GROMACS/gmx_gpu grompp -f $file$number -c $file$number.gro -n $file.ndx -p $file.top -o $file$number.tpr -maxwarn 2 
$GROMACS/gmx_gpu mdrun -s $file$number -o $file$num2.trr -c $file$num2.gro -e $file$number.edr -g $file$number.log $options 
#mpiexec -np $node1 -cpus-per-proc $OMP_NUM_THREADS $GROMACS/gmx_gpu mdrun -s $file$number -o $file$num2.trr -c $file$num2.gro -e $file$number.edr -g $file$number.log $options 
 
}
done
#cd ..
}
done
#wait
