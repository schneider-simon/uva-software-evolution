module series1::Main

import IO;
import List;
import Set;
import String;


import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import series1::Volume::LinesOfCode;
import series1::Ranking::Ranks;

import series1::Helpers::ProjectFilesHelper;
import series1::CyclomaticComplexity::CyclomaticComplexity;
import series1::Volume::ManYears;
import series1::Volume::LinesOfCode;


/*
	Will exexute the meterics on a test project
*/
public void testExampleJavaProject() {
	doAnalyses(|project://uva-software-evolution/src/javaProjects/basicExample/|);
}

/*
	Will exexute the meterics on smallsql
*/
public void testSmallsqlJavaProject() {
	doAnalyses(|project://smallsql|);	
}


/*
	Will exexute the meterics on smallsql
*/
public void testHsqlJavaProject() {
	doAnalyses(|project://hsqldb|);	
}

/*
	Runes the analyses on a eclipse project
*/
public void doAnalyses(loc eclipsePath) {
 
	//Create M3 model
	iprintln("Loading eclipse project <eclipsePath>");
	M3 model = createM3FromEclipseProject(eclipsePath);

	//Get a list off all files that are relevant to test
	list[loc] files = toList(files(model));
	list[loc] projectFiles = getProjectFiles(files); 
	
	//Filter for testing
	//projectFiles = [file | file <- projectFiles, contains(file.path,"/SSDriver.java")];
	//iprintln(projectFiles);
	//Declaration decl2 = createAstFromFile(projectFiles[0], true);
	//iprintln(decl2);
		
	//Get the total lines of code to do some metrix
	iprintln("Get lines of code");
	int totalLinesOfCode = getTotalLocsForLocations(projectFiles)["code"];
	iprintln("lines of code: <totalLinesOfCode>");

	//Extract all the methods
	iprintln("Extracting methods");
	list[Declaration] declarations = [ createAstFromFile(file, true) | file <- projectFiles]; 
	list[Declaration] methods = [];
	for(int i <- [0 .. size(declarations)]) {
		methods = methods + [dec | /Declaration dec := declarations[i], dec is method || dec is constructor || dec is initializer];
	}

	//Get cyclomatic complexity partitions
	iprintln("Getting Cyclomatic complexity");
	complexityDivision division = cyclomaticLinesPerPartion(methods, model);
	Ranking cyclomaticComplexityRank = getCyclomaticComplexityRating(division, totalLinesOfCode);
	iprintln("cyclomaticComplexityRank: <cyclomaticComplexityRank>");
	iprintln("cyclomaticComplexity division <division>");
	
	//Getting code manyears
	LinesOfCodeStats linesStats = getTotalLocsForLocations(projectFiles);
	ManYearsRanking rankingStats = getManYearsRanking(linesStats["code"]);
	iprintln("Man year stats <rankingStats>");
}

