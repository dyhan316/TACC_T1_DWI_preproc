#! /bin/bash
#SBATCH -J adult_preproc_age_10_to_20
#SBATCH -p skx-normal
#SBATCH -o /work2/08834/tg881334/stampede2/CHA_preproc/IMP_shell_scripts/IMP_MAIN_REAL_every_preprocessing/step4_shell_output/adult_preproc/age_10_to_20/output.%j
#SBATCH -e /work2/08834/tg881334/stampede2/CHA_preproc/IMP_shell_scripts/IMP_MAIN_REAL_every_preprocessing/step4_shell_output/adult_preproc/age_10_to_20/error.%j
#SBATCH -t 48:00:00
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 96
module load tacc-singularity
singularity run --cleanenv -B /scratch/08834/tg881334/CHA_preproc/2.BIDS_data/age_10_to_20/:/data:ro,/scratch/08834/tg881334/CHA_preproc/3.qsipreproc_results_REAL/age_10_to_20/:/out,/work2/08834/tg881334/stampede2/CHA_preproc/CHA_preproc_supplementary_files:/freesurfer /work2/08834/tg881334/stampede2/CHA_preproc/CHA_preproc_supplementary_files/qsiprep-0.14.3.sif /data /out participant -w /out/tmp --output_resolution 1.2 --denoise_after_combining --unringing_method mrdegibbs --b0_to_t1w_transform Affine --intramodal_template_transform SyN --do_reconall --fs-license-file /freesurfer/license.txt --skip_bids_validation --omp-nthreads 4
