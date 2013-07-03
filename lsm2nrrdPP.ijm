// ImageJ macro lsm2nrrdPP.ijm Ver 3.03
// Designed to open and PreProcess 2 channel LSM (or tif) image stacks and output 2 NRRD files
// Written by Robert Court - r.court@ed.ac.uk 


name = getArgument;
if (name=="") exit ("No argument!");
setBatchMode(true);


Angle = 45; // leave positive - rotation direction automated.
Ymove = (-300);
Xmove = 0;

//run("LSM Reader", "open=[" + name + "]");
open(name);
wait(800);
ch1 = replace(replace(name, ".tif", ".lsm"), ".lsm", "-PP_C1.nrrd");
ch2 = replace(replace(name, ".tif", ".lsm"), ".lsm", "-PP_C2.nrrd");
logfile = replace(name, ".lsm", "-PP_Meta.log");
run("Split Channels");
wait(800);
slices = 0;
// we need to know only how many slices there are
getDimensions(dummy, dummy, dummy, slices, dummy);
run("Grouped Z Project...", "projection=[Max Intensity] group="+slices);
wait(300);
getMinAndMax(hmin, hmax);
wait(100);
levlog="Ch2:"+d2s(hmin,0)+","+d2s(hmax,0);
print ("Original background (min,max): " + d2s(hmin,0) + "," + d2s(hmax,0));
run("Enhance Contrast", "saturated=0.35");
wait(300);
getMinAndMax(hmin, hmax);
wait(100);
levlog=levlog+"->"+d2s(hmin,0)+","+d2s(hmax,0)+".";
print ("Adjusted to (min,max): " + d2s(hmin,0) + "," + d2s(hmax,0));

// check which channel is BG
getStatistics(dummy, C2m);
// check rotation direction
Iw = getWidth();
Ih = getHeight();
Imp = round(Iw/2);
Itp = round(Ih/10);
Iw = Iw -1;
makeRectangle(1, 1, Imp, Itp);
getStatistics(dummy, Lm);
makeRectangle(Imp, 1, Iw, Itp);
getStatistics(dummy, Rm);
if (Lm > Rm){
    Angle = Angle;
    print ("rotating clockwise " + d2s(Angle,0) + "degrees");
}else{
    print ("rotating anti-clockwise " + d2s(Angle,0) + "degrees");
    Angle = (360 - Angle);    
}

close();
wait(300);
setMinAndMax(hmin, hmax);
wait(300);
run("Rotate... ", "angle=Angle grid=1 interpolation=Bilinear enlarge stack"); //remove diagonal tilt
wait(800);

// trial measure
run("Translate...", "x=Xmove y=Ymove interpolation=None stack");
levlog=levlog+"[A:" + d2s(Angle,0) + "e,Y:" + d2s(Ymove,0) + ",X:" + d2s(Xmove,0) + "]";


// check which side is dorsal
wait(300);
midsl = round(slices/2);
run("Grouped Z Project...", "start=1 stop=" + midsl + " projection=[Max Intensity]");
wait(300);
saveAs("Tiff", "./tpm.tif");

getStatistics(dummy, tpm);
close();
wait(300);
run("Grouped Z Project...", "start=" + midsl + " stop=" + slices + " projection=[Max Intensity]");
print (midsl);
wait(300);

Dialog.show()
saveAs("Tiff", "./btm.tif");
getStatistics(dummy, btm);
close();
wait(300);

if (btm < tpm){
   run("Flip Z");
   Print ("Image was flipped!");
} 

run("8-bit");
wait(300);
run("Nrrd ... ", "nrrd=[" + ch2 + "]");
wait(800);
close();
wait(100);
run("Grouped Z Project...", "projection=[Max Intensity] group="+slices);
wait(300);
getMinAndMax(hmin, hmax);
wait(100);
levlog=levlog+"Ch1:"+d2s(hmin,0)+","+d2s(hmax,0);
print ("Original signal (min,max): " + d2s(hmin,0) + "," + d2s(hmax,0));
run("Enhance Contrast", "saturated=0.35");
wait(300);
getMinAndMax(hmin, hmax);
wait(100);
levlog=levlog+"->"+d2s(hmin,0)+","+d2s(hmax,0)+".";
print ("Adjusted to (min,max): " + d2s(hmin,0) + "," + d2s(hmax,0));

// check which channel is BG
getStatistics(dummy, C1m);

close();
wait(300);
setMinAndMax(hmin, hmax);
wait(300);
run("Rotate... ", "angle=Angle grid=1 interpolation=Bilinear enlarge stack"); //remove diagonal tilt
wait(800);

// trial measure
run("Translate...", "x=Xmove y=Ymove interpolation=None stack");
levlog=levlog+"[A:" + d2s(Angle,0) + "e,Y:" + d2s(Ymove,0) + ",X:" + d2s(Xmove,0) + "]";


if (btm < tpm){
   run("Flip Z");
   levlog=levlog+"(Z flipped)";
} 

// rename according to mean values (largest = BG)
nCh2 = ch2;
nCh1 = ch1;
if ((C2m * 1.5) > C1m){   // ch1 has to be 1.5 times ch2 to justify a swap from default
    levlog=levlog+"(Ch2 is BG)";
    print ("BG: C2");
    print ("SG: C1");
    nCh2 = replace(ch2, "C2", "BG");
    nCh1 = replace(ch1, "C1", "SG");
}else{
    levlog=levlog+"(Ch1 is BG)";
    print ("BG: C1");
    print ("SG: C2");
    nCh2 = replace(ch2, "C2", "SG");
    nCh1 = replace(ch1, "C1", "BG");
}

if (File.rename(ch2, nCh2) > 0){
    print ("File renamed OK.");
}else{
    print ("Files rename FAILED.");
}



wait(300);
run("8-bit");
wait(300);
run("Nrrd ... ", "nrrd=[" + nCh1 + "]");
wait(800);
close();

File.saveString(levlog+"\r\n", logfile);

print(tpm + "/" + btm);

run("Quit");

