module series1::Duplication::Duplication

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import util::FileSystem;
import series1::Helpers::StringHelper;
import Set;
import IO;
import String;
import List;

int DUPLICATION_THRESHHOLD = 6;
str UNIQUE_LINES_TOKEN = "%%%|||RASCAL_UNIQUE_LINES|||%%%%";

void testDuplication(){
	M3 myModel = createM3FromEclipseProject(|project://TestJavaProject|);
	list[loc] files = toList(files(myModel));
		
	loc file1 = files[0];
	str content = readFile(file1);	
	list[str] lines = split("\n", content);
	list[str] cleanedLines = preprocessLines(lines);
	
	list[list[str]] duplicates = findDuplicates(cleanedLines);
	

}

list[list[str]] findDuplicates(list[str] lines){
	list[list[str]] duplicates = [];
	
	int s1 = 0;
	
	while(s1 < size(lines)){
		str lineS1 = lines[s1];
		int duplicateLength = 0;
		int s2 = s1 + UNIQUE_LINES_TOKEN;
		
		//INCREASE S2 HERE
		str lineS2 = lines[s2];
		if(!linesAreDuplicate(lineS1, lineS2)){
			s2 += 1;
			duplicateLength = 0;
		}
		//TODO
	}
	
	iprintln(duplicates);
	
	return duplicates;
}

bool linesAreDuplicate(str line1, str line2){
	return line1 == line2 && line1 != UNIQUE_LINES_TOKEN && line2 != UNIQUE_LINES_TOKEN;
}


list[str] preprocessLines(list[str] lines){
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
		trimmedLines = push(trimmedLine, trimmedLines);
	
		if(!(trimmedLine in linesCountings)){
			linesCountings[trimmedLine] = 1;
		} else {
			linesCountings[trimmedLine] += 1;
		}
	}	
	

	
	// Do only work with streaks (above the threshhold) of non unique lines.
	// Insert a "UNIQUE LINES" token that seperates blocks of non unique lines. 
	list[str] nonUniqueLineStreak = [];
	for(str l <- trimmedLines){
		int lineOccassions = linesCountings[l];
		
		if(lineOccassions <= 1){
			if(size(nonUniqueLineStreak) >= DUPLICATION_THRESHHOLD){
				cleanedLines = cleanedLines + nonUniqueLineStreak + [UNIQUE_LINES_TOKEN];
			}
		
			nonUniqueLineStreak = [];
			continue;
		}
		
		nonUniqueLineStreak = push(l, nonUniqueLineStreak);
	}
	
	cleanedLines = cleanedLines + nonUniqueLineStreak;
}

