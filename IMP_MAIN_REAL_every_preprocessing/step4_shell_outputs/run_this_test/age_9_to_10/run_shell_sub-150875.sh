#! /bin/bash
module load tacc-singularity
singularity run --cleanenv -B /scratch/08834/tg881334/CHA_preproc/2.one_BIDS/age_9_to_10/sub-150875/:/data:ro,/scratch/08834/tg881334/CHA_preproc/3.qsipreproc_results/age_9_to_10/sub-150875/:/out,/work2/08834/tg881334/stampede2/CHA_preproc/CHA_preproc_supplementary_files:/freesurfer /work2/08834/tg881334/stampede2/CHA_preproc/CHA_preproc_supplementary_files/qsiprep-0.14.3.sif /data /out participant -w /out/tmp --output_resolution 1.2 --denoise_after_combining --unringing_method mrdegibbs --b0_to_t1w_transform Affine --intramodal_template_transform SyN --do_reconall --fs-license-file /freesurfer/license.txt --skip_bids_validation --nthreads 4
