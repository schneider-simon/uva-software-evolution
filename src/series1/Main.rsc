module series1::Main

import IO;
import List;
import Set;
import String;


import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import series1::Volume::LinesOfCode;
import series1::Ranking::Ranks;
import series1::Ranking::Scores;
import series1::Duplication::Duplication;
import series1::Duplication::DuplicationRank;

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
	list[str] codeLines = getCodeLinesFromFiles(projectFiles);
	
	//Filter for testing

	//projectFiles = [file | file <- projectFiles, contains(file.path,"/Database.java")];
	
	//Get the total lines of code to do some metrix
	iprintln("Get lines of code");
	int totalLinesOfCode = size(codeLines);
	iprintln("Lines of code: <totalLinesOfCode>");

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
	ManYearsRanking manYearsRanking = getManYearsRanking(totalLinesOfCode);
	iprintln("Man year ranking <manYearsRanking>");
	
	//Getting code duplicates
	set[int] duplicates = findDuplicatesFaster(getCodeLinesFromFiles(projectFiles));
	int duplicateLines = size(duplicates);	
	Ranking duplicationRanking = getDuplicationRanking(duplicateLines, totalLinesOfCode);
	
	CodeProperties codeProperties = emptyCodeProperties;
	codeProperties.volume = manYearsRanking.rankingType;
	codeProperties.complexityPerUnit = cyclomaticComplexityRank;
	codeProperties.duplication = duplicationRanking;
	//TODO: codeProperties.unitSize = ;
	codeProperties.unitTesting = neutral;
	
	printSeperator();
	println("Properties:");
	printSubSeperator();
	outputProperties(codeProperties);
	printSeperator();
	println("Scores:");
	printSubSeperator();
	outputScores(codeProperties);
	printSeperator();
}

public void printSeperator(){
	println("=============================================");
}

public void printSubSeperator(){
	println("---------------------------------------------");
}
