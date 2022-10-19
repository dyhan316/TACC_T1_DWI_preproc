import os
import subprocess
import argparse
from pathlib import Path
import pdb
#parser = argparse.ArgumentParser(description='Evaluate resnet50 features on ImageNet')
#parser.add_argument('data', type=Path, metavar='DIR',
#                    help='path to dataset')
#args = parser.parse_args()


#######ASSUMPTIONS######
curr_dir = os.getcwd()
class Args():
    def __init__(self, age_range):
        self.age_range = age_range#'age_4.5_to_5'
        self.base_dir = Path(curr_dir)
        self.scratch_dir = Path('/scratch/08834/tg881334/CHA_preproc') #where the BIDS and outputs are and will be saved
        self.BIDS_dir = Path(self.scratch_dir/'2.one_BIDS/{}'.format(self.age_range)) #MUST BE MODIFIED TO THE INPUT I WANT TO RUN WITH
        self.save_dir = Path(self.scratch_dir/'3.qsipreproc_results/{}'.format(self.age_range))
        self.supp_dir = Path('/work2/08834/tg881334/stampede2/CHA_preproc/CHA_preproc_supplementary_files') #directory where the singularity images and etc are held
        self.shell_dir = Path(self.base_dir / 'step4_shell_outputs/run_this_test') #where the shelll scripts for each subject will be saved
        self.log_dir = Path(self.base_dir/'step4_shell_outputs/log_outputs')
        self.sub_list = sorted(os.listdir(self.BIDS_dir))
        #age 에 관한 것이 있어야 할듯! (특히, freesurfer infant 할떄)
        self.infant = True #MUST BE CHANGED
        print("change __init__ to make sure that 'infant' is only turned on when we ARE dealing with infants")
args = Args(age_range='age_4.5_to_5')

print(args.sub_list)

os.chdir(args.base_dir)


####shell file folders

##위의 것들을 필요한 부분들만 들어서 txt file로 만들자
#단, mkdir, file_path등은 python내에서 자체적으로 하기 

sing_img_dir = args.supp_dir/"qsiprep-0.14.3.sif"#singularity image directory (0.14.3.sif for this one )

os.makedirs(args.shell_dir, exist_ok = True)
os.makedirs(args.save_dir, exist_ok = True)
for sub in args.sub_list:
    print(f"creating qsiprep .sh for subject : {sub}")
    
    sub_BIDS_dir = str(args.BIDS_dir / sub)
    sub_save_dir = str(args.save_dir / sub)
    bash_shell = ["#! /bin/bash", "module load tacc-singularity"]
    os.mkdir(args.save_dir/sub)
    
    singularity_command = f"singularity run --cleanenv -B {sub_BIDS_dir}/:/data:ro,{sub_save_dir}/:/out,{str(args.supp_dir)}:/freesurfer {sing_img_dir} /data /out participant -w /out/tmp --output_resolution 1.2 --denoise_after_combining --unringing_method mrdegibbs --b0_to_t1w_transform Affine --intramodal_template_transform SyN --do_reconall --fs-license-file /freesurfer/license.txt --skip_bids_validation" #removeed nthreads because we want to use all available
    if args.infant == True : singularity_command = singularity_command + ' --infant' #add infant option of doing infant 
    
    
    bash_shell.append(singularity_command)
    #print(f"bash_shell {bash_shell}")
    
    ##saving the shell files
    with open(f"{args.shell_dir}/run_shell_{sub}.sh", "a") as f:
        for line in bash_shell:
            f.write(f"{line}\n")

subprocess.run(f"chmod 755 {args.shell_dir}/*", shell = True)


##############IMPLEMENT : ACTUALLLY SAVING THE THING############3
#print("hihi")
os.makedirs(args.log_dir, exist_ok = True)
for sub_shell in os.listdir(args.shell_dir):
    shell_to_run = os.path.join(args.shell_dir, sub_shell)
    
    command_to_add = shell_to_run + f" >> {args.log_dir}/output-$LAUNCHER_TSK_ID"
    #print(command_to_add)
    with open(f"{args.base_dir}/step4_shell_outputs/qsipreproc_command_list.txt", "a") as f:
        f.write(f"{command_to_add}\n")

num_subs = len(args.sub_list) + 1 #had to do +1 to get every subject to be done (one process seems to be reserfved for running the thing as a whole)
subprocess.run(f"sbatch -n {num_subs} {args.base_dir}/REAL_activate_step4.sh", shell = True)
#added -n {num_subs} so that it automatically chooses the right number of jobs 
pdb.set_trace()

