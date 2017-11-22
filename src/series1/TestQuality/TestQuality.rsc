module series1::TestQuality::TestQuality

import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import series1::Ranking::Ranks;
import series1::Configuration;

import IO;

import Set;
import List;
import String;

import util::Math;

public BoundRanking veryPositiveTestCases = <veryPositive, 300, 100000>;
public BoundRanking positiveTestCases = <positive, 200, 300>;
public BoundRanking neutralTestCases = <neutral, 100, 200>;
public BoundRanking negativeTestCases = <negative, 50, 100>;
public BoundRanking veryNegativeTestCases = <veryNegative, 0, 50>;

public list[BoundRanking] allTestCaseRankings = [veryNegativeTestCases,
												 negativeTestCases,
												 neutralTestCases,
												 positiveTestCases,
												 veryPositiveTestCases
												];  


Ranking getTestRankingBasedOnMethods(int assertions, int totalLinesOfCode) {
	return getBoundRanking(assertions * 100 / totalLinesOfCode, allTestCaseRankings).ranking;
}

public int getAssertionsInTestClasses(list[Declaration] declarations) {
	int assertions = 0;

	list[Declaration] testClasses = getTestClasses(declarations);
	for(Declaration testClass <- testClasses) {
		assertions += getAssertions(testClass);
	}
	
	return assertions;
}

public list[Declaration] getTestClasses(list[Declaration] declarations) {
	
	list[Declaration] testClasses = [];
	for(int i <- [0 .. size(declarations)]) {
		testClasses = testClasses + [dec | /Declaration dec := declarations[i], 
								   /class(_, list[Type] extends, _, _) := dec,
								   /simpleName(str name) := extends,
								   contains(name,TEST_CLASS_KEYWORD)];
	}
		
	return testClasses;	
}


private int getAssertions(Declaration testClass) {
 
 	int assertions = 0;

	visit (testClass) {
        case \assert(_): assertions += 1;
        case \assert(_, _): assertions += 1;
        case \methodCall(_, /assert/, _): assertions += 1;
        case \methodCall(_, _, /assert/, _): assertions += 1;
    }
    
    return assertions;
}


