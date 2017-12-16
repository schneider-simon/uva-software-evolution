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
	writeAnalyses("test-project", |project://TestJavaProject/|);
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

	for(int i <- [1..(3+1)]) {
		cloneDetectionResult result = doAnalyses(ast,i);
			
		startMeasure("ToJson");	
		str output = cloneResultToJson(cloneResult, location, size(codeLines));
		stopMeasure("ToJson");	
		
		loc outputLocation = toLocation("file:///tmp/rascal_output/<name>_<i>.json");
	
		writeFile(outputLocation, output);
		println("Output location: <outputLocation>");
		
	}
}

/*
	Runes the analyses on a eclipse project
*/
public str doAnalyses(set[Declaration] ast, int cloneType) {

	bool normalizeAST = cloneType != 1;
	real minimalSimularity = cloneType == 3 ? minimalSimularityT3 : 100.0;

	startMeasure("DetectClones");	
	
	cloneDetectionResult cloneResult = doCloneDetection(ast, normalizeAST, minimumCodeSize, minimalNodeGroupSize, minimalSimularity);
	iprintln(cloneResult.connections);
	
	stopMeasure("DetectClones");	
		
	return cloneResult;
}
