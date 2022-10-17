#! /bin/bash

#SBATCH --job-name time_it_CHA_preproc  #job name을 다르게 하기 위해서
#SBATCH --nodes=1
#SBATCH --nodelist=node3 #used node3
#SBATCH -t 80:00:00 # Time for running job #길게 10일넘게 잡음
#SBATCH -o /scratch/connectome/dyhan316/CHA_preprocessing/time_it/cpu_8_4/output_%J.out #%J : job id 가 들어가는 것
#SBATCH -e /scratch/connectome/dyhan316/CHA_preprocessing/time_it/cpu_8_4/error_%J.error
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=500MB
#SBATCH --cpus-per-task=8

nthreads=8
othreads=4

# uses older versino of qsiprep because new versino of qsiprep doesn't have reconall, and doing reconall seperately results in dwi T1 registration errors.... 

docker run --rm --name CHA_fs_reconstruction_${nthreads}_${othreads} \
-v /storage/bigdata/CHA_bigdata/2.dcm2niix/test_time_MRI_BIDS/:/data:ro \
-v /storage/bigdata/CHA_bigdata/test_time_MRI_output/cpu_${nthreads}_${othreads}/:/out \
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
--nthreads ${nthreads} \
--omp-nthreads ${othreads} \
--infant \

# --omp-nthreads 4 \
