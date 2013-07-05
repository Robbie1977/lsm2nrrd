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
    
    s = 2
    
    d1 = int(round(size[0] / s))
    d2 = int(round(size[1] / s))
    d3 = int(round(size[2] / s))
    print d1
    print d2
    print d3
    
    
    Rs1 = np.zeros([s])
    Rs2 = np.zeros([s])
    
    Rs1[0] = np.sum(data1[d1-5:d1+5,d2-5:d2+5,0:d3])
    Rs1[1] = np.sum(data1[d1-5:d1+5,d2-5:d2+5,d3:])
    Rs2[0] = np.sum(data2[d1-5:d1+5,d-52:d2+5,0:d3])
    Rs2[1] = np.sum(data2[d1-5:d1+5,d2-5:d2+5,d3:])
                
    print Rs1
    
    print '----------'
    
    print Rs2
          
    #outfile='test1.nrrd'

    #print 'Saving result to %s...'% outfile
    #nrrd.write(outfile, np.uint8(Rs2), options=header)

print 'Done.'
