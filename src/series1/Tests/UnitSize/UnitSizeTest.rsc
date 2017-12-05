module series1::Tests::UnitSize::UnitSizeTest

import series1::Helpers::ProjectFilesHelper;

import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import series1::UnitSize::UnitSize;

import series1::Ranking::RangeRanks;
import series1::Ranking::Ranks;

import IO;
import Set;
import List;
import String;
import util::Math;

loc eclipsePath = |project://uva-software-evolution/src/resources/series1/test-code|;
	
public Ranking getFileRisk(loc file) {

	M3 model = createM3FromEclipseProject(eclipsePath);
	Declaration declaration = createAstFromFile(file, true);
	
	list[Declaration] methods = [dec | /Declaration dec := declaration, dec is method || dec is constructor || dec is initializer];
	list[loc] methodLocations = [method.src | Declaration method <- methods];
	
	UnitSizesPerLocation unitSizesLocations = getUnitSizesPerLocation(methodLocations);
	return getUnitSizeRanking(unitSizesLocations);
}


test bool qualityVeryLowTest() {

	loc fileToTest = |project://uva-software-evolution/src/resources/series1/test-code/testQuality/QualityVeryLow.java|;
	Ranking risk = getFileRisk(fileToTest);

	return risk == veryNegative;
}

test bool qualityLowTest() {

	loc fileToTest = |project://uva-software-evolution/src/resources/series1/test-code/testQuality/QualityLow.java|;
	Ranking risk = getFileRisk(fileToTest);

	return risk == negative;
}

test bool qualityNormalTest() {

	loc fileToTest = |project://uva-software-evolution/src/resources/series1/test-code/testQuality/QualityNormal.java|;
	Ranking risk = getFileRisk(fileToTest);

	return risk == neutral;
}

test bool qualityHighTest() {

	loc fileToTest = |project://uva-software-evolution/src/resources/series1/test-code/testQuality/QualityHigh.java|;
	Ranking risk = getFileRisk(fileToTest);

	return risk == positive;
}

test bool qualityVeryHighTest() {

	loc fileToTest = |project://uva-software-evolution/src/resources/series1/test-code/testQuality/QualityVeryHigh.java|;
	Ranking risk = getFileRisk(fileToTest);

	return risk == veryPositive;
}



