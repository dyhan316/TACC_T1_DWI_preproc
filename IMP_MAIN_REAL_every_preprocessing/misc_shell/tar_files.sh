#!/bin/bash
#SBATCH --job-name=tar_stuff
#SBATCH --partition=long #normal can only last 24 hrs
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=31:50:00
#SBATCH --output=./shell_output/tar_output%A_%x.out
#SBATCH --error=./shell_output/tar_error%A_%x.err
#SBATCH --mail-user=dyhan0316@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --account=TG-IBN180001
#SBATCH --cpus-per-task=30

#where to unzip to
#unzip_path=/work2/08834/tg881334/stampede2/CHA_preproc/CHA_data_unzip/2016-2021/dicom_2016_2021/missing
#unzip_path=/work2/08834/tg881334/stampede2/CHA_preproc/CHA_data_unzip/2010-2015/dicom_2010_2015/normal

tar -cf /work2/08834/tg881334/stampede2/CHA_preproc/CHA_data_unzip/2016-2021.tar /work2/08834/tg881334/stampede2/CHA_preproc/CHA_data_unzip/2016-2021



#file to unzip
#zip_path=/work2/08834/tg881334/stampede2/CHA_preproc/CHA_data/missing_CHA
#zip_path=/work2/08834/tg881334/stampede2/CHA_preproc/CHA_data/missing_CHA
#zip_path=/work2/08834/tg881334/stampede2/CHA_preproc/CHA_data/normal_CHA


#unzip -q $zip_path/*2015* -d $unzip_path/2015
#unzip -q $zip_path/*2014* -d $unzip_path/2014
#unzip -q $zip_path/*2013* -d $unzip_path/2013
#unzip -q $zip_path/*2012* -d $unzip_path/2012
#unzip -q $zip_path/*2011* -d $unzip_path/2011
#unzip -q $zip_path/*2010* -d $unzip_path/2010

#cd $path/2021
#unzip -q $path/2021/2021.zip

#cd $path
#zip -r -q 2013.zip $path/2013
#zip -r -q 2014.zip $path/2014

#cd /storage/bigdata/CHA_bigdata/download_CHA_other_years/normal
#zip -r -q 2010.zip /storage/bigdata/CHA_bigdata/download_CHA_other_years/normal/2010
#zip -r -q 2011.zip /storage/bigdata/CHA_bigdata/download_CHA_other_years/normal/2011
#zip -r -q 2012.zip /storage/bigdata/CHA_bigdata/download_CHA_other_years/normal/2012
#zip -r -q 2015.zip /storage/bigdata/CHA_bigdata/download_CHA_other_years/normal/2015
#zip -r -q 2017.zip /storage/bigdata/CHA_bigdata/download_CHA_other_years/normal/2017
#zip -r -q 2018.zip /storage/bigdata/CHA_bigdata/download_CHA_other_years/normal/2018

