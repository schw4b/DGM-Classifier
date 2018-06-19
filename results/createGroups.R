## By Simon Schwab, 2018, University of Oxford.

## Load biobank
PATH = '~/ukbiobank'
file='ukbiobank.tab'
f = file.path(PATH, file)
clock = proc.time(); bd = read.table(f, header=TRUE, sep="\t", quote = "\""); print(proc.time() - clock)

## Debug column mismatch, problems are
  # 1. single quote within double quotes. Solved by specifying quote
  # 2. escaped double quote within double quotes, fixed manually
  # correct dimension is 15134x13591
  # first problem occurs with id 1087841 1088090
x = count.fields(file = f, sep = "\t", skip = 0, quote = "\"")
sum(is.na(x))
sum(x == 13591)

## Save Biobank file
# save(bd, file = file.path(PATH, 'ukbiobank.RData'))

## Load Biobank
# add the following file to the ukb8252.r file
# load(file = file.path(PATH, 'ukbiobank.RData'))

## Check variable names
vars.codes = names(bd) # orig codes
vars = names(my_ukb_data) # after running ukbtools
sum(duplicated(vars.codes))
sum(duplicated(vars))
vars[duplicated(vars)]
vars.codes[duplicated(vars)]
# 32 var names are duplicates

## example with weight ID 23098
idx = which(grepl('23098', vars.codes))
vars.codes[idx]
vars[idx]

idx = which(grepl('^weight_0_0', vars))
idx = which(grepl('^pork_intake_0_0', vars))
vars[idx]
vars.codes[idx]

## Rename duplicated variable names
vars = names(my_ukb_data) 
for ( i in which(duplicated(vars)) ) {
  vars[i] = paste('ALT', vars[i], sep = "_")
}
names(my_ukb_data) = vars

# save(my_ukb_data, file = file.path(PATH, 'ukbiobank.varfix.RData'))

## Check rs-FMRI
PATH = '~/ukbiobank'
load(file.path(PATH, 'ukbiobank.varfix.RData'))
N=nrow(my_ukb_data)
PATH_FMRI='/vols/Data/ukbiobank/FMRIB/IMAGING/data3/SubjectsAll'

## check rs fMRI
hasfMRI = rep(FALSE, N)
for (i in 1:N) {
  hasfMRI[i] = file.exists(file.path(PATH_FMRI, my_ukb_data$eid[i], 'fMRI/rfMRI.ica/reg_standard/filtered_func_data_clean.nii.gz'))
}

# save(hasfMRI, file = file.path(PATH, 'hasfMRI.RData'))

## Load UKBB
library(ukbtools)
library(testit)
PATH = '~/ukbiobank'
load(file.path(PATH, 'ukbiobank.varfix.RData'))
load(file.path(PATH, 'vars.RData'))
load(file.path(PATH, 'hasfMRI.RData'))

N=nrow(my_ukb_data)
vars=names(my_ukb_data)

## Example search variable codes
which(grepl('6138', vars.codes))
which(grepl('20002', vars.codes))

## Medical Conditions - Non-Cancer illness code, self reported (field 20002)
# after array 17+ there is no data
illness = cbind(my_ukb_data$noncancer_illness_code_selfreported_0_0,
                my_ukb_data$noncancer_illness_code_selfreported_0_1,
                my_ukb_data$noncancer_illness_code_selfreported_0_2,
                my_ukb_data$noncancer_illness_code_selfreported_0_3,
                my_ukb_data$noncancer_illness_code_selfreported_0_4,
                my_ukb_data$noncancer_illness_code_selfreported_0_5,
                my_ukb_data$noncancer_illness_code_selfreported_0_6,
                my_ukb_data$noncancer_illness_code_selfreported_0_7,
                my_ukb_data$noncancer_illness_code_selfreported_0_8,
                my_ukb_data$noncancer_illness_code_selfreported_0_9,
                my_ukb_data$noncancer_illness_code_selfreported_0_10,
                my_ukb_data$noncancer_illness_code_selfreported_0_11,
                my_ukb_data$noncancer_illness_code_selfreported_0_12,
                my_ukb_data$noncancer_illness_code_selfreported_0_13,
                my_ukb_data$noncancer_illness_code_selfreported_0_14,
                my_ukb_data$noncancer_illness_code_selfreported_0_15,
                my_ukb_data$noncancer_illness_code_selfreported_0_16,
                my_ukb_data$noncancer_illness_code_selfreported_1_0,
                my_ukb_data$noncancer_illness_code_selfreported_1_1,
                my_ukb_data$noncancer_illness_code_selfreported_1_2,
                my_ukb_data$noncancer_illness_code_selfreported_1_3,
                my_ukb_data$noncancer_illness_code_selfreported_1_4,
                my_ukb_data$noncancer_illness_code_selfreported_1_5,
                my_ukb_data$noncancer_illness_code_selfreported_1_6,
                my_ukb_data$noncancer_illness_code_selfreported_1_7,
                my_ukb_data$noncancer_illness_code_selfreported_1_8,
                my_ukb_data$noncancer_illness_code_selfreported_1_9,
                my_ukb_data$noncancer_illness_code_selfreported_1_10,
                my_ukb_data$noncancer_illness_code_selfreported_1_11,
                my_ukb_data$noncancer_illness_code_selfreported_1_12,
                my_ukb_data$noncancer_illness_code_selfreported_1_13,
                my_ukb_data$noncancer_illness_code_selfreported_1_14,
                my_ukb_data$noncancer_illness_code_selfreported_1_15,
                my_ukb_data$noncancer_illness_code_selfreported_1_16,
                my_ukb_data$noncancer_illness_code_selfreported_2_0,
                my_ukb_data$noncancer_illness_code_selfreported_2_1,
                my_ukb_data$noncancer_illness_code_selfreported_2_2,
                my_ukb_data$noncancer_illness_code_selfreported_2_3,
                my_ukb_data$noncancer_illness_code_selfreported_2_4,
                my_ukb_data$noncancer_illness_code_selfreported_2_5,
                my_ukb_data$noncancer_illness_code_selfreported_2_6,
                my_ukb_data$noncancer_illness_code_selfreported_2_7,
                my_ukb_data$noncancer_illness_code_selfreported_2_8,
                my_ukb_data$noncancer_illness_code_selfreported_2_9,
                my_ukb_data$noncancer_illness_code_selfreported_2_10,
                my_ukb_data$noncancer_illness_code_selfreported_2_11,
                my_ukb_data$noncancer_illness_code_selfreported_2_12,
                my_ukb_data$noncancer_illness_code_selfreported_2_13,
                my_ukb_data$noncancer_illness_code_selfreported_2_14,
                my_ukb_data$noncancer_illness_code_selfreported_2_15,
                my_ukb_data$noncancer_illness_code_selfreported_2_16
)


illness_depression  = rep(FALSE, N)
illness_anxiety     = rep(FALSE, N)
illness_neurotrauma = rep(FALSE, N)
illness_psychiatric = rep(FALSE, N)
illness_neurodegen  = rep(FALSE, N)
illness_MS          = rep(FALSE, N)
illness_parkinson   = rep(FALSE, N)
illness_dementia    = rep(FALSE, N)
illness_headinjury  = rep(FALSE, N)
illness_schizophr   = rep(FALSE, N)
illness_bipolar     = rep(FALSE, N)
illness_stroke      = rep(FALSE, N)
illness_demyelin    = rep(FALSE, N)
illness_guillain    = rep(FALSE, N)

for (i in 1:N) {
  illness_depression[i]  = any(illness[i,] == 1286, na.rm = T)
  illness_anxiety[i]     = any(illness[i,] == 1287, na.rm = T)
  illness_neurotrauma[i] = any(illness[i,] == 1240, na.rm = T)
  illness_psychiatric[i] = any(illness[i,] == 1243, na.rm = T)
  illness_neurodegen[i]  = any(illness[i,] == 1258, na.rm = T)
  illness_MS[i]          = any(illness[i,] == 1261, na.rm = T)
  illness_parkinson[i]   = any(illness[i,] == 1262, na.rm = T)
  illness_dementia[i]    = any(illness[i,] == 1263, na.rm = T)
  illness_headinjury[i]  = any(illness[i,] == 1266, na.rm = T)
  illness_schizophr[i]   = any(illness[i,] == 1289, na.rm = T)
  illness_bipolar[i]     = any(illness[i,] == 1291, na.rm = T)
  illness_stroke[i]      = any(illness[i,] == 1081, na.rm = T)
  illness_demyelin[i]    = any(illness[i,] == 1397, na.rm = T)
  illness_guillain[i]    = any(illness[i,] == 1256, na.rm = T)
}

## Query ICD codes
conditions = ukb_icd_keyword("F40|F41", icd.version = 10)

QUERY="F40|F400|F401|F402|F408|F409|F41|F410|F411|F412|F413|F418|F419"
QUERY="F40|F41"
pre=ukb_icd_prevalence(data = my_ukb_data, icd.version = 10, icd.code = QUERY)

## Fetch ICD diagnoses
# see fetchICD.R
                  
## Concat ICD diagnoses into a list
load(file.path(PATH, 'eids.RData'))

clock = proc.time()
ICD=list()
for (i in 1:length(eids)) {
  load(file.path(PATH, 'icd', paste(eids[i], 'RData', sep='.')))
  ICD[[i]] = icd
}
print(proc.time() - clock)

#save(ICD, file=file.path(PATH, 'ICD.RData'))

## Create Database MYUKBB to sample from (run on j00 so it can check fMRI data availability)
load(file.path(PATH, 'ICD.RData'))

F400 = F401 = F402 = F408 = F409 = rep(FALSE, N) # Phobic anxiety disorders
F410 = F411 = F412 = F413 = F418 = F419 = rep(FALSE, N) # Other anxiety disorders
F320 = F321 = F322 = F323 = F328 = F329 = rep(FALSE, N) # Depressive episode
F330 = F331 = F332 = F333 = F334 = F338 = F339 = rep(FALSE, N) # Recurrent depressive disorder

ICDAnxietyDiag     = rep(FALSE, N)
ICDDeprDiag        = rep(FALSE, N)
ICDMentalDiag      = rep(FALSE, N)
ICDOtherMentalDiag = rep(FALSE, N) # any other except anxiety and depression
ICDNeuroDiag       = rep(FALSE, N)
ICDHeadInjury      = rep(FALSE, N)

for (i in 1:N) {
  
   icd=ICD[[i]]
   
   if (is.data.frame(icd)) {
     # specific diagnoses F40
     F400[i]=any(grepl('^F400$', icd$code))
     F401[i]=any(grepl('^F401$', icd$code))
     F402[i]=any(grepl('^F402$', icd$code))
     F408[i]=any(grepl('^F408$', icd$code))
     F409[i]=any(grepl('^F409$', icd$code))
     # specific diagnoses F41
     F410[i]=any(grepl('^F410$', icd$code))
     F411[i]=any(grepl('^F411$', icd$code))
     F412[i]=any(grepl('^F412$', icd$code))
     F413[i]=any(grepl('^F413$', icd$code))
     F418[i]=any(grepl('^F418$', icd$code))
     F419[i]=any(grepl('^F419$', icd$code))
     # specific diagnoses F32
     F320[i]=any(grepl('^F320$', icd$code))
     F321[i]=any(grepl('^F321$', icd$code))
     F322[i]=any(grepl('^F322$', icd$code))
     F323[i]=any(grepl('^F323$', icd$code))
     F328[i]=any(grepl('^F328$', icd$code))
     F329[i]=any(grepl('^F329$', icd$code))
     # specific diagnoses F33
     F330[i]=any(grepl('^F330$', icd$code))
     F331[i]=any(grepl('^F331$', icd$code))
     F332[i]=any(grepl('^F332$', icd$code))
     F333[i]=any(grepl('^F333$', icd$code))
     F334[i]=any(grepl('^F334$', icd$code))
     F338[i]=any(grepl('^F338$', icd$code))
     F339[i]=any(grepl('^F339$', icd$code))
     
     # has anxiety F40 or F41
     ICDAnxietyDiag[i]     = any(grepl('^F40|^F41', icd$code))
     ICDDeprDiag[i]        = any(grepl('^F32|^F33', icd$code))
     ICDMentalDiag[i]      = any(grepl('^F', icd$code))
     ICDOtherMentalDiag[i] = any(grepl('^F[4][2-9]|^F[3][0-1|4-9]|^F[^4|^3]', icd$code)) # match any F with no F4* but still match F42 to F49
     ICDNeuroDiag[i]       = any(grepl('^G', icd$code))
     ICDHeadInjury[i]      = any(grepl('^S0', icd$code))
   }
}

# some sanity checks
assert((F400|F401|F402|F408|F409|F410|F411|F412|F413|F418|F419) == ICDAnxietyDiag)

## Lifetime Major Depression status (Smith et al.; 2013, Plos One)
def1 = my_ukb_data$ever_depressed_for_a_whole_week_0_0 == 'Yes' |
       my_ukb_data$ever_depressed_for_a_whole_week_1_0 == 'Yes' |
       my_ukb_data$ever_depressed_for_a_whole_week_2_0 == 'Yes'# 4598
def1[is.na(def1)] = FALSE

def2 = my_ukb_data$ever_unenthusiasticdisinterested_for_a_whole_week_0_0 == 'Yes' |
       my_ukb_data$ever_unenthusiasticdisinterested_for_a_whole_week_1_0 == 'Yes' |
       my_ukb_data$ever_unenthusiasticdisinterested_for_a_whole_week_2_0 == 'Yes' # 4631
def2[is.na(def2)] = FALSE

def3 = my_ukb_data$number_of_depression_episodes_0_0 == 1 | # 4620
       my_ukb_data$number_of_depression_episodes_1_0 == 1 |
       my_ukb_data$number_of_depression_episodes_2_0 == 1 | 
       my_ukb_data$number_of_unenthusiasticdisinterested_episodes_0_0 == 1 | # 5386
       my_ukb_data$number_of_unenthusiasticdisinterested_episodes_1_0 == 1 |
       my_ukb_data$number_of_unenthusiasticdisinterested_episodes_2_0 == 1
def3[is.na(def3)] = FALSE

def4 = my_ukb_data$number_of_depression_episodes_0_0 >= 2 | # 4620
       my_ukb_data$number_of_depression_episodes_1_0 >= 2 |
       my_ukb_data$number_of_depression_episodes_2_0 >= 2 |
       my_ukb_data$number_of_unenthusiasticdisinterested_episodes_0_0 >= 2 | # 5386
       my_ukb_data$number_of_unenthusiasticdisinterested_episodes_1_0 >= 2 | 
       my_ukb_data$number_of_unenthusiasticdisinterested_episodes_2_0 >= 2
def4[is.na(def4)] = FALSE

def5 = my_ukb_data$longest_period_of_depression_0_0 >= 2 | # 4609
       my_ukb_data$longest_period_of_depression_1_0 >= 2 | # 4609
       my_ukb_data$longest_period_of_depression_2_0 >= 2 |
       my_ukb_data$longest_period_of_unenthusiasm__disinterest_0_0 >= 2 | # 5375
       my_ukb_data$longest_period_of_unenthusiasm__disinterest_1_0 >= 2 |
       my_ukb_data$longest_period_of_unenthusiasm__disinterest_2_0 >= 2
def5[is.na(def5)] = FALSE

def6 = my_ukb_data$seen_doctor_gp_for_nerves_anxiety_tension_or_depression_0_0 == 'Yes' | # 2090
       my_ukb_data$seen_doctor_gp_for_nerves_anxiety_tension_or_depression_1_0 == 'Yes' |
       my_ukb_data$seen_doctor_gp_for_nerves_anxiety_tension_or_depression_2_0 == 'Yes'
def6[is.na(def6)] = FALSE

def7 = my_ukb_data$seen_a_psychiatrist_for_nerves_anxiety_tension_or_depression_0_0 == 'Yes' | # 2100
       my_ukb_data$seen_a_psychiatrist_for_nerves_anxiety_tension_or_depression_1_0 == 'Yes' |
       my_ukb_data$seen_a_psychiatrist_for_nerves_anxiety_tension_or_depression_2_0 == 'Yes'
def7[is.na(def7)] = FALSE

MD.single   = (def1 | def2) & def3 & def5 & (def6 | def7)
MD.moderate = (def1 | def2) & def4 & def5 & def6
MD.severe   = (def1 | def2) & def4 & def5 & def7

MD.all = MD.single | MD.moderate | MD.severe
MD.status = rep('none', N)
MD.status[MD.single] = 'single'
MD.status[MD.moderate] = 'moderate'
MD.status[MD.severe] = 'severe'
MD.status=as.factor(MD.status)

## Family history
which(grepl('20107', vars.codes))

string="Severe depression"

# 20107
md.father =  my_ukb_data$illnesses_of_father_0_0 == string | my_ukb_data$illnesses_of_father_0_1 == string |
             my_ukb_data$illnesses_of_father_0_2 == string | my_ukb_data$illnesses_of_father_0_3 == string |
             my_ukb_data$illnesses_of_father_0_4 == string | my_ukb_data$illnesses_of_father_0_5 == string |
             my_ukb_data$illnesses_of_father_0_6 == string | my_ukb_data$illnesses_of_father_0_7 == string |
             my_ukb_data$illnesses_of_father_0_8 == string | my_ukb_data$illnesses_of_father_0_9 == string |
             my_ukb_data$illnesses_of_father_1_0 == string | my_ukb_data$illnesses_of_father_1_1 == string |
             my_ukb_data$illnesses_of_father_1_2 == string | my_ukb_data$illnesses_of_father_1_3 == string |
             my_ukb_data$illnesses_of_father_1_4 == string | my_ukb_data$illnesses_of_father_1_5 == string |
             my_ukb_data$illnesses_of_father_1_6 == string | my_ukb_data$illnesses_of_father_1_7 == string |
             my_ukb_data$illnesses_of_father_1_8 == string | my_ukb_data$illnesses_of_father_1_9 == string |
             my_ukb_data$illnesses_of_father_2_0 == string | my_ukb_data$illnesses_of_father_2_1 == string |
             my_ukb_data$illnesses_of_father_2_2 == string | my_ukb_data$illnesses_of_father_2_3 == string |
             my_ukb_data$illnesses_of_father_2_4 == string | my_ukb_data$illnesses_of_father_2_5 == string |
             my_ukb_data$illnesses_of_father_2_6 == string | my_ukb_data$illnesses_of_father_2_7 == string |
             my_ukb_data$illnesses_of_father_2_8 == string | my_ukb_data$illnesses_of_father_2_9 == string

# 20110
md.mother =  my_ukb_data$illnesses_of_mother_0_0 == string | my_ukb_data$illnesses_of_mother_0_1 == string |
             my_ukb_data$illnesses_of_mother_0_2 == string | my_ukb_data$illnesses_of_mother_0_3 == string |
             my_ukb_data$illnesses_of_mother_0_4 == string | my_ukb_data$illnesses_of_mother_0_5 == string |
             my_ukb_data$illnesses_of_mother_0_6 == string | my_ukb_data$illnesses_of_mother_0_7 == string |
             my_ukb_data$illnesses_of_mother_0_8 == string | my_ukb_data$illnesses_of_mother_0_9 == string |
             my_ukb_data$illnesses_of_mother_0_10 == string|
             my_ukb_data$illnesses_of_mother_1_0 == string | my_ukb_data$illnesses_of_mother_1_1 == string |
             my_ukb_data$illnesses_of_mother_1_2 == string | my_ukb_data$illnesses_of_mother_1_3 == string |
             my_ukb_data$illnesses_of_mother_1_4 == string | my_ukb_data$illnesses_of_mother_1_5 == string |
             my_ukb_data$illnesses_of_mother_1_6 == string | my_ukb_data$illnesses_of_mother_1_7 == string |
             my_ukb_data$illnesses_of_mother_1_8 == string | my_ukb_data$illnesses_of_mother_1_9 == string |
             my_ukb_data$illnesses_of_mother_1_10 == string|
             my_ukb_data$illnesses_of_mother_2_0 == string | my_ukb_data$illnesses_of_mother_2_1 == string |
             my_ukb_data$illnesses_of_mother_2_2 == string | my_ukb_data$illnesses_of_mother_2_3 == string |
             my_ukb_data$illnesses_of_mother_2_4 == string | my_ukb_data$illnesses_of_mother_2_5 == string |
             my_ukb_data$illnesses_of_mother_2_6 == string | my_ukb_data$illnesses_of_mother_2_7 == string |
             my_ukb_data$illnesses_of_mother_2_8 == string | my_ukb_data$illnesses_of_mother_2_9 == string |
             my_ukb_data$illnesses_of_mother_2_10 == string

# 20111
md.siblings = my_ukb_data$illnesses_of_siblings_0_0 == string | my_ukb_data$illnesses_of_siblings_0_1 == string |
              my_ukb_data$illnesses_of_siblings_0_2 == string | my_ukb_data$illnesses_of_siblings_0_3 == string |
              my_ukb_data$illnesses_of_siblings_0_4 == string | my_ukb_data$illnesses_of_siblings_0_5 == string |
              my_ukb_data$illnesses_of_siblings_0_6 == string | my_ukb_data$illnesses_of_siblings_0_7 == string |
              my_ukb_data$illnesses_of_siblings_0_8 == string | my_ukb_data$illnesses_of_siblings_0_9 == string |
              my_ukb_data$illnesses_of_siblings_0_10 == string| my_ukb_data$illnesses_of_siblings_0_11 == string|
              my_ukb_data$illnesses_of_siblings_1_0 == string | my_ukb_data$illnesses_of_siblings_1_1 == string |
              my_ukb_data$illnesses_of_siblings_1_2 == string | my_ukb_data$illnesses_of_siblings_1_3 == string |
              my_ukb_data$illnesses_of_siblings_1_4 == string | my_ukb_data$illnesses_of_siblings_1_5 == string |
              my_ukb_data$illnesses_of_siblings_1_6 == string | my_ukb_data$illnesses_of_siblings_1_7 == string |
              my_ukb_data$illnesses_of_siblings_1_8 == string | my_ukb_data$illnesses_of_siblings_1_9 == string |
              my_ukb_data$illnesses_of_siblings_1_10 == string| my_ukb_data$illnesses_of_siblings_1_11 == string|
              my_ukb_data$illnesses_of_siblings_2_0 == string | my_ukb_data$illnesses_of_siblings_2_1 == string |
              my_ukb_data$illnesses_of_siblings_2_2 == string | my_ukb_data$illnesses_of_siblings_2_3 == string |
              my_ukb_data$illnesses_of_siblings_2_4 == string | my_ukb_data$illnesses_of_siblings_2_5 == string |
              my_ukb_data$illnesses_of_siblings_2_6 == string | my_ukb_data$illnesses_of_siblings_2_7 == string |
              my_ukb_data$illnesses_of_siblings_2_8 == string | my_ukb_data$illnesses_of_siblings_2_9 == string |
              my_ukb_data$illnesses_of_siblings_2_10 == string| my_ukb_data$illnesses_of_siblings_2_11 == string

md.father[is.na(md.father)] = FALSE
md.mother[is.na(md.mother)] = FALSE
md.siblings[is.na(md.siblings)] = FALSE
md.family = md.father | md.mother | md.siblings

# Ethnic background
ethnic_white = c("White", "British", "Irish", "Any other white background")
ethnic_mixed = c("Mixed", "White and Black Caribbean", "White and Black African", 
                 "White and Asian", "Any other mixed background")
ethnic_asian = c("Asian or Asian British", "Indian", "Pakistani", "Bangladeshi",
                 "Any other Asian background")
ethnic_black = c("Black or Black British", "Caribbean", "African",
                 "Any other Black background")
ethnic_chinese = "Chinese"
ethnic_other   = "Other ethnic group"
ethnic_noanswer= "Prefer not to answer"
ethnic_unknown = "Do not know"                 

ethnic.white = my_ukb_data$ethnic_background_0_0 %in% ethnic_white
ethnic.mixed = my_ukb_data$ethnic_background_0_0 %in% ethnic_mixed
ethnic.asian = my_ukb_data$ethnic_background_0_0 %in% ethnic_asian
ethnic.black = my_ukb_data$ethnic_background_0_0 %in% ethnic_black
ethnic.chinese = my_ukb_data$ethnic_background_0_0 %in% ethnic_chinese
ethnic.other = my_ukb_data$ethnic_background_0_0 %in% ethnic_other
ethnic.noanswer = my_ukb_data$ethnic_background_0_0 %in% ethnic_noanswer
ethnic.unknown = my_ukb_data$ethnic_background_0_0 %in% ethnic_unknown

# check mutually exclusive
assert(sum(ethnic.white + ethnic.mixed + ethnic.asian + ethnic.black + ethnic.chinese + ethnic.other + ethnic.noanswer + ethnic.unknown > 1) == 0)

ethnic.background = rep(NA, N)
ethnic.background[ethnic.white] = "white"
ethnic.background[ethnic.mixed] = "mixed"
ethnic.background[ethnic.asian] = "asian"
ethnic.background[ethnic.black] = "black"
ethnic.background[ethnic.chinese] = "chinese"
ethnic.background[ethnic.other] = "other"
ethnic.background[ethnic.noanswer] = "no answer"
ethnic.background[ethnic.unknown] = "unknown"
ethnic.background = as.factor(ethnic.background)

# age
age_approx = 2015 - my_ukb_data$year_of_birth_0_0
age = my_ukb_data$age_when_attended_assessment_centre_2_0
idx = is.na(age)
age[idx]= age_approx[idx]

# education
education = my_ukb_data$qualifications_0_0
idx=is.na(education)
education[idx] = my_ukb_data$qualifications_1_0[idx]
idx=is.na(education)
education[idx] = my_ukb_data$qualifications_2_0[idx]

# risk
worrier_anxious_feelings = my_ukb_data$worrier__anxious_feelings_0_0
idx = is.na(my_ukb_data$worrier__anxious_feelings_1_0)
worrier_anxious_feelings[!idx] = my_ukb_data$worrier__anxious_feelings_1_0[!idx]
idx = is.na(my_ukb_data$worrier__anxious_feelings_2_0)
worrier_anxious_feelings[!idx] = my_ukb_data$worrier__anxious_feelings_2_0[!idx]

seen_gp = my_ukb_data$seen_doctor_gp_for_nerves_anxiety_tension_or_depression_0_0
idx = is.na(my_ukb_data$seen_doctor_gp_for_nerves_anxiety_tension_or_depression_1_0)
seen_gp[!idx] = my_ukb_data$seen_doctor_gp_for_nerves_anxiety_tension_or_depression_1_0[!idx]
idx = is.na(my_ukb_data$seen_doctor_gp_for_nerves_anxiety_tension_or_depression_2_0)
seen_gp[!idx] = my_ukb_data$seen_doctor_gp_for_nerves_anxiety_tension_or_depression_2_0[!idx]

seen_psychiatrist = my_ukb_data$seen_a_psychiatrist_for_nerves_anxiety_tension_or_depression_0_0
idx = is.na(my_ukb_data$seen_a_psychiatrist_for_nerves_anxiety_tension_or_depression_1_0)
seen_psychiatrist[!idx] = my_ukb_data$seen_a_psychiatrist_for_nerves_anxiety_tension_or_depression_1_0[!idx]
idx = is.na(my_ukb_data$seen_a_psychiatrist_for_nerves_anxiety_tension_or_depression_2_0)
seen_psychiatrist[!idx] = my_ukb_data$seen_a_psychiatrist_for_nerves_anxiety_tension_or_depression_2_0[!idx]

## overall health
overall_health = my_ukb_data$overall_health_rating_0_0
idx = is.na(my_ukb_data$overall_health_rating_1_0)
overall_health[!idx] = my_ukb_data$overall_health_rating_1_0[!idx]
idx = is.na(my_ukb_data$overall_health_rating_2_0)
overall_health[!idx] = my_ukb_data$overall_health_rating_2_0[!idx]

longstanding_illness = my_ukb_data$longstanding_illness_disability_or_infirmity_0_0
idx = is.na(my_ukb_data$longstanding_illness_disability_or_infirmity_1_0)
longstanding_illness[!idx] = my_ukb_data$longstanding_illness_disability_or_infirmity_1_0[!idx]
idx = is.na(my_ukb_data$longstanding_illness_disability_or_infirmity_2_0)
longstanding_illness[!idx] = my_ukb_data$longstanding_illness_disability_or_infirmity_2_0[!idx]


## Create sampling Database
MYUKBB=data.frame(eid=as.factor(my_ukb_data$eid),
                  # demographics
                  sex=my_ukb_data$sex_0_0,                    
                  age, ethnic.background, education, handedness=my_ukb_data$handedness_chiralitylaterality_0_0,
                  # Risk factors
                  worrier_anxious_feelings, seen_gp, seen_psychiatrist,
                  # MD status
                  MD.all, MD.single, MD.moderate, MD.severe, MD.status,
                  # Family 
                  md.father, md.mother, md.siblings, md.family,
                  # Illness
                  illness_depression, illness_anxiety, illness_neurotrauma,
                  illness_psychiatric, illness_neurodegen, illness_MS, illness_parkinson,
                  illness_dementia, illness_headinjury, illness_schizophr, illness_bipolar,
                  illness_stroke, illness_demyelin, illness_guillain,
                  # ICD 10
                  F400, F401, F402, F408, F409,
                  F410, F411, F412, F413, F418, F419,
                  F320, F321, F322, F323, F328, F329,
                  F330, F331, F332, F333, F334, F338, F339,
                  ICDAnxietyDiag, ICDDeprDiag, ICDMentalDiag, ICDOtherMentalDiag,
                  ICDNeuroDiag, ICDHeadInjury,
                  # fMRI
                  hasfMRI,
                  # overall health
                  overall_health, longstanding_illness
                  )


# Save the database to sample the groups from:
# save(MYUKBB, file = file.path(PATH, 'MYUKBB.RData'))

## Create samples
PATH = '~/ukbiobank'
load(file = file.path(PATH, 'MYUKBB.RData'))
attach(MYUKBB)

neuro      = illness_neurotrauma | illness_neurodegen | illness_MS         | 
             illness_parkinson   | illness_dementia   | illness_headinjury |
             illness_schizophr   | illness_bipolar    | illness_stroke     | 
             illness_demyelin    | illness_guillain

healthy    = (overall_health == "Excellent" | overall_health == "Good") & longstanding_illness == "No"
healthy[is.na(healthy)] = FALSE

rightHanded = (handedness == "Right-handed")
rightHanded[is.na(rightHanded)] = FALSE

is.MD      = hasfMRI & rightHanded & !neuro &  MD.all
is.risk    = hasfMRI & rightHanded & !neuro & !MD.all & md.family
is.control = hasfMRI & rightHanded & !neuro & !MD.all & !illness_psychiatric & !illness_depression &
             !illness_anxiety & !md.family & healthy

MYUKBB$neuroExclusion=neuro
MYUKBB$isHealthy=healthy
MYUKBB$rightHanded=rightHanded
MYUKBB$is.MD=is.MD
MYUKBB$is.risk=is.risk
MYUKBB$is.control=is.control

# sample groups
set.seed(1980)
N=nrow(MYUKBB)
n=1000

a = sample(which(is.MD), n, replace = FALSE)
b = sample(which(is.risk), n, replace = FALSE)
c = sample(which(is.control), n, replace = FALSE)

selection = rep(FALSE, N)
selection[a] = TRUE
selection[b] = TRUE
selection[c] = TRUE

mydata = subset(MYUKBB, subset=selection)
#save(mydata, file = file.path(PATH, 'UKBB-MH.RData'))

# write subjetd eid file
write(as.character(mydata$eid), file='~/UKBB-MH/results/subjectsN3000.txt', ncolumns = 1)

## Matched samples (we are not using this code, we take the complete healthy sample as controls)
# For each patient we select a control of the same age and gender
set.seed(1980)
selection=rep(NA, nrow(patients))
for (i in 1:nrow(patients)) {
  matches = which((controls_$sex == patients$sex[i]) & (controls_$age2_ ==  patients$age2_[i]))
  idx = sample(matches, 1)
  while (idx %in% selection) { # check if not already selected
    idx = sample(matches, 1)
  }
  selection[i] = idx
}

assert(length(unique(selection)) == nrow(patients))
idx = rep(FALSE, nrow(controls_))
idx[selection]=TRUE
controls = subset(controls_, subset = idx)

