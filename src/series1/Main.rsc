module series1::Main

import IO;
import List;
import Set;
import String;
import util::ValueUI;
import series1::TestQuality::TestQuality;


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
import series1::UnitSize::UnitSize;
import series1::UnitInterfacing::UnitInterfacing;


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
	M3 model = createM3FromEclipseProject(eclipsePath);

	//Get a list off all files that are relevant to test
	println("Getting files...");
	list[loc] files = toList(files(model));
	
	println("Getting project files...");
	list[loc] projectFiles = getProjectFiles(files);
	 
	println("Getting code lines from files...");
	list[str] codeLines = getCodeLinesFromFiles(projectFiles);
	
	//Get the total lines of code to do some metrix
	println("Getting lines of code...");
	int totalLinesOfCode = size(codeLines);
	ManYearsRanking manYearsRanking = getManYearsRanking(totalLinesOfCode);
	println("Got lines of code: <totalLinesOfCode>");

	//Extract all the methods
	println("Extracting methods...");
	list[Declaration] declarations = [ createAstFromFile(file, true) | file <- projectFiles]; 
	list[Declaration] methods = [];
	for(int i <- [0 .. size(declarations)]) {
		methods = methods + [dec | /Declaration dec := declarations[i], dec is method || dec is constructor || dec is initializer];
		//TODO: Maybe remove initializers
	}
	
	println("Getting assertions in test classes..");
	int assertions = getAssertionsInTestClasses(declarations);
	int methodCount = size(methods);
	Ranking testRanking = getTestRankingBasedOnMethods(assertions, methodCount);
	println("Assertions: <assertions> in <methodCount> methods");
	println("Ranking: <testRanking>");

	println("Extracted methods.");
	list[loc] methodLocations = [method.src | Declaration method <- methods];
	
	//Getting unit interfacing metric
	println("Getting unit interfacing metric.");
	map[str,int] interfaceMetric = getUnitInterfacing(declarations);
	Ranking interfacingRank = getUnitInterfacingRating(interfaceMetric);
	iprintln("Got unit interfacing rank: <interfacingRank>");
	
	//Get cyclomatic complexity partitions
	println("Getting Cyclomatic complexity");
	Ranking cyclomaticComplexityRank = getCyclomaticComplexityRating(methods, model, totalLinesOfCode);
	println("Got cyclomatic complexity: <cyclomaticComplexityRank>");
	
	//Getting code duplicates
	println("Getting code duplicates");
	set[int] duplicates = findDuplicatesFaster(getCodeLinesFromFiles(projectFiles));
	int duplicateLines = size(duplicates);	
	Ranking duplicationRanking = getDuplicationRanking(duplicateLines, totalLinesOfCode);
	println("Got code duplicates: <size(duplicates)>");
	
	//Gett unit size
	println("Getting unit size...");
	UnitSizesPerLocation unitSizesLocations = getUnitSizesPerLocation(methodLocations);
	Ranking unitSizesRanking = getUnitSizeRanking(unitSizesLocations);
	println("Got unit size.");

	CodeProperties codeProperties = emptyCodeProperties;
	codeProperties.volume = manYearsRanking.rankingType;
	codeProperties.complexityPerUnit = cyclomaticComplexityRank;
	codeProperties.duplication = duplicationRanking;
	codeProperties.unitInterfacing = interfacingRank;
	codeProperties.unitSize = unitSizesRanking;
	codeProperties.unitTesting = neutral;
	//TODO: Remove unit testing - brings rating back to neutral
	
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
