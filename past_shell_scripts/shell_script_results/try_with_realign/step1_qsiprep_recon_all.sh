#! /bin/bash

#SBATCH --job-name 21_AGAIN_preproc  #job name을 다르게 하기 위해서
#SBATCH --nodes=1
#SBATCH --nodelist=node1 #used node2
#SBATCH -t 800:00:00 # Time for running job #길게 10일넘게 잡음
#SBATCH -o /storage/bigdata/CHA_bigdata/shell_scripts/shell_script_results/2021_results/step1_qsiprep_results/output_%J.out #%J : job id 가 들어가는 것
#SBATCH -e /storage/bigdata/CHA_bigdata/shell_scripts/shell_script_results/2021_results/step1_qsiprep_results/error_%J.error
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=1GB
#SBATCH --cpus-per-task=46


# uses older versino of qsiprep because new versino of qsiprep doesn't have reconall, and doing reconall seperately results in dwi T1 registration errors.... 

docker run --rm --name CHA_fs_reconstruction_21_2 \
-v /storage/bigdata/CHA_bigdata/2.dcm2niix/2021_MRI_BIDS/:/data:ro \
-v /storage/bigdata/CHA_bigdata/3.qsiprep_results/2021_QSI_preproc_results/:/out \
-v /scratch/connectome/dyhan316/dwMRI:/freesurfer \
pennbbl/qsiprep:0.14.3 \
/data \
/out \
participant \
-w /out/tmp \
--output_resolution 1.2 \
--denoise_after_combining \
--unringing_method mrdegibbs \
--b0_to_t1w_transform Affine \
--intramodal_template_transform SyN \
--do_reconall \
--fs-license-file /freesurfer/license.txt \
--skip_bids_validation \
--nthreads 46 \
--omp-nthreads 1 \
--infant \
