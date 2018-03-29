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

## Load UKBB
library(ukbtools)
library(testit)
PATH = '~/ukbiobank'
load(file.path(PATH, 'ukbiobank.varfix.RData'))
load(file.path(PATH, 'vars.RData'))

vars=names(my_ukb_data)
N=nrow(my_ukb_data)

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

## Query ICD diags
load(file.path(PATH, 'ICD.RData'))

F40 = F400 = F401 = F402 = F408 = F409 = rep(FALSE, N)
F41 = F410 = F411 = F412 = F413 = F418 = F419 = rep(FALSE, N)
hasAnxietyDiag = rep(FALSE, N)
hasMentalDiag = rep(FALSE, N)
hasOtherMentalDiag = rep(FALSE, N)
hasNeuroDiag = rep(FALSE, N)
hasHeadInjury = rep(FALSE, N)

for (i in 1:N) {
  
   icd=ICD[[i]]
   
   if (is.data.frame(icd)) {
     # specific diagnoses F40
     F40[i] =any(grepl('^F40$', icd$code))
     F400[i]=any(grepl('^F400$', icd$code))
     F401[i]=any(grepl('^F401$', icd$code))
     F402[i]=any(grepl('^F402$', icd$code))
     F408[i]=any(grepl('^F408$', icd$code))
     F409[i]=any(grepl('^F409$', icd$code))
     # specific diagnoses F41
     F41[i] =any(grepl('^F41$', icd$code))
     F410[i]=any(grepl('^F410$', icd$code))
     F411[i]=any(grepl('^F411$', icd$code))
     F412[i]=any(grepl('^F412$', icd$code))
     F413[i]=any(grepl('^F413$', icd$code))
     F418[i]=any(grepl('^F418$', icd$code))
     F419[i]=any(grepl('^F419$', icd$code))
     
     # has anxiety F40 or F41
     hasAnxietyDiag[i]=any(grepl('^F40|^F41', icd$code))
     hasMentalDiag[i]=any(grepl('^F', icd$code))
     hasOtherMentalDiag[i]=any(grepl('^F[4][2-9]|^F[^4]', icd$code)) # match any F but not F40* or F41*
     hasNeuroDiag[i]=any(grepl('^G', icd$code))
     hasHeadInjury[i]=any(grepl('^S0', icd$code))
   }
}

# some sanity checks
assert((F40|F400|F401|F402|F408|F409|F41|F410|F411|F412|F413|F418|F419) == hasAnxietyDiag)

MYUKBB=data.frame(eid=as.factor(my_ukb_data$eid),
                  sex=my_ukb_data$sex_0_0,                    
                  age0=my_ukb_data$age_when_attended_assessment_centre_0_0,
                  age1=my_ukb_data$age_when_attended_assessment_centre_1_0,
                  age2=my_ukb_data$age_when_attended_assessment_centre_2_0,
                  age_approx=2015-my_ukb_data$year_of_birth_0_0, # improve precision by using month?
                  #age_approx2=2015.7-(my_ukb_data$year_of_birth_0_0 + as.numeric(my_ukb_data$month_of_birth_0_0)/12), # improve precision by using month?
                  F40=F40, F400=F400, F401=F401, F402=F402, F408=F408, F409=F409,
                  F41=F41, F410=F410, F411=F411, F412=F412, F413=F413, F418=F418, F419=F419,
                  hasAnxietyDiag=hasAnxietyDiag, hasMentalDiag=hasMentalDiag, hasOtherMentalDiag=hasOtherMentalDiag,
                  hasNeuroDiag=hasNeuroDiag, hasHeadInjury=hasHeadInjury
                  )
idx = is.na(MYUKBB$age2)
MYUKBB$age2_ = MYUKBB$age2
MYUKBB$age2_[idx]= MYUKBB$age_approx[idx] # new age2 (imaging follow up) variable without missings
# summary(my_ukb_data$date_of_attending_assessment_centre_2_0)

#summary(MYUKBB$age_approx-MYUKBB$age2)
#summary(MYUKBB$age_approx2-MYUKBB$age2)

isPatient = hasAnxietyDiag & !hasNeuroDiag & !hasHeadInjury & !hasOtherMentalDiag
isControl = !hasMentalDiag & !hasNeuroDiag & !hasHeadInjury

patients=subset(MYUKBB, subset = isPatient)
controls_=subset(MYUKBB, subset = isControl)

## Matched samples 
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

## Sanity checks
summary(patients)
summary(controls)

assert(sum(patients$eid %in% controls$eid) == 0)

subjects = rbind(controls, patients)
subjects$group = as.factor(c(rep("control", N/2),rep("patient", N/2)))
subjects=subjects[order(subjects$eid),]

#save(subjects, file = file.path(PATH, 'groups.RData'))

## Load groups and demographic descriptives 
PATH = '~/ukbiobank'
load(file.path(PATH, 'groups.RData'))

# write subjetd eid file
write(as.character(subjects$eid), file='~/Drive/UKBB-MH/results/subjectsN158.txt', ncolumns = 1)
