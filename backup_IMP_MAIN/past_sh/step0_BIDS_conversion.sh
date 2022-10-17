#!/bin/bash

####################################################################################################################
##########NOW that the proper inputs (extracted inputs) are made, let's change them into NIfTI and do BIDS###########
#####################################################################################################################

#MUST BE DONE ON NODE1(with no conda activation)! (NODE2에서 dwMRI conda activate해서 하면 이상하게 FSGPR이 안나옴... 
year=19
input_dir=/storage/bigdata/CHA_bigdata/download_CHA_other_years/test_2016/2016_test
output_dir=/storage/bigdata/CHA_bigdata/download_CHA_other_years/test_2016/2016_test_converted

mkdir $output_dir

for sub in $input_dir/*         #possible because we already made subject folders in the output
do
    sub_idx="${year}${sub:(-4)}"
    mkdir "${output_dir}/sub-${sub_idx}" #sub_idx : subject number #extracts the last ten (ex : 2019-C0018 from the whole /storage/bigdata/CHA_bigdata/2019-C0018 ))

#####################
    echo $sub			# this sub folder has the absolute path for each stuff!

    sub_out="${output_dir}/sub-${sub_idx}" #output directory for this specific subject
    mkdir "${sub_out}/anat"
    mkdir "${sub_out}/dwi"
    mkdir "${sub_out}/tmp"
######################

    echo `dcm2niix -b y -ba n -o ${sub_out}/tmp -z y "${sub}/"` #save to the sub_out folder

    for files in $sub_out/tmp/* #do DICOM to niix for EACH SUBJECT
    do
    echo $files
###################### anat ######################

    # && : if the one in the front is successful, proceed to the next
    # conditional statement [ $a == $b ] requires spaces between all stuff

    # t1
    if [[ "${files}" == *"FSPGR"* ]] && [[ "${files}" == *".json"* ]]
    then
        mv $files "${sub_out}/anat/sub-${sub_idx}_T1w.json"

    elif [[ "${files}" == *"FSPGR"* ]] && [[ "${files}" == *".nii.gz"* ]]
    then
        mv $files "${sub_out}/anat/sub-${sub_idx}_T1w.nii.gz"

###################### dwi ######################
    ################multishell####### (move the previous things to the tmp folder thing)
    elif [[ "${files}" == *"DTI"* ]] && [[ "${files}" == *".json"* ]]
    then
        mv $files "${sub_out}/dwi/sub-${sub_idx}_dwi.json"

    elif [[ "${files}" == *"DTI"* ]] && [[ "${files}" == *".nii.gz"* ]]
    then
        mv $files "${sub_out}/dwi/sub-${sub_idx}_dwi.nii.gz"

    elif [[ "${files}" == *"bval" ]]
    then
        mv $files "${sub_out}/dwi/sub-${sub_idx}_dwi.bval"

    elif [[ "${files}" == *"bvec" ]]
    then
        mv $files "${sub_out}/dwi/sub-${sub_idx}_dwi.bvec"
    fi
    done

#rm -r ${sub_out}/tmp #was changed!

done
