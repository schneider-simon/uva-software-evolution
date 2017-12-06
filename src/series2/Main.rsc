
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
import series2::Helpers::OutputHelper;
import series2::Configuration;
import series2::CloneDetection::CloneExporter;

import DateTime;

/*
	Will exexute the meterics on a test project 
*/
public void testExampleJavaProject() {
	doAnalyses(|project://TestJavaProject/|);
}

public void testExampleJavaProject2() {
	doAnalyses(|project://TestJavaProject|);
}

/*
	Will exexute the meterics on smallsql
*/
public void testSmallsqlJavaProject() {
	doAnalyses(|project://smallsql|);
}


/*
	Will exexute the meterics on hsqldb
*/
public void testHsqlJavaProject() {
	doAnalyses(|project://hsqldb|);
}


/*
	Runes the analyses on a eclipse project
*/
public void doAnalyses(loc eclipsePath) {

	//Create M3 model
	println("Loading eclipse project <eclipsePath>");

	//startMeasure("LoadEclipseProject");
	//M3 model = createM3FromEclipseProject(eclipsePath);
	//iprintln(files(model));
	//stopMeasure("LoadEclipseProject");

	//startMeasure("LoadAST");
	M3 model = createM3FromEclipseProject(eclipsePath);
	//list[loc] files = toList(files(model));
	//list[loc] projectFiles = getProjectFiles(files);
	
	set[Declaration] ast = createAstsFromEclipseProject(eclipsePath, true);
	//iprintln(files(ast));
	//stopMeasure("LoadAST");
	
	/*
	tuple[FileLineMapping fileMapping, list[str] codeLines] filesResult = getCodeLinesFromFiles(projectFiles);
	FileLineMapping fileLineMapping = filesResult.fileMapping;
	list[str] codeLines = filesResult.codeLines;
	
	set[int] duplicateLineIndexes = getDuplicateLineIndexes(codeLines, DUPLICATION_THRESHOLD);
	DuplicationExport duplicationExport = getDuplicationExport(fileLineMapping, codeLines, duplicateLineIndexes);
	
	writeDuplicationReport(|file:///tmp/duplicationReport.rdexp|, duplicationExport);
	*/
	
	cloneDetectionResult cloneResult = doCloneDetection(ast, true, 50, 100.0);
	iprintln(cloneResult.connections);
	
	cloneResultToJson(cloneResult);
	
	/**
	for(connection <- cloneResult.connections) {
		loc la = cloneResult.nodeDetails[connection.f].l;
		loc lb = cloneResult.nodeDetails[connection.s].l;
		
		str las = readFile(la);
		str lbs = readFile(lb);
		
		iprintln("#########");
		iprintln(las);
		iprintln("");
		iprintln("");
		iprintln(lbs);
		iprintln("");
	}*/
}
