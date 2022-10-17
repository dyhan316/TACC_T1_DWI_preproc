import os
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

print("ASSUME THAT PREPROC_LATER AND STUFF => 이미 옮겼다고 가정!")

#tabular_path = '/storage/bigdata/CHA_bigdata/scripts_IMP/CHA_tabular_data/' #이거는 ver 1, 밑에 missing_tabular_path가 ver2여서
#밑의 것만 봐도 된다
missing_tabular_path = '../CHA_tabular_data/missing/'

###DO NOT USE TABULAR_PATH!! IT'S THE FIRST VERSION! DON'T WANT 중복
##missing_tabular_list 얻기
missing_tab_file_list = os.listdir(missing_tabular_path)



def get_year_file(year):
    for i, file_name in enumerate(missing_tab_file_list): #file돌리며 해당 연도 파일 찾기 
        if str(year) in file_name:
            file_dir = missing_tabular_path + file_name

    total_df = pd.read_excel(file_dir)
    return total_df


###define function to iterate over for removing NaN and extracting age
def partition_missing(df_file):
    file = df_file
    try : 
        file = file.dropna(subset=['파일 유무'])  #excel에서 원래 hiding함
        
        no_MRI_filter = (file['파일 유무'] != 'X')

    except : 
        print("'파일유무' didn't exist, so removing based on Unnamed: 0 instead")
        file = file.dropna(subset = ['Unnamed: 0'])
        
        no_MRI_filter = (file['Unnamed: 0'] != 'X')
    file = file[no_MRI_filter]  
    ##change to things to numeric ('1',1 두개가 다있더라..)
    file["MRI"] = pd.to_numeric(file["MRI"])
    file["DTI"] = pd.to_numeric(file["DTI"])
    
    MRI_mask, DTI_mask = file["MRI"].values == 1, file["DTI"].values == 1
    
    file_both = file[MRI_mask &  DTI_mask]
    file_MRI =  file[MRI_mask & ~ DTI_mask]
    file_DTI =  file[~MRI_mask & DTI_mask]
    file_neither = file[~MRI_mask & ~DTI_mask]
    
    return file_both, file_MRI, file_DTI, file_neither

def seperate_by_year(file, year= 4.5):
    ##get age
    mri_date = file['MRI(DTI) 시행 날짜']
    birth_date = file['Date of birth']
    
    #change age to pandas dtype : datetime64 (to get change in dates to get age)
    mri_date = pd.to_datetime(mri_date)
    birth_date = pd.to_datetime(birth_date)
    
    #compute ages
    age_days = mri_date - birth_date #age in days
    age_years = age_days/np.timedelta64(1, 'Y')
    
    ##append age_years to the dataset
    file['age'] = age_years
    
    infant_mask = file['age'] <= year
    adult_mask = file['age'] > year
    
    
    return file[infant_mask], file[adult_mask]

infant_pd = {}
adult_pd = {}


class get_info():
    def __init__(self):
        pass
     
    
    def __call__(self):
        for year in range(2010, 2021+1):
            sep_missing = partition_missing(get_year_file(year))
    
            both = sep_missing[0] #file that has both MRI and DTI 
    
            sep_both = seperate_by_year(both) #seperate by year
    
            infant_pd[str(year)] = sep_both[0]
            adult_pd[str(year)] = sep_both[1]
            print("year {} finished".format(year))
        return infant_pd, adult_pd
    #infant_pd


import os
from REAL_step0_get_infant_adult_df import get_info
import pandas as pd

#get info templates
infant_pd, adult_pd = get_info()()


import shutil
import os
import subprocess


##SETUP THINGS
#MRI_path = "/scratch/08834/tg881334/CHA_preproc/test_CHA_data"
MRI_path = "/scratch/08834/tg881334/CHA_preproc/CHA_data/not_moved_data/"
#MRI_path = "/storage/bigdata/CHA_bigdata/download_CHA_other_years/CHA_age_seperation_testing/new_test_files/" #이미 normal, missing 두개다 되어있는 것 
age_list = [1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5, 5.5, 6, 7, 8, 9, 10, 13, 16, 18,20]

##dataframe concat
infant_df_list = []
adult_df_list = []
for year in infant_pd.keys():
    infant_df_list.append(infant_pd[year].rename(columns = {"Unnamed: 0" : "파일 유무"})) #Unnamed : 0 으로 되어있는 것들을 파일유무라는 것으로 rename을 다시하기
    
for year in adult_pd.keys():
    adult_df_list.append(adult_pd[year].rename(columns = {"Unnamed: 0" : "파일 유무"})) #Unnamed : 0 으로 되어있는 것들을 파일유무라는 것으로 rename을 다시하기

#concat the things
infant_df_total = pd.concat([i for i in infant_df_list])
adult_df_total = pd.concat([i for i in adult_df_list])
total_df = pd.concat([infant_df_total, adult_df_total])


total_set = set()
for year in range(2010, 2021+1):
    total_set = total_set.union(set(get_year_file(year)['영상파일 번호'].values))



"""2. 이상한 폴더들 해서 분리하는 것 하기"""
def find_wrong_files(path): 
    #path : folder path of the DICOM files
                        ##subject_df : T1, DWI 따로따로 가능하게 하기 (partition missing의 함수의 output들을 하나하나 넣을 수 있도록)
    
    survive_files = [] #survive한 파일들 
    missing_files = []
    empty_DTI_files = []
    empty_FSPGR_files = []
    multiple_sub_files = []
    no_tabular_data = []
    
    
    ##find weird files 
    for dicom_folders in os.listdir(path):
        abs_dicom_folders = os.path.join(path, dicom_folders)
        #if DTI and FSPGR aren't the only folders, get them out
        if set(os.listdir(abs_dicom_folders)) != set(["DTI", "FSPGR"]):
            print("DTI or FSPGR folder itself missing : ", dicom_folders)
            missing_files.append(abs_dicom_folders)
            continue #stop so that the next stage (checking empty files aren't performed)(skips to the next iteration)

        #if DTI and FSPGR folders are emtpy, get them out
        if os.listdir(os.path.join(abs_dicom_folders, "DTI")) == []:
            print("DTI empty : ", dicom_folders)
            empty_DTI_files.append(abs_dicom_folders)
            continue
        
        if os.listdir(os.path.join(abs_dicom_folders, "FSPGR")) == []:
            print("FSPGR empty : ", dicom_folders)
            empty_FSPGR_files.append(abs_dicom_folders)
            continue
        
        #if folder name is -1, -2 or etc, save it to another file
        if dicom_folders.count('-') ==2:
            print("mulitple subject versions, but normal otherwise : ", dicom_folders)
            multiple_sub_files.append(abs_dicom_folders)
            continue

        #dicom 파일은 있는데 tabular이 없는 경우
        if dicom_folders not in total_set:
            print("no tabular data exists : ", dicom_folders)
            no_tabular_data.append(abs_dicom_folders)
            continue
        
        #if 위의 관문들을 통과했으면, 남겨도 되는 폴더라고 생각하고 남길 것이다 (아니라면 continue에서 걸러짐)
        survive_files.append(abs_dicom_folders)
 
    ##dict 로 return해서 그 dict에다가 mv하는 함수 쓰기 
    return {"survived_files" : survive_files,"DTI_or_FSPGR_folder_missing": missing_files, "DTI_folder_missing":empty_DTI_files, 
            "FSPGR_folder_missing" : empty_FSPGR_files, "mulitple_vers_of_subject" : multiple_sub_files, "no_tabular_data" : no_tabular_data}
            # 이파트는 그냥.... 직접 내가 하자! 사람 많지도 않은데 

    
file_dict = find_wrong_files(MRI_path)

print("missing files")
print([len(i) for i in file_dict.values()])


print(file_dict['no_tabular_data'])
