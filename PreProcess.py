import numpy as np
import sys, os
import nrrd

if (len(sys.argv) < 3):
    print 'Error: missing arguments!' 
    print 'e.g. python PreProcess.py image_ch1.nrrd image_ch2.nrrd'
else:
            
    print 'Processing %s and %s...'% (str(sys.argv[1]), str(sys.argv[2]))
    data1, header1 = nrrd.read(str(sys.argv[1]))
    data2, header2 = nrrd.read(str(sys.argv[2]))
    size = np.array(data1.shape) -1
    print 'Image size is %s pixels.'% str(data2.shape)

    
    s = 2
    d = 10
    
    d1 = int(round(size[0] / s))
    d2 = int(round(size[1] / s))
    d3 = int(round(size[2] / s))
 
    Rs1 = np.zeros([s])
    Rs2 = np.zeros([s])
    
    Rs1[0] = np.sum(data1[d1-d:d1+d,d2-d:d2+d,0:d3])
    Rs1[1] = np.sum(data1[d1-d:d1+d,d2-d:d2+d,d3:])
    Rs2[0] = np.sum(data2[d1-d:d1+d,d2-d:d2+d,0:d3])
    Rs2[1] = np.sum(data2[d1-d:d1+d,d2-d:d2+d,d3:])
    
    print Rs1
    print Rs2
    
    if ( ((Rs2[0] < Rs2[1]) and (np.sum(Rs1) <= (1.5 * np.sum(Rs2)))) or ((Rs1[0] < Rs1[1]) and (np.sum(Rs1) > (1.5 * np.sum(Rs2))))):
        print 'Flip required in Z axis'
        data1 = np.flipud(data1)
        data2 = np.flipud(data2)
        print 'Saving result to %s...'% str(sys.argv[1])
        nrrd.write(str(sys.argv[1]), data1, options=header1)
        print 'Saving result to %s...'% str(sys.argv[2])
        nrrd.write(str(sys.argv[2]), data2, options=header2)
        print 'Files saved - OK'
    
    if (np.sum(Rs1) > (1.5 * np.sum(Rs2))):   #1.5 times bias required to swap from default
        print 'BG: C1\nSG: C2'
        os.rename(str(sys.argv[1]),str(sys.argv[1]).replace('_C1','_BG'))
        os.rename(str(sys.argv[2]),str(sys.argv[2]).replace('_C2','_SG'))
        print 'Files renamed - OK'
    else:
        print 'BG: C2\nSG: C1'
        os.rename(str(sys.argv[1]),str(sys.argv[1]).replace('_C1','_SG'))
        os.rename(str(sys.argv[2]),str(sys.argv[2]).replace('_C2','_BG'))
        print 'Files renamed - OK'
    

print 'Done.'
