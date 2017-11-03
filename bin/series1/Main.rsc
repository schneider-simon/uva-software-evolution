module series1::Main

import IO;
import List;
import Set;

import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import series1::Volume::LinesOfCode;

import series1::Helpers::ProjectFilesHelper;
import series1::ClomaticComplexity::CyclomaticComplexity;

/*
	Will exexute the meterics on a test project
*/
public void testExampleJavaProject() {
	doAnalyses(|project://uva-software-evolution/src/javaProjects|);
}

/*
	Runes the analyses on a eclipse project
*/
public void doAnalyses(loc eclipsePath) {
 
	//Create M3 model
	M3 model = createM3FromEclipseProject(eclipsePath);

	//Get a list off all files that are relevant to test
	list[loc] files = toList(methods(model));
	list[loc] projectMethods = getProjectFiles(files); 
	
	//Get the total lines of code to do some metrix
	int totalLinesOfCode = getTotalLocsForLocations(projectMethods)["code"];

	//Get cyclomatic complexity partitions
	map[str, int] cyclomaticPartitions = cyclomaticLinesPerPartion(projectMethods, model);
	printCyclomaticComplexity(cyclomaticPartitions, totalLinesOfCode);

}

public void printCyclomaticComplexity(map[str,int] complexity, int linesOfCode) {

	int pMid = complexity["mid"] * 100 / linesOfCode;
	int pHigh = complexity["high"] * 100 / linesOfCode;
	int pVHigh= complexity["very high"] * 100 / linesOfCode;
	
	println("Cyclomatic complexity:");
	println("Mid: <pMid>");
	println("High: <pHigh>");
	println("Very high: <pVHigh>");
	print("Complexity rating: ");
	if(pMid > 50 || pHigh > 15 || pVHigh > 5) 
		println("--");
	else if(pMid > 40 || pHigh > 10 || pVHigh > 0) 
		println("-");
	else if(pMid > 30 || pHigh > 5 || pVHigh > 0) 
		println("o");
	else if(pMid > 25 || pHigh > 0 || pVHigh > 0) 
		println("+");
	else
		println("++");
}