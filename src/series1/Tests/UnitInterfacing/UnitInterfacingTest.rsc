module series1::Tests::UnitInterfacing::UnitInterfacingTest

import series1::Helpers::ProjectFilesHelper;

import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import series1::UnitInterfacing::UnitInterfacing;

import series1::Ranking::RangeRanks;

import IO;
import Set;
import List;
import String;

loc eclipsePath = |project://uva-software-evolution/src/resources/series1/test-code|;
	
	
public riskOverview getFileRisk(loc file) {
	M3 model = createM3FromEclipseProject(eclipsePath);
	
	Declaration declaration = createAstFromFile(file, true);

	interfacingOverview interfaceMetric = getUnitInterfacing([declaration]);
	return getInterfacingRisksCount(interfaceMetric);
}


test bool interfacingLowTest() {

	loc fileToTest = |project://uva-software-evolution/src/resources/series1/test-code/unitInterfacing/InterfacingLow.java|;
	riskOverview risk = getFileRisk(fileToTest);

	return risk.low != 0 && risk.normal == 0 && risk.high == 0 && risk.veryHigh == 0;
}

test bool interfacingLowLowTest() {

	loc fileToTest = |project://uva-software-evolution/src/resources/series1/test-code/unitInterfacing/InterfacingLLow.java|;
	riskOverview risk = getFileRisk(fileToTest);

	return risk.low != 0 && risk.normal == 0 && risk.high == 0 && risk.veryHigh == 0;
}


test bool interfacingNormalTest() {

	loc fileToTest = |project://uva-software-evolution/src/resources/series1/test-code/unitInterfacing/InterfacingNormal.java|;
	riskOverview risk = getFileRisk(fileToTest);
	
	return risk.low == 0 && risk.normal != 0 && risk.high == 0 && risk.veryHigh == 0;
}

test bool interfacingHighTest() {

	loc fileToTest = |project://uva-software-evolution/src/resources/series1/test-code/unitInterfacing/InterfacingHigh.java|;
	riskOverview risk = getFileRisk(fileToTest);
	
	return risk.low == 0 && risk.normal == 0 && risk.high != 0 && risk.veryHigh == 0;
}

test bool interfacingVeryHighTest() {

	loc fileToTest = |project://uva-software-evolution/src/resources/series1/test-code/unitInterfacing/InterfacingVeryHigh.java|;
	riskOverview risk = getFileRisk(fileToTest);
	
	return risk.low == 0 && risk.normal == 0 && risk.high == 0 && risk.veryHigh != 0;
}

test bool interfacingLowVeryHighTest() {

	loc fileToTest = |project://uva-software-evolution/src/resources/series1/test-code/unitInterfacing/InterfacingLVeryHigh.java|;
	riskOverview risk = getFileRisk(fileToTest);
	
	return risk.low == 0 && risk.normal == 0 && risk.high == 0 && risk.veryHigh != 0;
}
