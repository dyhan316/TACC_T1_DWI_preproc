#! /bin/bash

#SBATCH --job-name CHA_preproc  #job name을 다르게 하기 위해서
#SBATCH --nodes=1
#SBATCH --nodelist=node2 #used node2
#SBATCH -t 15:00:00 # Time for running job #길게 10일넘게 잡음
#SBATCH -o /scratch/connectome/dyhan316/WECANDOIT/past_files/output_%J.out #%j : job id 가 들어가는 것
#SBATCH -e /scratch/connectome/dyhan316/WECANDOIT/past_files/error_%J.error
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=500MB
#SBATCH --cpus-per-task=30


# uses older versino of qsiprep because new versino of qsiprep doesn't have reconall, and doing reconall seperately results in dwi T1 registration errors.... 

docker run --rm --name CHA_fs_reconstruction \
-v /scratch/connectome/dyhan316/CHA_preprocessing/try_with_one/cha_input/:/data:ro \
-v /scratch/connectome/dyhan316/CHA_preprocessing/try_with_one/cha_output/:/out \
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
--nthreads 30 \
--infant \
