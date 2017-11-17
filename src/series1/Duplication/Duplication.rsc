module series1::Duplication::Duplication

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import util::FileSystem;
import series1::Helpers::StringHelper;
import Set;
import IO;
import String;
import List;

int DUPLICATION_THRESHOLD = 6;
str UNIQUE_LINES_TOKEN = "%%%|||RASCAL_UNIQUE_LINES|||%%%%";

alias DuplicationOptions = tuple[int threshhold, bool usePruning];
public DuplicationOptions defaultDuptlicationOptions = <6, true>;

list[str] TEST_LINES_1 =  [
        "a",

        "1", "2", "3", "4", "5", "6",       // 6
        "1", "2", "3", "4", "5", "6",       // 6
        "1", "2", "3", "4", "5", "6", "7",  // 6

        "a", "b", "c", "d", "e", "f", "g", "h",      // 8
        "a", "b", "c", "d", "e", "f", "g", "h",      // 8
        "a", "b", "c", "d", "e", "f", "g", "h", "i", // 8

        "b", "c"
    ]; // 42 duplicated.
    
list[str] TEST_LINES_2 = [		// Assume treshhold = 3
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
    

set[int] testDuplication(){
	DuplicationOptions options = <3, true>;
	list[str] cleanedLines = preprocessLines(TEST_LINES_2, options);
	//cleanedLines = TEST_LINES_2;
	set[int] duplicates = findDuplicates(cleanedLines, options);
	
	iprintln(sort(toList(duplicates)));
	iprintln(size(duplicates));
	println(("" | it + l + "\n" | str l <- cleanedLines));
	
	return duplicates;
	
}

set[int] findDuplicatesFaster(list[str] lines){
	DuplicationOptions options = defaultDuptlicationOptions;
	options.usePruning = true;
	
	return findDuplicates(lines, options);
}

set[int] findDuplicates(list[str] lines){
	DuplicationOptions options = defaultDuptlicationOptions;
	options.usePruning = false;
	
	return findDuplicates(lines, options);
}

set[int] findDuplicates(list[str] lines, DuplicationOptions options){
	println("Original lines for duplicates <size(lines)>");
	lines = preprocessLines(lines, options);
	println("Reduced lines for duplicates <size(lines)>");

	set[int] duplicates = {};
	
	map[str,list[int]] linesMapping = getLinesMapping(lines);
	
	int lineNumber = 0;
	
	while(lineNumber < size(lines)){
		str line = lines[lineNumber];
		list[int] sameLines = [i | i <- linesMapping[line], i > lineNumber];
		
		duplicates = duplicates + findDuplicatesForLine(lines, lineNumber, sameLines, options);
		lineNumber += 1;
		
		if(lineNumber % 100 == 0){
			println(lineNumber);
		}
	}
	
		
	return duplicates;
}

void testLinesMapping(){
	println(getLinesMapping(TEST_LINES_1));
}

map[str,list[int]] getLinesMapping(list[str] lines){	
	map[str,list[int]] linesMapping = ();
	int i = 0;
	
	while(i < size(lines)){
		str l = lines[i];
		
		if(l in linesMapping == false){
			linesMapping[l] = [];
		}
		
		linesMapping[l] = linesMapping[l] + [i];
		i += 1;
	}
	
	return linesMapping;
}

set[int] findDuplicatesForLine(list[str] lines, int checkLine, list[int] sameLines, DuplicationOptions options){
	str lineS1 = lines[checkLine];
	
	set[int] duplicateLineNumbers = {};
	
	int i = 0;
	
	while(i < size(sameLines)){
		int sameLine = sameLines[i];
		list[str] duplicate = findLargestDuplicate(lines, checkLine, sameLine);
		
		if(size(duplicate) >= options.threshhold){
				int end1 = checkLine + size(duplicate);
				int end2 = sameLine + size(duplicate);
				
				set[int] duplicateLines1 = toSet([checkLine..end1]);
				//TODO: use lines of original code fragment? https://www.cs.usask.ca/~croy/papers/2009/RCK_SCP_Clones.pdf
				set[int] duplicateLines2 = toSet([sameLine..end2]);
			
				duplicateLineNumbers = duplicateLineNumbers + duplicateLines1 + duplicateLines2;
			}
		
		i += 1;
	}
	
	return duplicateLineNumbers;
}


list[str] findLargestDuplicate(list[str] lines, int s1, int s2){
	assert s1 < s2 : "Second line must be larger than the first line";
	
	int pointer = 0;
	
	str lineS1 = lines[s1];
	str lineS2 = lines[s2];
	
	list[str] duplicateLines = [];
		
	while(linesAreDuplicate(lineS1, lineS2)){
		duplicateLines = duplicateLines + [lineS1];
		pointer += 1;
	
		if(s2 + pointer >= size(lines)){
			break;
		}
			
		lineS1 = lines[s1 + pointer];
		lineS2 = lines[s2 + pointer];
	}
	
	return duplicateLines;
}


bool linesAreDuplicate(str line1, str line2){
	return line1 == line2 && line1 != UNIQUE_LINES_TOKEN && line2 != UNIQUE_LINES_TOKEN;
}

/**
* Remove all lines that can not be part of a duplicate.
**/
list[str] preprocessLines(list[str] lines, DuplicationOptions options){
	list[str] trimmedLines = [];	
	list[str] cleanedLines = [];
	
	map[str, int] linesCountings = ();
	
	// Count trimmed lines in order to ignore unique lines in the future
	for(str l <- lines){
		str trimmedLine = trim(l);
		
		if(trimmedLine == ""){
			continue;
		}
		
		//TODO: Do empty lines count as duplicates?
		//TODO: Should we remove "{" lines and "}" lines?
		trimmedLines = trimmedLines + [trimmedLine];
			
		if(!(trimmedLine in linesCountings)){
			linesCountings[trimmedLine] = 1;
		} else {
			linesCountings[trimmedLine] += 1;
		}
	}	
	
	if(!options.usePruning){
		return trimmedLines;
	}

	
	// Do only work with streaks (above the threshold) of non unique lines.
	// Insert a "UNIQUE LINES" token that seperates blocks of non unique lines. 
	list[str] nonUniqueLineStreak = [];
	for(str l <- trimmedLines){
		int lineOccassions = linesCountings[l];
		
		if(lineOccassions <= 1){
			if(size(nonUniqueLineStreak) >= options.threshhold){
				cleanedLines = cleanedLines + nonUniqueLineStreak + [UNIQUE_LINES_TOKEN];
			}
		
			nonUniqueLineStreak = [];
			continue;
		}
		
		nonUniqueLineStreak = nonUniqueLineStreak + [l];
	}
	
	cleanedLines = cleanedLines + nonUniqueLineStreak;
	return cleanedLines;
}

