module series1::Duplication::Duplication

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import util::FileSystem;
import series1::Helpers::StringHelper;
import Set;
import IO;
import String;
import List;
import series1::Configuration;
import series1::Helpers::LogHelper;
import util::Math;

alias DuplicationOptions = tuple[int threshhold, bool usePruning, bool countOriginals];
public DuplicationOptions defaultDuptlicationOptions = <DUPLICATION_THRESHOLD, DUPLICATON_USE_PRUNING, DUPLICATON_COUNT_ORIGINALS>;

set[int] findDuplicatesFaster(list[str] lines){
	DuplicationOptions options = <DUPLICATION_THRESHOLD, true, DUPLICATON_COUNT_ORIGINALS>;
	
	return findDuplicates(lines, options);
}

set[int] findDuplicates(list[str] lines){
	DuplicationOptions options = <DUPLICATION_THRESHOLD, false, DUPLICATON_COUNT_ORIGINALS>;
		
	return findDuplicates(lines, options);
}

set[int] findDuplicates(list[str] lines, DuplicationOptions options){
	printDebug("Original lines for duplicates <size(lines)>");
	printDebug(options);
	lines = preprocessLines(lines, options);
	printDebug("Reduced lines for duplicates <size(lines)>");

	set[int] duplicates = {};
	
	map[str,list[int]] linesMapping = getLinesMapping(lines);
	
	int lineNumber = 0;
	
	while(lineNumber < size(lines)){
		str line = lines[lineNumber];
		list[int] sameLines = [i | i <- linesMapping[line], i > lineNumber];
		
		duplicates = duplicates + findDuplicatesForLine(lines, lineNumber, sameLines, options);
		lineNumber += 1;
		
		if(lineNumber % 100 == 0){
			printDebug("Line no: <lineNumber>, <(toReal(lineNumber)/toReal(size(lines))*100)>%");
		}
	}
	
		
	return duplicates;
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
				set[int] duplicateLines2 = toSet([sameLine..end2]);
			
				duplicateLineNumbers = duplicateLineNumbers + duplicateLines2;
				
				if(options.countOriginals){
					duplicateLineNumbers = duplicateLineNumbers + duplicateLines1;
				}
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
	return line1 == line2 && line1 != UNIQUE_LINES_TOKEN && line2 != UNIQUE_LINES_TOKEN && line1 != PAGE_BREAK_TOKEN && line2 != PAGE_BREAK_TOKEN;
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
		
		if(lineOccassions <= 1 || l == PAGE_BREAK_TOKEN){			
			if(size(nonUniqueLineStreak) >= options.threshhold){
				cleanedLines = cleanedLines + nonUniqueLineStreak + [UNIQUE_LINES_TOKEN];
			}
		
			nonUniqueLineStreak = [];
			continue;
		}
		
		nonUniqueLineStreak = nonUniqueLineStreak + [l];
	}
	
	//TODO: Compress UNIQUE_LINES_TOKEN streaks?
	
	cleanedLines = cleanedLines + nonUniqueLineStreak;
	return cleanedLines;
}

