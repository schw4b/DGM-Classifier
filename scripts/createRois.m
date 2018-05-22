% by simon schwab, 2018
clear all;

PATH = '~/Data/UKBB-MH/';
Nn = 13;

rois = zeros(91, 109, 91);
rois = single(rois);

%% Extract and merge ROIS
nii_subc = load_nii([PATH 'atlas/HarvardOxford-sub-maxprob-thr25-2mm.nii.gz']);
nii_thal = load_nii([PATH 'atlas/Thalamus-maxprob-thr25-2mm.nii.gz']);
nii_cort = load_nii([PATH 'atlas/Yeo2011_17Networks_N1000_split_components_FSL_MNI152_2mm.nii.gz']);
tmp = nii_cort;

% subcortical
rois(nii_subc.img == 10) = 1;
rois(nii_subc.img == 20) = 2;
rois(nii_subc.img == 9)  = 3;
rois(nii_subc.img == 19) = 4;

% thalamus
% split mask into left and right thalamus
idx_l = nii_thal.img == 4;
idx_r = nii_thal.img == 4;
idx_r(1:45,:,:)= 0;
idx_l(45:91,:,:)= 0;

rois(idx_l) = 5;
rois(idx_r) = 6;

% cortical
rois(nii_cort.img == 26) = 7;
rois(nii_cort.img == 85) = 8;
rois(nii_cort.img == 48) = 9;
rois(nii_cort.img ==106) = 10;
rois(nii_cort.img == 30) = 11;
rois(nii_cort.img == 89) = 12;
rois(nii_cort.img == 28) = 13;
rois(nii_cort.img == 86) = 14;

tmp.img = rois;
save_nii(tmp, [PATH 'atlas/limbic.nii']);

