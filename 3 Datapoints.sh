#Extract individual data points from significant MRI clusters

OutputFolder=/YourDirectory/MRIanalysis/IndividualDataPoints/S2precunCvsUC/Cued
#OutputFolder=/YourDirectory/MRIanalysis/IndividualDataPoints/S2precunCvsUC/Uncued
#OutputFolder=/YourDirectory/MRIanalysis/IndividualDataPoints/S2precunCBS2
#OutputFolder=/YourDirectory/MRIanalysis/IndividualDataPoints/S2S3precunCBS4
#OutputFolder=/YourDirectory/MRIanalysis/IndividualDataPoints/S3ssmCBS4
#OutputFolder=/YourDirectory/MRIanalysis/IndividualDataPoints/S1S3ssmCBS4vbm
#OutputFolder=/YourDirectory/MRIanalysis/IndividualDataPoints/S1S2N2vbm

cd $OutputFolder

RawData1=/YourDirectory/MRIanalysis/fMRI/1stlevelContrasts/C_S2
#RawData1=/YourDirectory/MRIanalysis/fMRI/1stlevelContrasts/UC_S2
#RawData1=/YourDirectory/MRIanalysis/fMRI/1stlevelContrasts/CUC_S2
#RawData1=/YourDirectory/MRIanalysis/fMRIovertime_S12_S23_S13/S2S3
#RawData1=/YourDirectory/MRIanalysis/fMRI/1stlevelContrasts/CUC_S3
#RawData1=/YourDirectory/MRIanalysis/VBM/GS_Files_subtracted/GM/GM_S1S3
#RawData1=/YourDirectory/MRIanalysis/VBM/GS_Files_subtracted/GM/GM_S1S2

SigResult=/YourDirectory/MRIanalysis/MRI*results/fMRI/S2/S2_FWE005_precunMask.nii
#SigResult=/YourDirectory/MRIanalysis/MRI*results/fMRI/S2_CBS2/S2_CBS2_FWE005_precunMask.nii
#SigResult=/YourDirectory/MRIanalysis/MRI*results/fMRI/S2S3_CBS4/S2S3_CBS4_FWE005_precunMask.nii
#SigResult=/YourDirectory/MRIanalysis/MRI*results/fMRI/S3_CBS4/S3_CBS4_FWE005_postcentralMask.nii
#SigResult=/YourDirectory/MRIanalysis/MRI*results/VBM/S1S3_CBS4/S1S3_CBS4_FWE005_prepostcentralMask.nii
#SigResult=/YourDirectory/MRIanalysis/MRI*results/VBM/S1S2_N2perc/S1S2_N2perc_FWE005_hippoparahippo.nii

#threshold at 0.95
fslmaths $SigResult -mul 1 thresh
thresh=$OutputFolder/thresh.nii.gz

#replacee NaNs with 0
fslmaths $thresh -nan nan0.nii
nan0=nan0.nii.gz

#binarise image
fslmaths $nan0 -bin binarisedMask
binarisedMask=$OutputFolder/binarisedMask.nii.gz
#if the above doesnt work. unzip thresh and create a mask in spm
#binarisedMask=$OutputFolder/mask.nii

#mask individual participant images with the brain_mask & get the averagde

#FAMWFT1 S1 CBS2
ppntList="p2 p3 p5 p6 p7 p8 p9 p10 p11 p12 p13 p15 p16 p17 p19 p20 p21 p22 p23 p24 p25 p26 p27 p28 p29 p30 p31 p33"
#ppntList="p2 p10 p11 p12 p13 p15 p16 p17 p19 p20 p21 p23 p24 p25 p26 p27 p28 p29 p30 p31 p33"
#ppntList="p2 p10 p11 p12 p13 p14 p15 p16 p17 p19 p20 p21 p23 p24 p25 p26 p27 p28 p29 p30 p31 p32 p33"
#ppntList="p2 p10 p11 p12 p13 p14 p15 p16 p17 p19 p20 p21 p23 p24 p25 p26 p27 p28 p29 p30 p31 p32 p33"
#ppntList="p2 p3 p5 p6 p7 p8 p9 p10 p11 p13 p14 p15 p16 p17 p19 p20 p21 p22 p23 p24 p25 p26 p27 p28 p29 p30 p31 p32 p33" #n2

mkdir -p MaskedPpnt
cd $OutputFolder/MaskedPpnt
for ppnt in $ppntList; do

ppntFile=$RawData1/"$ppnt"_con_0001.nii #<---- change end of file name
fslmaths $binarisedMask -mul $ppntFile "$ppnt"_S2cued
maskedPpnt=$OutputFolder/MaskedPpnt/"$ppnt"_S2cued.nii.gz
fslmeants -i $maskedPpnt >> av_S2cued.txt -m $binarisedMask

#ppntFile=$RawData1/"$ppnt"_con_0002.nii #<---- change end of file name
#fslmaths $binarisedMask -mul $ppntFile "$ppnt"_S2uncued
#maskedPpnt=$OutputFolder/MaskedPpnt/"$ppnt"_S2uncued.nii.gz
#fslmeants -i $maskedPpnt >> av_S2uncued.txt -m $binarisedMask

#ppntFile=$RawData1/"$ppnt"_con_0009.nii #<---- change end of file name
#fslmaths $binarisedMask -mul $ppntFile "$ppnt"_S2CBS2
#maskedPpnt=$OutputFolder/MaskedPpnt/"$ppnt"_S2CBS2.nii.gz
#fslmeants -i $maskedPpnt >> av_S2CBS2.txt -m $binarisedMask

#ppntFile=$RawData1/"$ppnt"_MWF_S2S3.nii #<---- change end of file name
#fslmaths $binarisedMask -mul $ppntFile "$ppnt"_S2S3cbS4
#maskedPpnt=$OutputFolder/MaskedPpnt/"$ppnt"_S2S3cbS4.nii.gz
#fslmeants -i $maskedPpnt >> av_S2S3cbS4.txt -m $binarisedMask

#ppntFile=$RawData1/"$ppnt"_con_0009.nii #<---- change end of file name
#fslmaths $binarisedMask -mul $ppntFile "$ppnt"_S3cbS4
#maskedPpnt=$OutputFolder/MaskedPpnt/"$ppnt"_S3cbS4.nii.gz
#fslmeants -i $maskedPpnt >> av_S3cbS4.txt -m $binarisedMask

#ppntFile=$RawData1/"$ppnt"_GM_S1S3.nii #<---- change end of file name
#fslmaths $binarisedMask -mul $ppntFile "$ppnt"_S1S3cbS4
#maskedPpnt=$OutputFolder/MaskedPpnt/"$ppnt"_S1S3cbS4.nii.gz
#fslmeants -i $maskedPpnt >> av_S1S3cbS4.txt -m $binarisedMask

#ppntFile=$RawData1/"$ppnt"_GM_S1S2.nii #<---- change end of file name
#fslmaths $binarisedMask -mul $ppntFile "$ppnt"_S1S2N2
#maskedPpnt=$OutputFolder/MaskedPpnt/"$ppnt"_S1S2N2.nii.gz
#fslmeants -i $maskedPpnt >> av_S1S2N2.txt -m $binarisedMask

done
