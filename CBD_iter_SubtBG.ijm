#@ String (visibility=MESSAGE, value="Select Folder incluing .tif images to subtract Background", required=false) msg3
#@ File(label = "Output directory (Stacked Images)", style = "directory") targetFolder

list = getFileList(targetFolder);
if (list.length != 0){
	File.makeDirectory(targetFolder +File.separator+"BackgroundSubtracted"+File.separator );
	for (i = 0; i < list.length; i++){
		name = split(list[i],"_");
		if (name[0] != "SB"){
			open_image(targetFolder, list[i]);
			run("Subtract Background...", "rolling=50");
			saveAs("Tiff", targetFolder +File.separator+"BackgroundSubtracted"+File.separator +list[i]);// 그린 파일 저장
	    	close(); //닫기
		}
	}//다음 사진을 띄우기 반복
	waitForUser("Done!");
	}
else 
{
	waitForUser("There is no image!");
}


function open_image(input, filename) {
        open(input +File.separator+ filename);
}