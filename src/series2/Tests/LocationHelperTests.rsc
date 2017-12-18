module series2::Tests::LocationHelperTests

import series2::Helpers::LocationHelper;

import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import series2::CloneDetection::CloneDetection;
import series2::Helpers::LogHelper;
import series2::Helpers::BenchmarkHelper;
import series2::Helpers::ProjectFilesHelper;
import series2::Helpers::OutputHelper;
import series2::Configuration;
import series2::CloneDetection::CloneExporter;

import DateTime;
import Set;
import List;
import IO;

loc eclipsePath = |project://use-test-project/|;

//Incorrect if match
test bool incorrectIf() {
	set[int] lines = getClonesType("ifChange", 1);
	return size(lines) == 8;
}

//Code swap
test bool callMyMethodT1() {
	set[int] lines = getClonesTypeWithV("codeSwap", 1, 16);
	return size(lines) == 0;
}

test bool callMyMethodT2() {
	set[int] lines = getClonesTypeWithV("codeSwap", 2, 16);
	return size(lines) == 0;
}

test bool callMyMethodT3() {
	set[int] lines = doT3CloneDetection("codeSwap", 16, 90.0);
	return size(lines) == 0;
}

//Call method test
test bool callMyMethodT2() {
	set[int] lines = getClonesType("advancedClone", 2);
	return size(lines) == 22;
}

//Call method test
test bool callMyMethodT2() {
	set[int] lines = getClonesType("callMyMethod", 2);
	return size(lines) == 6;
}

test bool callMyMethodT1() {
	set[int] lines = getClonesType("callMyMethod", 1);
	return size(lines) == 0;
}


//Char diff test
test bool charLitTest() {
	set[int] lines = getClonesType("charLit", 2);
	return size(lines) == 6;
}

test bool charLitTestT1() {
	set[int] lines = getClonesType("charLit", 1);
	return size(lines) == 0;
}

//Annotating tests
test bool annoTest() {
	set[int] lines = getClonesType("anno", 2);
	return size(lines) == 8;
}

//Different parameter types
test bool testT3SimCorrect() {
	set[int] lines = getClonesType("params", 2);
	return size(lines) == 6;
}

//Test simularity
test bool testT3SimCorrect() {
	set[int] lines = doT3CloneDetection("detectMethodD", 6, 12.0);
	return size(lines) == 6;
}

//Test simularity
test bool testT3SimInCorrect() {
	set[int] lines = doT3CloneDetection("detectMethodD", 6, 14.0);
	return size(lines) == 4;
}

//globalWithSubClass
test bool testT2Interface() {
	set[int] lines = getClonesType("interfaceIntern", 2);
	return size(lines) == 14;
}

//globalWithSubClass type 1 only the inside statments are duplicate
test bool testT1Interface() {
	set[int] lines = getClonesTypeWithV("interfaceIntern", 1, 4);
	return size(lines) == 10;
}


//globalWithSubClass
test bool testT2SubClass() {
	set[int] lines = getClonesType("globalWithSubClass", 2);
	return size(lines) == 6;
}

//globalWithSubClass type 1 only the inside statments are duplicate
test bool testT1SubClass() {
	set[int] lines = getClonesType("globalWithSubClass", 1);
	return size(lines) == 2;
}

//Enum other name with type 2
test bool testT2EnumName() {
	set[int] lines = getClonesType("sameEnum", 2);
	return size(lines) == 6;
}

//Enum other name with type 1 = no clone
test bool testT1EnumName() {
	set[int] lines = getClonesType("sameEnum", 1);
	return size(lines) == 0;
}

//Small change for type 2 = less duplicates
test bool testT2SmallChange() {
	set[int] lines = getClonesTypeWithV("smallCodeChange", 2, 5);
	return size(lines) == 6;
}

//Small change for type 3
test bool testT3SmallChange() {
	set[int] lines = doT3CloneDetection("smallCodeChange", 5, 50.0);
	return size(lines) == 8;
}

//Change type and method name = no duplicate for type 1
test bool testT1TypeIndp() {
	set[int] lines = getClonesType("simpleTypeTypeAndName", 1);
	return lines == {};
}

//Change type and method name = duplicate for type 2
test bool testT2TypeIndp() {
	set[int] lines = getClonesType("simpleTypeTypeAndName", 2);
	return size(lines) == 6;
}

//Change type and method name = duplicate for type 3
test bool testT3TypeIndp() {
	set[int] lines = getClonesType("simpleTypeTypeAndName", 3);
	return size(lines) == 6;
}

//To large trashhold
test bool testT2TypeIndpToHighV() {
	set[int] lines = getClonesTypeWithV("simpleTypeTypeAndName", 3, 18);
	return lines == {};
}

//Do clone detection
public set[int] doT3CloneDetection(str className, int v, real diff) {
	set[Declaration] ast = getASTForClass(className);
	cloneDetectionResult cloneResult = doCloneDetection(ast, true, 1, v, diff);
	return getDuplicateLines(cloneResult);
}

public set[int] getClonesTypeWithV(str className, int ctype, int v) {
	bool clean = ctype != 1;
	real dupLevel = ctype != 3 ? 100.0 : 50.0;
	set[Declaration] ast = getASTForClass(className);
	cloneDetectionResult cloneResult = doCloneDetection(ast, clean, 1, v, dupLevel);
	return getDuplicateLines(cloneResult);
}

public set[int] getClonesType(str className, int ctype) {
	return getClonesTypeWithV(className, ctype, 10);
}

//Get duplicate lines
public set[int] getDuplicateLines(cloneDetectionResult cloneResult) {
	list[loc] lineLocations = [];
	lineLocations += [cloneResult.nodeDetails[connection.f].l | connection <- cloneResult.connections];
	lineLocations += [cloneResult.nodeDetails[connection.s].l | connection <- cloneResult.connections];
	
	list[int] lines = [];
	for(location <- lineLocations) {
		if(location == |unknown:///|)
			continue;
			
		lines += [(location.begin.line) .. (location.end.line + 1)];
	}
	
	return toSet(lines);
}

/*
	Runes the analyses on a eclipse project
*/
public set[Declaration] getASTForClass(str className) {
	set[Declaration] ast = createAstsFromEclipseProject(eclipsePath, true);
	
	//Extract the correct class
	list[Declaration] methods = [];
	set[Declaration] r = toSet(
							[class(n, a, b, c) | 
								   /Declaration dec <- ast, 
						   		   /class(n, a, b, c) := dec,
						   		   n == className]);				   
	return r;
}
