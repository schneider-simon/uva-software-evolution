module series1::Tests::Duplication::DuplicationTest

import series1::Duplication::Duplication;
import IO;

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

test bool findLargestDuplicateTest(){
	list[str] duplicate = findLargestDuplicate(CODE_EXAMPLE_1, 0, 4);
	
	return duplicate == ["a","b","c"];
}

test bool findDuplicatesStartingFromLineTest(){
	list[list[str]] duplicates = findDuplicatesStartingFromLine(CODE_EXAMPLE_2, 0);
		
	return duplicates == [["a","b","c"],["a","b","c","d"]];
}


test bool findDuplicatesTest1(){
	list[list[str]] duplicates = findDuplicates(CODE_EXAMPLE_2);
		println(duplicates);
		return true;
	return duplicates == [["a","b","c"],["a","b","c","d"]];
}