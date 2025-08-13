//불러올 파일 고르기
//파일이 들어있는 폴더 위치 선언, 파일을 넣을 폴더 위치 선언
#@ File(label = "Input directory (Raw Images)", style = "directory") inputFolder
#@ File(label = "Output directory (Lined Images)", style = "directory") outputFolder
//이름 바로잡기
inputFolder = inputFolder + File.separator
outputFolder = outputFolder + File.separator
//inputFolder에서 파일 목록 뽑기
list = getFileList(inputFolder);
// roimanager초기화
roiManager("reset");
setTool("Straight Line");
for (i = 0; i < list.length; i++){
        open_image(inputFolder, list[i]);
        run("32-bit");
        if (i!=0) makeLine(x[0], y[0],x[1], y[1]); //이전에 그린 파일이 있으면 자동으로 선 그리기
        //고른 파일에서 차례대로 선 그리기 
        waitForUser("Draw a line on "+list[i]); 
//        roiManager("Add");
        Roi.getCoordinates(x, y);
        saveAs("Tiff", outputFolder + Spacetounderbar(list[i]));// 그린 파일 저장
        close(); //닫기
}//다음 사진을 띄우기 반복
waitForUser("Done!");
function open_image(input, filename) {
        open(input + filename);
        AUTOBNC();
}
function AUTOBNC(){
	AUTO_THRESHOLD = 5000;
	getRawStatistics(pixcount);
	limit = pixcount/10;
	threshold = pixcount/AUTO_THRESHOLD;
	nBins = 256;
	getHistogram(values, histA, nBins);
	i = -1;
	found = false;
	do {
		counts = histA[++i];
		if (counts > limit) counts = 0;
		found = counts > threshold;
	}
	while ((!found) && (i < histA.length-1)) hmin = values[i];
	
	i = histA.length;
	do {
		counts = histA[--i];
		if (counts > limit) counts = 0; 
		found = counts > threshold;
	} 
	while ((!found) && (i > 0)) hmax = values[i];
	
	setMinAndMax(hmin, hmax);
}
function Spacetounderbar(old_string)
{
	new_string = replace(old_string, " ", "_");
return new_string;
}
