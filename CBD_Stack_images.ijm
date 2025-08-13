//불러올 파일 고르기
//파일이 들어있는 폴더 위치 선언, 파일을 넣을 폴더 위치 선언
#@ String (visibility=MESSAGE, value="Directory Settings", required=false) msg1
#@ File(label = "Input directory (Lined Images)", style = "directory") inputFolder
#@ File(label = "Output directory (Stacked Images)", style = "directory") outputFolder
#@ String (visibility=MESSAGE, value="Colocalization Settings", required=false) msg2
#@ Integer(label="Select Number for source", value=1, min=1, max=12, style="spinner") realNumber
#@ String(label="File name to stacked images", value="Stacked_Image") save_name

#@ String (visibility=MESSAGE, value="Aberration correction settings for NanoJ", required=false) msg3
#@ Integer(label="Reference channel", value=1) ref_channel
#@ Integer(label="Number of channels in dataset", value=12) num_channel
#@ Float   (label="Max expected shift (default 0, 0 - auto)", style="format:0.00",value=0) maxShift
#@ Integer(label="Blocks per axis (default: 5)", value=5) BperA
#@ Float   (label="Min similarity (default: 0.5)", style="slider,format:0.00", min=0, max=1, stepSize=0.01, value=0.5) minSim
#@ Float   (label="Gaussian blur radius (all channels, 0 applies no blur)",value=0.00,style="format:0.00") GblurRad
#@ Boolean (label="Apply channel - realignment to dataset", value=true,persist=false) appChk


inputFolder = inputFolder + File.separator
outputFolder = outputFolder + File.separator
//inputFolder에서 파일 목록 뽑기
list = getFileList(inputFolder);
//모든 사진 꺼내기
for (i = 0; i < list.length; i++){
	open_image(inputFolder, list[i]);
}
targetNumber = realNumber-1;//1~12를 0~11로 변환하기
for (i = 0; i < list.length; i++){
	if (i!=targetNumber) {//같으면 넘어가기
	run("Align Image by line ROI", "source="+list[i]+" target="+list[targetNumber]+" rotate");
	selectWindow(list[i]);
	close(); //닫기
	}	
}
now_time = get_time();
File.makeDirectory(outputFolder + now_time + File.separator);
run("Images to Stack", "name=Stack title=[] use");
run("16-bit");


if (appChk)
	{lastStr = " apply";
	}
else
	{lastStr = "";
	}
	
run("Register Channels - Estimate", "reference="+ref_channel+" number="+num_channel+
" max="+maxShift+" blocks="+BperA+" min="+minSim+" gaussian="+GblurRad+lastStr);
run("16-bit");
run("Stack to Hyperstack...", "order=xyczt(default) channels=12 slices=1 frames=1 display=Color");

saveAs("Tiff", outputFolder + now_time + File.separator+ save_name);// 그린 파일 저장
waitForUser("Autosave to "+outputFolder + now_time + File.separator+ save_name); 
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
