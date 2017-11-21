module series1::Duplication::DuplicationPruning

import String;
import series1::Duplication::DuplicationOptions;
import series1::Configuration;
import series1::Helpers::StringHelper;
import List;

/**
* Remove all lines that can not be part of a duplicate.
**/
public list[str] pruneUniqueLines(list[str] lines, DuplicationOptions options){
	list[str] cleanedLines = [];
	
	map[str,list[int]] linesMapping = getLinesMapping(lines);

	// Do only work with streaks (above the threshold) of non unique lines.
	// Insert a "UNIQUE LINES" token that seperates blocks of non unique lines. 
	list[str] nonUniqueLineStreak = [];
	for(str l <- lines){
		list[int] lineOccassions = linesMapping[l];
		
		if(size(lineOccassions) <= 1 || l == PAGE_BREAK_TOKEN){			
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