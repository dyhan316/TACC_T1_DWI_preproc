#! /bin/bash

# Simple SLURM script for submitting multiple serial
# jobs (e.g. parametric studies) using a script wrapper
# to launch the jobs.
#
# To use, build the launcher executable and your
# serial application(s) and place them in your WORKDIR
# directory. Then, edit the CONTROL_FILE to specify 
# each executable per process.
#——————————————————-
#——————————————————-
# 
# <—— Setup Parameters ——>
#
#SBATCH -J run_qsiprep_preproc#name of the job
#SBATCH -N 2    #how many nodes you need
#SBATCH -n 100  #how many jobs 
#SBATCH -p flat-quadrant #the queue on stampede 2 to use
#SBATCH -o ./qsiprep_step4_output/QSIPREP_preproc.o%j  #change according to you job name
#SBATCH -e ./qsiprep_step4_output/QSIPREP_preproc.e%j #change according to you job name
#SBATCH -t 00:30:30     #number of hours for the job to run. 48hr is the maximum for normal queue.
##SBATCH –-mail-user=dyhan0316@gmail.com  #email address to send notification
##SBATCH -–mail-type=all # Send email at begin and end of job
# <—— Account String —–>
# <— (Use this ONLY if you have MULTIPLE accounts) —>
##SBATCH -A
#——————————————————

module load launcher #맞는지 모르겠다

export LAUNCHER_PLUGIN_DIR=$LAUNCHER_DIR/plugins
export LAUNCHER_RMI=SLURM
export LAUNCHER_JOB_FILE=./qsipreproc_command_list.txt
#export LAUNCHER_JOB_FILE=/work2/08834/tg881334/stampede2/CHA_preproc/IMP_one_sub/run_this_all
#export LAUNCHER_JOB_FILE=$1


#export LAUNCHER_JOB_FILE=/work2/08834/tg881334/stampede2/CHA_preproc/IMP_one_sub/helloworld_multi_output
#export LAUNCHER_JOB_FILE=/work2/08834/tg881334/stampede2/learning_MPI/launcher/extras/examples/helloworld_multi_output       #change the path here to point to you job file

$LAUNCHER_DIR/paramrun


