module series2::Tests::LinesOfCodeTest

import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import series2::CloneDetection::CloneDetection;
import series2::Helpers::LogHelper;
import series2::Helpers::BenchmarkHelper;
import series2::Helpers::ProjectFilesHelper;
import series2::Helpers::OutputHelper;
import series2::Configuration;
import series2::CloneDetection::CloneExporter;
import series2::Helpers::ReportHelper;
import series2::Aliases;

import DateTime;
import Set;
import List;
import IO;
import Map;

loc eclipsePath = |project://use-test-project/|;

//Code swap
test bool doDupTest() {
	cloneDetectionResult result = doT3CloneDetectionLoc("dupTest", 1, 90.0);
	str indName = "";
	
	//Just geting the last ID
	for(str key <- result.duplicateLines)
		indName = key;

	return size(result.duplicateLines) == 1 && result.duplicateLines[indName] == toSet([4,5,6,8,10,11,21,22,25,31]);	
}

//Code swap
test bool hsqlErrorTest() {
	cloneDetectionResult result = doT3CloneDetectionLoc("JaasAuthBean", 0, 10.0);
	str indName = "";
	
	//Just geting the last ID
	for(str key <- result.duplicateLines)
		indName = key;
	
	return size(result.duplicateLines) == 1 && result.duplicateLines[indName] == {62,78,79,61,63,77};
}

//Do clone detection
public cloneDetectionResult doT3CloneDetectionLoc(str className, int v, real diff) {
	set[Declaration] ast = getASTForClass(className);
	M3 model = createM3FromEclipseProject(eclipsePath);
	return doCloneDetection(model, ast, true, 1, v, diff);
}

/*
	Runes the analyses on a eclipse project
*/
public set[Declaration] getASTForClass(str className) {
	set[Declaration] ast = createAstsFromEclipseProject(eclipsePath, true);
	
	//Extract the correct class
	list[Declaration] methods = [];
	set[Declaration] r = toSet(
							[class(n, a, b, c) | 
								   /Declaration dec <- ast, 
						   		   /class(n, a, b, c) := dec,
						   		   n == className]);				   
	return r;
}
