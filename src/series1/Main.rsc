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
import series1::Configuration;

import series1::Helpers::ProjectFilesHelper;
import series1::Helpers::OutputHelper;
import series1::Helpers::BenchmarkHelper;
import series1::CyclomaticComplexity::CyclomaticComplexity;
import series1::Volume::ManYears;
import series1::Volume::LinesOfCode;
import series1::UnitSize::UnitSize;
import series1::UnitInterfacing::UnitInterfacing;
import series1::Ranking::RangeRanks;
import DateTime;

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
	startMeasure("LoadEclipseProject");
	M3 model = createM3FromEclipseProject(eclipsePath);
	stopMeasure("LoadEclipseProject");

	//Get a list off all files that are relevant to test
	println("Getting files...");
	startMeasure("GetFilesListFromModel");
	list[loc] files = toList(files(model));
	stopMeasure("GetFilesListFromModel");
	
	println("Getting project files...");
	startMeasure("GetProjectFilesList");
	list[loc] projectFiles = getProjectFiles(files);
	stopMeasure("GetProjectFilesList");
	
	startMeasure("Analyse");
		
	println("Getting code lines from files...");
	list[str] codeLines = getCodeLinesFromFiles(projectFiles);
	
	//Get the total lines of code to do some metrix
	println("Getting lines of code...");
	int totalLinesOfCode = size(codeLines);
	ManYearsRanking manYearsRanking = getManYearsRanking(totalLinesOfCode);
	println("Got lines of code: <totalLinesOfCode>");

	//Get code duplicates
	println("Getting code duplicates");
	list[str] codesLinesForDuplicates = codeLines;
	
	if(DUPLICATON_RESPECT_FILE_PAGE_BREAKS){
		codesLinesForDuplicates = getCodeLinesFromFiles(projectFiles, <true>);
	}
	
	set[int] duplicates = findDuplicatesFaster(codesLinesForDuplicates);
	int duplicateLines = size(duplicates);	
	Ranking duplicationRanking = getDuplicationRanking(duplicateLines, totalLinesOfCode);
	println("Got code duplicates: <size(duplicates)>, <rankingToString(duplicationRanking)>");

	//Extract all the methods with initializers
	println("Extracting methods...");
	list[Declaration] declarations = [ createAstFromFile(file, true) | file <- projectFiles]; 
	list[Declaration] methods = [];
	for(int i <- [0 .. size(declarations)]) {
		methods = methods + [dec | /Declaration dec := declarations[i], dec is method || dec is constructor || dec is initializer];
	}
	println("Extracted methods: <size(methods)>");
	
	println("Getting assertions in test classes..");
	list[Declaration] classItems = [];
	for(int i <- [0 .. size(declarations)]) {
		classItems = classItems + [dec | /Declaration dec := declarations[i], dec is class];
	}
	
	int assertions = getAssertionsInTestClasses(classItems);
	int methodCount = size(methods);
	Ranking testRanking = getTestRankingBasedOnMethods(assertions, methodCount);
	println("Assertions: <assertions> in <methodCount> methods, <rankingToString(testRanking)>");

	println("Extracted methods.");
	list[loc] methodLocations = [method.src | Declaration method <- methods];
	
	//Getting unit interfacing metric
	println("Getting unit interfacing metric..");
	interfacingOverview interfaceMetric = getUnitInterfacing(declarations);
	riskOverview risksList = getInterfacingRisksCount(interfaceMetric);
	Ranking interfacingRank = getUnitInterfacingRating(interfaceMetric, risksList);
	println("Got unit interfacing rank: <rankingToString(interfacingRank)>");
	
	//Get cyclomatic complexity partitions
	println("Getting Cyclomatic complexity");
	Ranking cyclomaticComplexityRank = getCyclomaticComplexityRating(methods, model, totalLinesOfCode);
	println("Got cyclomatic complexity rank: <rankingToString(cyclomaticComplexityRank)>");
	
	//Get unit size
	println("Getting unit size...");
	UnitSizesPerLocation unitSizesLocations = getUnitSizesPerLocation(methodLocations);
	Ranking unitSizesRanking = getUnitSizeRanking(unitSizesLocations);
	println("Got unit size: <rankingToString(unitSizesRanking)>");

	CodeProperties codeProperties = emptyCodeProperties;
	codeProperties.volume = manYearsRanking.rankingType;
	codeProperties.complexityPerUnit = cyclomaticComplexityRank;
	codeProperties.duplication = duplicationRanking;
	codeProperties.unitInterfacing = interfacingRank;
	codeProperties.unitSize = unitSizesRanking;
	codeProperties.unitTesting = testRanking;
	
	printSeperator();
	println("Properties:");
	printSubSeperator();
	outputProperties(codeProperties);
	printSeperator();
	println("Scores:");
	printSubSeperator();
	outputScores(codeProperties);
	printSeperator();
	
	stopMeasure("Analyse");
	
	list[HeadValue] resultMapping = getCodeResultMapping(codeProperties);
	list[HeadValue] firstResults = [
		<"Date", printDateTime(now())>,
		<"Project", "<eclipsePath>">,
		<"Duplicate Lines", "<duplicateLines>">,
		<"Lines of code", "<size(codeLines)>">,
		<"Amount of methods", "<size(methods)>">
	];
	
	resultMapping = firstResults  + resultMapping;
	writeCsv(CSV_OUTPUT, resultMapping);
	println("Report was written to: <CSV_OUTPUT>");
	printSeperator();
	println("\n");
	printThankYou();
	println("\n");
	println("\t For using a SchneiderSaess solution.");
	
}
