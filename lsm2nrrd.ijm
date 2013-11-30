// ImageJ macro lsm2nrrd.ijm
// Designed to open LSM (or tif) image stacks and output 1 NRRD file for each channel
// Written by Robert Court - r.court@ed.ac.uk 


name = getArgument;
if (name=="") exit ("No argument!");
parts=split(name,"/");
filename = "";
filename = parts[parts.length-1];
setBatchMode(true);

open(name);
wait(800);

// we need to know only how many channels there are
getDimensions(dummy, dummy, chn, dummy, dummy);
	
logfile = replace(replace(filename, ".tif", ".lsm"), ".lsm", "-PP_Meta.log");
if (chn > 1) {
	run("Split Channels");
	wait(400);
}else{    
    run("Split Channels");
    wait(400);
} // need a check for RGB
levlog="";
slices = 0;
// we need to know only how many slices there are
getDimensions(dummy, dummy, dummy, slices, dummy);
for (var i = 0; i < chn; i++) {
	print ("Processing channel " + d2s(chn-i,0) + "...");
	chN = "Ch" + d2s(chn-i,0);
	chF = "./" + replace(replace(filename, ".tif", ".lsm"), ".lsm", "-PP_C" + d2s((chn - i),0) + ".nrrd");
	run("Grouped Z Project...", "projection=[Max Intensity] group=" + slices);
	wait(300);
	getMinAndMax(hmin, hmax);
	wait(100);
	levlog=levlog + chN+":"+d2s(hmin,0)+","+d2s(hmax,0);
	print ("Original background (min,max): " + d2s(hmin,0) + "," + d2s(hmax,0));
	run("Enhance Contrast", "saturated=0.35");
	wait(300);
	getMinAndMax(hmin, hmax);
	wait(100);
	levlog=levlog+"->"+d2s(hmin,0)+","+d2s(hmax,0)+".";
	print ("Adjusted to (min,max): " + d2s(hmin,0) + "," + d2s(hmax,0));
	close();
	wait(300);
	setMinAndMax(hmin, hmax);
	wait(300);
	run("8-bit");
	wait(300);
	run("Nrrd ... ", "nrrd=[" + chF + "]");
	wait(400);
	close();
	wait(100);
}

File.saveString(levlog+"\r\n", "./"+logfile);

run("Quit");

