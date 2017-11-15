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

alias DuplicationOptions = tuple[int threshhold];

public DuplicationOptions defaultDuptlicationOptions = <6>;

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

set[int] testDuplication(){
	DuplicationOptions options = <6>;
	list[str] cleanedLines = preprocessLines(TEST_LINES_1, options);
	set[int] duplicates = findDuplicates(cleanedLines, options);
	
	iprintln(sort(toList(duplicates)));
	iprintln(size(duplicates));
	
	return duplicates;
	
}

set[int] findDuplicates(list[str] lines, DuplicationOptions options){
	set[int] duplicates = {};
	
	int s1 = 0;
	
	while(s1 < size(lines)){
		duplicates = duplicates + findDuplicatesStartingFromLine(lines, s1, options);
		s1 += 1;
	}
	
		
	return duplicates;
}

set[int] findDuplicatesStartingFromLine(list[str] lines, int s1, DuplicationOptions options){
	str lineS1 = lines[s1];
	
	set[int] duplicateLineNumbers = {};
	
	int s2 = s1 + 1;//TODO: Use threshhold to move faster
	while(s2 < size(lines)){
		str lineS2 = lines[s2];
		
		if(linesAreDuplicate(lineS1, lineS2)){
			list[str] duplicate = findLargestDuplicate(lines, s1, s2);
			
			if(size(duplicate) >= options.threshhold){
				int end1 = s1 + size(duplicate);
				int end2 = s2 + size(duplicate);
				
				set[int] duplicateLinesS1 = toSet([s1..end1]);
				set[int] duplicateLinesS2 = toSet([s2..end2]);
			
				duplicateLineNumbers = duplicateLineNumbers + duplicateLinesS1 + duplicateLinesS2;
			}
		}
		
		s2 += 1;
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
		trimmedLines = push(trimmedLine, trimmedLines);
	
		if(!(trimmedLine in linesCountings)){
			linesCountings[trimmedLine] = 1;
		} else {
			linesCountings[trimmedLine] += 1;
		}
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

