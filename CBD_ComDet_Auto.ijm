#@ String (visibility=MESSAGE, value="Detection settings for ComDet", required=false) msg4
#@ File(label = "Output directory (Stacked Images)", style = "directory") outputFolder
#@ String(label="File name to result", value="result") save_name
#@ Integer(label="Number of channels in dataset", value=12) num_channel
#@ Float   (label="Max distance between colocalized spots", style="format:0.00",value=4.00) spot_pix
#@ Float   (label="Approximate particle size (pixels)", style="format:0.00",value=3.00) pixel
#@ Float   (label="intensity threshold (in SD)", style="format:0.00",value=5.00) around

str_command = "calculate max="+spot_pix+" rois=Rectangles add=[All detections] summary=Reset";
for (i = 0; i < num_channel; i++)
{	str_command = str_command+" ";
	str_command = str_command+"ch"+i+"a="+pixel+" ";
	str_command = str_command+"ch"+i+"s="+around;
}
now_time = get_time();
run("Detect Particles", str_command);
File.makeDirectory(outputFolder +File.separator+ now_time + File.separator);
saveAs("Tiff", outputFolder +File.separator+ now_time + File.separator+ save_name);// 그린 파일 저장

selectWindow("Results");
saveAs("Results", outputFolder +File.separator+ now_time + File.separator+save_name+"_Results.csv");
selectWindow("Summary");
saveAs("Results", outputFolder +File.separator+ now_time + File.separator+save_name+"_Summary.csv");
waitForUser("FILES:\n"+save_name+".tif"+"\nResults.csv"+"\nSummary.csv"+"\n \nAutosave to "+outputFolder + File.separator+ now_time); 
//getDateAndTime(year, month, dayOfMonth, hour, minute, second);



function open_image(input, filename) {
        open(input + filename);
}

function get_time(){
     MonthNames = newArray("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec");
     DayNames = newArray("Sun", "Mon","Tue","Wed","Thu","Fri","Sat");
     getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
     TimeString =DayNames[dayOfWeek]+"-";
     if (dayOfMonth<10) {TimeString = TimeString+"0";}
     TimeString = TimeString+dayOfMonth+"-"+MonthNames[month]+"-"+year;
     return TimeString;
  }
