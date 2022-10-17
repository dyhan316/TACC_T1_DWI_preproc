#!/bin/bash

#SBATCH --job-name CHA_recon_only #job name을 다르게 하기 위해서
#SBATCH --nodes=1
#SBATCH --nodelist=node1
#SBATCH -t 800:00:00 # Time for running job
#SBATCH -o /storage/bigdata/CHA_bigdata/shell_scripts/shell_script_results/2021_results/step2_qsiprep_results/output_%J.out #%J : job id 가 들어가는 것
#SBATCH -e /storage/bigdata/CHA_bigdata/shell_scripts/shell_script_results/2021_results/step2_qsiprep_results/error_%J.error
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=500MB
#SBATCH --cpus-per-task=52

docker run --rm -v /scratch/connectome/dyhan316/dwMRI/license.txt:/opt/freesurfer/license.txt:ro\
 -v /storage/bigdata/CHA_bigdata/2.dcm2niix/2021_MRI_BIDS/:/data:ro\
 -v /storage/bigdata/CHA_bigdata/3.qsiprep_results/2021_QSI_preproc_results/:/qsiprep-output:ro\
 -v /storage/bigdata/CHA_bigdata/3.qsiprep_results/2021_QSI_preproc_results/freesurfer:/sngl/freesurfer-input:ro\
 -v /storage/bigdata/CHA_bigdata/3.qsiprep_results/2021_QSI_preproc_results/:/out pennbbl/qsiprep:0.15.4\
 /data /out participant --recon-input /qsiprep-output --freesurfer-input /sngl/freesurfer-input\
 --recon-spec mrtrix_multishell_msmt_ACT-hsvs --output_resolution 1.2 --denoise_after_combining\
 --unringing_method mrdegibbs --b0_to_t1w_transform Affine --intramodal_template_transform SyN\
 --nthreads 52 --omp-nthreads 4 --skip_bids_validation --recon_only --infant
