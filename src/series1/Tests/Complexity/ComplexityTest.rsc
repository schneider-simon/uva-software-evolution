module series1::Tests::Complexity::ComplexityTest

import series1::Helpers::ProjectFilesHelper;

import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import series1::CyclomaticComplexity::CyclomaticComplexity;
import series1::Ranking::RangeRanks;

import IO;
import Set;
import List;
import String;

loc eclipsePath = |project://uva-software-evolution/src/resources/series1/test-code|;
	
	
public riskOverview getFileRisk(loc file) {
	M3 model = createM3FromEclipseProject(eclipsePath);
	
	Declaration declaration = createAstFromFile(file, true);
	list[Declaration] methods = [dec | /Declaration dec := declaration, dec is method || dec is constructor || dec is initializer];
	
	return cyclomaticLinesPerPartion(methods, model);
}


test bool complexityLowTest() {

	loc fileToTest = |project://uva-software-evolution/src/resources/series1/test-code/complexity/ComplexityL.java|;
	riskOverview risk = getFileRisk(fileToTest);

	return risk.low != 0 && risk.normal == 0 && risk.high == 0 && risk.veryHigh == 0;
}

test bool complexityLowLowTest() {

	loc fileToTest = |project://uva-software-evolution/src/resources/series1/test-code/complexity/ComplexityLL.java|;
	riskOverview risk = getFileRisk(fileToTest);

	return risk.low != 0 && risk.normal == 0 && risk.high == 0 && risk.veryHigh == 0;
}


test bool complexityNormalTest() {

	loc fileToTest = |project://uva-software-evolution/src/resources/series1/test-code/complexity/ComplexityM.java|;
	riskOverview risk = getFileRisk(fileToTest);
	
	return risk.low == 0 && risk.normal != 0 && risk.high == 0 && risk.veryHigh == 0;
}

test bool complexityLowNormalTest() {

	loc fileToTest = |project://uva-software-evolution/src/resources/series1/test-code/complexity/ComplexityLM.java|;
	riskOverview risk = getFileRisk(fileToTest);
	
	return risk.low == 0 && risk.normal != 0 && risk.high == 0 && risk.veryHigh == 0;
}


test bool complexityHighTest() {

	loc fileToTest = |project://uva-software-evolution/src/resources/series1/test-code/complexity/ComplexityH.java|;
	riskOverview risk = getFileRisk(fileToTest);
	
	return risk.low == 0 && risk.normal == 0 && risk.high != 0 && risk.veryHigh == 0;
}

test bool complexityLowHighTest() {

	loc fileToTest = |project://uva-software-evolution/src/resources/series1/test-code/complexity/ComplexityLH.java|;
	riskOverview risk = getFileRisk(fileToTest);
	
	return risk.low == 0 && risk.normal == 0 && risk.high != 0 && risk.veryHigh == 0;
}

test bool complexityVeryHighTest() {

	loc fileToTest = |project://uva-software-evolution/src/resources/series1/test-code/complexity/ComplexityVH.java|;
	riskOverview risk = getFileRisk(fileToTest);
	
	return risk.low == 0 && risk.normal == 0 && risk.high == 0 && risk.veryHigh != 0;
}

test bool complexityLowVeryHighTest() {

	loc fileToTest = |project://uva-software-evolution/src/resources/series1/test-code/complexity/ComplexityLVH.java|;
	riskOverview risk = getFileRisk(fileToTest);
	
	return risk.low == 0 && risk.normal == 0 && risk.high == 0 && risk.veryHigh != 0;
}
