module series2::Main

import IO;
import List;
import Set;
import Map;
import String;
import util::ValueUI;
import util::Math;

import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import series2::Helpers::ReportHelper;
import series2::CloneDetection::CloneDetection;
import series2::Helpers::LogHelper;
import series2::Helpers::BenchmarkHelper;
import series2::Helpers::ProjectFilesHelper;
import series2::Helpers::StringHelper;
import series2::Helpers::OutputHelper;
import series2::Configuration;
import series2::CloneDetection::CloneExporter;

import DateTime;

public void runAll() {
	 testExampleJavaProject();
	 testSmallsqlJavaProject();
	 testHsqlJavaProject();
}

/*
	Will exexute the meterics on a test project 
*/
public void testExampleJavaProject() {
	writeAnalyses("test-project", |project://use-test-project|);
}

/*
	Will exexute the meterics on smallsql
*/
public void testSmallsqlJavaProject() {
	writeAnalyses("smallsql", |project://smallsql|);
}


/*
	Will exexute the meterics on hsqldb
*/
public void testHsqlJavaProject() {
	writeAnalyses("hsqldb", |project://hsqldb|);
}

/*
	Test and write to file
*/

public void writeAnalyses(str name, loc location) {
	//Create M3 model
	println("Loading eclipse project <location>");

	startMeasure("LoadM3");
	M3 model = createM3FromEclipseProject(location);	
	stopMeasure("LoadM3");
	
	startMeasure("CreateAsts");
	set[Declaration] ast = createAstsFromEclipseProject(location, true);
	stopMeasure("CreateAsts");
	
	startMeasure("GetFiles");
	list[loc] files = toList(files(model));
	list[loc] projectFiles = getProjectFiles(files);
	stopMeasure("GetFiles");
	
	startMeasure("GetCodeLines");
	list[str] codeLines = getCodeLinesFromFiles(projectFiles).codeLines;
	stopMeasure("GetCodeLines");

	int i = 3;
	//for(int i <- [1..(3+1)]) {
		cloneDetectionResult result = doAnalyses(ast,i);
		
		//Determine what lines are duplicates
		duplications dups = getDuplicateLinesPerFile(model,result);
		iprintln(dups);
		asd;
			
		startMeasure("ToJson");	
		str output = cloneResultToJson(result, location, size(codeLines), projectFiles);
		stopMeasure("ToJson");	
		
		loc outputLocation = toLocation("project://uva-software-evolution/output/<name>_<i>.json");
	
		writeFile(outputLocation, output);
		println("Output location: <outputLocation>");
		
	//}
}

/*
	Runes the analyses on a eclipse project
*/
public cloneDetectionResult doAnalyses(set[Declaration] ast, int cloneType) {

	bool normalizeAST = cloneType != 1;
	real minimalSimularity = cloneType == 3 ? minimalSimularityT3 : 100.0;

	startMeasure("DetectClones");	
	
	cloneDetectionResult cloneResult = doCloneDetection(ast, normalizeAST, minimumCodeSize, minimalNodeGroupSize, minimalSimularity);
	//iprintln(cloneResult.connections);
	
 	/*for(connection <- cloneResult.connections) {
 		loc la = cloneResult.nodeDetails[connection.f].l;
 		loc lb = cloneResult.nodeDetails[connection.s].l;
 		
 		str las = readFile(la);
 		str lbs = readFile(lb);
 		
 		iprintln("#########<la>");
 		iprintln("#########<lb>");
 		iprintln(las);
 		iprintln("");
 		iprintln("");
 		iprintln(lbs);
 		iprintln("");
 	}*/

	stopMeasure("DetectClones");	
		
	return cloneResult;
}
