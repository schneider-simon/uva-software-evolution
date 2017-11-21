module series1::Tests::Volume::LinesOfCodeTest

import series1::Helpers::ProjectFilesHelper;
import series1::Helpers::StringHelper;
import series1::Helpers::BenchmarkHelper;
import IO;
import List;
import String;

int SAMPLE_CODE_LINES_WITH_BRACKETS = 14;
int SAMPLE_CODE_LINES_WITHOUT_BRACKETS = 11;


test bool commentInStringLocTest(){
	loc file = |project://uva-software-evolution/src/resources/series1/test-code/volume/CommentInStrings.java|;
	
	str source = readFile(file);
	
	list[str] codeLines = getCodeLines(source, true);
		
	return size(codeLines) == 3;
}

test bool linesOfCodeTestWithBrackets(){
	loc file = |project://uva-software-evolution/src/resources/series1/test-code/volume/SampleCode.java|;
	
	str source = readFile(file);
	
	list[str] codeLines = getCodeLines(source, true);
	
	return size(codeLines) == SAMPLE_CODE_LINES_WITH_BRACKETS;
}

test bool linesOfCodeTestWithoutBrackets(){
	loc file = |project://uva-software-evolution/src/resources/series1/test-code/volume/SampleCode.java|;
	
	str source = readFile(file);
	
	list[str] codeLines = getCodeLines(source, false);
	
	return size(codeLines) == SAMPLE_CODE_LINES_WITHOUT_BRACKETS;
}

test bool commentsOnlyLocTest(){
	loc file = |project://uva-software-evolution/src/resources/series1/test-code/volume/CommentsOnly.java|;
	
	str source = readFile(file);
	
	list[str] codeLines = getCodeLines(source, true);
	
	return size(codeLines) == 0;
}

test bool addingCommentsLocTest(){
	loc commentsFile = |project://uva-software-evolution/src/resources/series1/test-code/volume/CommentsOnly.java|;
	loc sampleCodeFile = |project://uva-software-evolution/src/resources/series1/test-code/volume/SampleCode.java|;
	
	str sampleSource = readFile(sampleCodeFile);
	str commentsSource = readFile(commentsFile);
	str source = commentsSource + sampleSource + commentsSource + sampleSource + commentsSource + commentsSource;
	
	list[str] codeLines = getCodeLines(source, true);
	
	return size(codeLines) == SAMPLE_CODE_LINES_WITH_BRACKETS * 2;
}