module series1::Tests::Duplication::DuplicationTest

import series1::Duplication::Duplication;
import series1::Helpers::ProjectFilesHelper;
import IO;
import Set;
import List;

list[str] CODE_EXAMPLE_1 = [
	"a",  //0 
	"b",  //1
	"c",  //2
	"d",  //3
	"a",  //4 
	"b",  //5
	"c"   //6
];

list[str] CODE_EXAMPLE_2 = [
	"a",  //0 
	"b",  //1
	"c",  //2
	"d",  //3
	"%%", //4
	"a",  //5 
	"b",  //6
	"c",  //7
	"--", //8
	"a",  //9
	"b",  //10
	"c",  //11
	"d"   //12
];


list[str] CODE_EXAMPLE_3 = [
        "a",

        "1", "2", "3", "4", "5", "6",       // 6
        "1", "2", "3", "4", "5", "6",       // 6
        "1", "2", "3", "4", "5", "6", "7",  // 6

        "a", "b", "c", "d", "e", "f", "g", "h",      // 8
        "a", "b", "c", "d", "e", "f", "g", "h",      // 8
        "a", "b", "c", "d", "e", "f", "g", "h", "i", // 8
		
		"b", "z",
		"b", "z",
		"%",
        "b", "c"
    ]; // 42 duplicated.
    
    
list[str] CODE_EXAMPLE_4 = [		// Assume treshhold = 3
    "package java;", 			//0
"public class Duplicates {", 	//1
	"public void method1() {", 	//2
		"int a = 1;", 			//3 DUPLICATE?
		"int b = 2;",			//4 DUPLICATE?
		"int c = 3;", 			//5 DUPLICATE?
		"int d = 4;", 			//6 DUPLICATE?
	"}",							//7 DUPLICATE?
	"public void method2() {", 	//8
		"int a = 1;",			//9  DUPLICATE!
		"int b = 2;",			//10 DUPLICATE!
		"int c = 3;",			//11 DUPLICATE!
	"}",							//12
	"public void method3() {",	//13
		"int b = 2;",			//14 DUPLICATE!
		"int c = 3;",			//15 DUPLICATE!
		"int d = 4;",			//16 DUPLICATE!
	"}",							//17 DUPLICATE!
"}"								//18
];

test bool findLargestDuplicateTest(){
	list[str] duplicate = findLargestDuplicate(CODE_EXAMPLE_1, 0, 4);
	
	return duplicate == ["a","b","c"];
}

test bool findDuplicatesWithoutOriginalsTest(){
	set[int] duplicates = findDuplicates(CODE_EXAMPLE_4, <3, false, false>);
	return size(duplicates) == 7;
}

test bool findDuplicatesWithOriginalsTest(){
	set[int] duplicates = findDuplicates(CODE_EXAMPLE_4, <3, false, true>);
	return size(duplicates) == 12;
}

test bool concatinatedFilesDuplicatesTest(){
	loc file1 = |project://uva-software-evolution/src/resources/series1/test-code/duplication/File1.java|;
	loc file2 = |project://uva-software-evolution/src/resources/series1/test-code/duplication/File2.java|;
	
	list[str] lines = getCodeLinesFromFiles([file1, file2], <true>);
	set[int] duplicates = findDuplicatesFaster(lines);

	return size(duplicates) == 0;
}

test bool uniqueLinesOnlyTest(){
	loc file1 = |project://uva-software-evolution/src/resources/series1/test-code/duplication/UniqueLinesOnly.java|;
	
	list[str] lines = getCodeLinesFromFiles([file1], <true>);
	set[int] duplicates = findDuplicatesFaster(lines);
	
	return size(duplicates) == 0;
}