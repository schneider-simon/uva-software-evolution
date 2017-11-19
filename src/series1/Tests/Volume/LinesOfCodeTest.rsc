	module series1::Tests::Volume::LinesOfCodeTest

import series1::Helpers::ProjectFilesHelper;
import series1::Helpers::StringHelper;
import series1::Helpers::BenchmarkHelper;
import IO;
import List;
import String;

test bool commentInStringLocTest(){
	loc file = |project://uva-software-evolution/src/resources/series1/test-code/volume/CommentInStrings.java|;
	
	str source = readFile(file);
	
	list[str] codeLines = getCodeLines(source);
	
	println(codeLines);
	
	return size(codeLines) == 3;
}

test bool linesOfCodeTest1(){
	loc file = |project://uva-software-evolution/src/resources/series1/test-code/volume/FourteenLinesOfCode.java|;
	
	str source = readFile(file);
	
	list[str] codeLines = getCodeLines(source);
	
	return size(codeLines) == 14;
}

test bool commentsOnlyLocTest(){
	loc file = |project://uva-software-evolution/src/resources/series1/test-code/volume/CommentsOnly.java|;
	
	str source = readFile(file);
	
	list[str] codeLines = getCodeLines(source);
	
	return size(codeLines) == 0;
}