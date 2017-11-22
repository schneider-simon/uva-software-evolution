module series1::Tests::TestQuality::TestQualityTest

import series1::Helpers::ProjectFilesHelper;

import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import series1::TestQuality::TestQuality;

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
	list[Declaration] classItems = [dec | /Declaration dec := declaration, dec is class];
	
	int assertions = getAssertionsInTestClasses(classItems);
	int methodCount = size(methods);

	return getTestRankingBasedOnMethods(assertions, methodCount);
}


test bool qualityVeryLowTest() {

	loc fileToTest = |project://uva-software-evolution/src/resources/series1/test-code/testQuality/QualityVeryLow.java|;
	Ranking risk = getFileRisk(fileToTest);

	return risk == veryNegative;
}

test bool qualityMLowLowTest() {
	return getTestRankingBasedOnMethods(0,100) == veryNegative;
}

test bool qualityMLowTest() {
	return getTestRankingBasedOnMethods(49,100) == veryNegative;
}

test bool qualityLowTest() {

	loc fileToTest = |project://uva-software-evolution/src/resources/series1/test-code/testQuality/QualityLow.java|;
	Ranking risk = getFileRisk(fileToTest);

	return risk == negative;
}

test bool qualityMLowNormalTest() {
	return getTestRankingBasedOnMethods(50,100) == negative;
}

test bool qualityMNormalTest() {
	return getTestRankingBasedOnMethods(99,100) == negative;
}


test bool qualityNormalTest() {

	loc fileToTest = |project://uva-software-evolution/src/resources/series1/test-code/testQuality/QualityNormal.java|;
	Ranking risk = getFileRisk(fileToTest);

	return risk == neutral;
}

test bool qualityMLowNormalTest() {
	return getTestRankingBasedOnMethods(100,100) == neutral;
}

test bool qualityMNormalTest() {
	return getTestRankingBasedOnMethods(199,100) == neutral;
}

test bool qualityHighTest() {

	loc fileToTest = |project://uva-software-evolution/src/resources/series1/test-code/testQuality/QualityHigh.java|;
	Ranking risk = getFileRisk(fileToTest);

	return risk == positive;
}

test bool qualityMLowHighTest() {
	return getTestRankingBasedOnMethods(200,100) == positive;
}

test bool qualityMHighTest() {
	return getTestRankingBasedOnMethods(299,100) == positive;
}

test bool qualityVeryHighTest() {

	loc fileToTest = |project://uva-software-evolution/src/resources/series1/test-code/testQuality/QualityVeryHigh.java|;
	Ranking risk = getFileRisk(fileToTest);

	return risk == veryPositive;
}

test bool qualityMLowVeryHighTest() {
	return getTestRankingBasedOnMethods(300,100) == veryPositive;
}

test bool qualityMVeryHighTest() {
	return getTestRankingBasedOnMethods(100000,100) == veryPositive;
}

test bool qualityAutoTest(int val) {
	val = abs(val);
	
	Ranking rank = getTestRankingBasedOnMethods(val, 100);
	if(rank == veryPositive && val >= 300) {
		return true;
	}
	if(rank == positive && val >= 200 && val < 300) {
		return true;
	}
	if(rank == neutral && val >= 100 && val < 200) {
		return true;
	}
	if(rank == negative && val >= 50 && val < 100) {
		return true;
	}
	if(rank == veryNegative && val >= 0 && val < 50) {
		return true;
	}
	
	return false;
}


