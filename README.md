lsm2nrrd
========

LSM to NRRD using ImageJ/Fiji macro with optional Python and macro PreProcessing steps.


run: 

Fiji -macro lsm2nrrd[R/PP].ijm inputfilename.lsm -batch

[Python PreProcessing.py inputfilename_C1.nrrd inputfilename_C2.nrrd [C 10]]

Recomended for lsm scanned diagonally:

Fiji -macro lsm2nrrdR.ijm inputfilename.lsm -batch

Python PreProcessing.py inputfilename_C1.nrrd inputfilename_C2.nrrd C 10

Output files will be:

inputfilename_BG.nrrd
inputfilename_SG.nrrd

BackGround and SiGnal channels repectively.



