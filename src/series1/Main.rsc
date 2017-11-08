module series1::Main

import IO;
import List;
import Set;

import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import series1::Volume::LinesOfCode;
import series1::Ranking::Ranks;

import series1::Helpers::ProjectFilesHelper;
import series1::CyclomaticComplexity::CyclomaticComplexity;

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
	list[loc] files = toList(files(model));
	list[loc] projectFiles = getProjectFiles(files); 
	
	//Get the total lines of code to do some metrix
	int totalLinesOfCode = getTotalLocsForLocations(projectFiles)["code"];

	//Extract all the methods
	list[Declaration] declarations = [ createAstFromFile(file, true) | file <- projectFiles]; 
	list[Declaration] methods = [];
	for(int i <- [0 .. size(declarations)]) {
		methods = methods + [dec | /Declaration dec := declarations[i], dec is method];
	}

	//Get cyclomatic complexity partitions
	Ranking cyclomaticComplexityRank = getCyclomaticComplexityRating(methods, totalLinesOfCode, model);
	iprintln("cyclomaticComplexityRank: <cyclomaticComplexityRank>");
}

