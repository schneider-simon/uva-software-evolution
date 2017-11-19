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

list[str] CODE_EXAMPLE_3 =  [
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

test bool findLargestDuplicateTest(){
	list[str] duplicate = findLargestDuplicate(CODE_EXAMPLE_1, 0, 4);
	
	return duplicate == ["a","b","c"];
}

test bool findDuplicatesStartingFromLineTest(){
	set[int] duplicates = findDuplicatesStartingFromLine(CODE_EXAMPLE_2, 0, <1>);
	return duplicates == {0,1,2,3,5,6,7,9,10,11,12};
}

test bool findDuplicatesStartingFromLineTest2(){
	set[int] duplicates = findDuplicatesStartingFromLine(CODE_EXAMPLE_2, 0, <4>);
	return duplicates == {0,1,2,3,9,10,11,12};
}

test bool findDuplicatesStartingFromLineTest3(){
	set[int] duplicates = findDuplicatesStartingFromLine(CODE_EXAMPLE_2, 0, <5>);
	return duplicates == {};
}

test bool findDuplicatesTest1(){
	set[int] duplicates = findDuplicates(CODE_EXAMPLE_2, <0>);
	return duplicates == {0,1,2,3,5,6,7,9,10,11,12};
}

test bool findDuplicatesAmountTest1(){
	set[int] duplicates = findDuplicates(CODE_EXAMPLE_3, <6>);
	return size(duplicates) == 42;
}

test bool findDuplicatesAmountTest2(){
	set[int] duplicates = findDuplicates(CODE_EXAMPLE_3, <2>);
	return size(duplicates) == 48;
}

test bool concatinatedFilesDuplicatesTest(){
	loc file1 = |project://uva-software-evolution/src/resources/series1/test-code/duplication/File1.java|;
	loc file2 = |project://uva-software-evolution/src/resources/series1/test-code/duplication/File2.java|;
	
	list[str] lines = getCodeLinesFromFiles([file1, file2]);
	iprintln(lines);
	
	return true;
}