import os
import shutil

sub_rm_list = ["sub-210008", "sub-210040","sub-200087","sub-200088","sub-200118","sub-200144","sub-200072","sub-200150"]

for sub in sub_rm_list:
	upper_dir = "/storage/bigdata/CHA_bigdata/3.qsiprep_results/"+"20{}_QSI_preproc_results".format(sub[4:6])
	freesurfer_dir = os.path.join(upper_dir, "freesurfer", sub)
	qsiprep_dir = os.path.join(upper_dir, "qsiprep", sub)
	BIDS_dir = os.path.join("/storage/bigdata/CHA_bigdata/2.dcm2niix/20{}_MRI_BIDS".format(sub[4:6]),sub)
	target_path = "/storage/bigdata/CHA_bigdata/3.qsiprep_results/crash_subjects/"
	BIDS_target_path = "/storage/bigdata/CHA_bigdata/2.dcm2niix/crash_subjects/"
	try : 
		shutil.move(BIDS_dir, os.path.join(BIDS_target_path))
	except :
		print("BIDS already moved probably")
	try : 
		shutil.move(freesurfer_dir, os.path.join(target_path, "freesurfer"))
	except :
		print("freesurfer already moved probably")
	try :
		shutil.move(qsiprep_dir, os.path.join(target_path,"qsiprep"))
	except : 
		print("qsiprep already moved probably")
	print("moved {}".format(sub))
#print(os.listdir(freesurfer_dir) == os.listdir(qsiprep_dir))
#print(os.listdir(freesurfer_dir))
#input_dir=/storage/bigdata/CHA_bigdata/1.raw_MRI/20${year}_MRI
#output_dir=/storage/bigdata/CHA_bigdata/2.dcm2niix/20${year}_MRI_BIDS #output directory



