import numpy as np
import sys
import nrrd

if (len(sys.argv) < 3):
    print 'Error: missing arguments!' 
    print 'e.g. python PreProcess.py image_ch1.nrrd image_ch2.nrrd'
else:
    #if (len(sys.argv) > 2):
        #outfile = str(sys.argv[3])
    #else:
        #outfile = str(sys.argv[2])
            
    print 'Processing %s and %s...'% (str(sys.argv[1]), str(sys.argv[2]))
    data1, header = nrrd.read(str(sys.argv[1]))
    data2, header = nrrd.read(str(sys.argv[2]))
    size = np.array(data1.shape) -1
    print data2.shape
    print size
    
    s = 10
    
    d1 = int(round(size[0] / s))
    d2 = int(round(size[1] / s))
    d3 = int(round(size[2] / s))
    print d1
    print d2
    print d3
    
    
    Rs1 = np.zeros([s,s,s])
    Rs2 = np.zeros([s,s,s])
    
    iy=0
    for y in range(d1+2, size[0], d1):
        ix=0
        for x in range(d2+2, size[1], d2):
            iz=0
            for z in range(d3+1, size[2], d3):
                #print '(%s,%s,%s)-(%s,%s,%s)'% (iy,ix,iz,y,x,z)
                #print data2[y-d1:,x-d2:,z-d3:].shape
                Rs1[iy][ix][iz] = np.mean(data1[y-d1:y,x-d2:x,z-d3:z])
                Rs2[iy][ix][iz] = np.mean(data2[y-d1:y,x-d2:x,z-d3:z])
                #if (Rs2[iy][ix][iz] > 0):
                    #print '(%s,%s,%s)-%s'% (y,x,z,Rs2[iy][ix][iz])
                iz += 1
            ix +=1
        iy +=1
    print Rs1
    
    print '----------'
    
    print Rs2
          
    outfile='test1.nrrd'

    print 'Saving result to %s...'% outfile
    nrrd.write(outfile, np.uint8(Rs2), options=header)

print 'Done.'
