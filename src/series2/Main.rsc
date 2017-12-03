
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

import DateTime;

/*
	Will exexute the meterics on a test project
*/
public void testExampleJavaProject() {
	doAnalyses(|project://uva-software-evolution/|);
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
	set[Declaration] ast = createAstsFromEclipseProject(eclipsePath, true);
	//stopMeasure("LoadAST");

	doCloneDetection(ast);




}
