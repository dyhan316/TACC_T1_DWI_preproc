#!/bin/bash
#SBATCH --job-name=zip_stuff
#SBATCH --partition=flat-quadrant #normal can only last 24 hrs
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=21:50:00
#SBATCH --output=./shell_output/zip_output%A_%x.out
#SBATCH --error=./shell_output/zip_error%A_%x.err
#SBATCH --mail-user=dyhan0316@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --account=TG-IBN180001
#SBATCH --cpus-per-task=30

#where to unzip to
#unzip_path=/work2/08834/tg881334/stampede2/CHA_preproc/CHA_data_unzip/2016-2021/dicom_2016_2021/missing
#unzip_path=/work2/08834/tg881334/stampede2/CHA_preproc/CHA_data_unzip/2010-2015/dicom_2010_2015/normal




#file to zip
#zip_path=/work2/08834/tg881334/stampede2/CHA_preproc/CHA_data/missing_CHA
#zip_path=/work2/08834/tg881334/stampede2/CHA_preproc/CHA_data/missing_CHA
#zip_path=/work2/08834/tg881334/stampede2/CHA_preproc/CHA_data/normal_CH

#zip -r -q /work2/08834/tg881334/stampede2/CHA_preproc/CHA_data_unzip/2010_2015.zip /work2/08834/tg881334/stampede2/CHA_preproc/CHA_data_unzip/2010-2015
#zip -r -q /work2/08834/tg881334/stampede2/CHA_preproc/CHA_data_unzip/2016_2021.zip /work2/08834/tg881334/stampede2/CHA_preproc/CHA_data_unzip/2016-2021
cp -r /work2/08834/tg881334/stampede2/CHA_preproc/CHA_data_unzip/2010-2015 /work2/08834/tg881334/stampede2/CHA_preproc/CHA_data_unzip/2010-2015_backup
