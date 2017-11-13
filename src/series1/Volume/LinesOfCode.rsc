module series1::Volume::LinesOfCode

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import util::FileSystem;
import series1::Helpers::StringHelper;
import Set;
import IO;
import String;
import List;

alias KLOC = num;
alias LinesOfCodeStats = map[str,int];
alias LocationsLineOfCodeStats = map[loc,LinesOfCodeStats] ;

void testLoc(){
	M3 myModel = createM3FromEclipseProject(|project://TestJavaProject|);
	list[loc] files = toList(files(myModel));
		
	loc file1 = files[1];
	str content = readFile(file1);
	
	println(getTotalLocsForLocations([|project://TestJavaProject/src/com/zwei14/test_java/TestClass.java|]));
}

/**
 * Sums up all the lines of code stats for many locations.
 * 
 */
LinesOfCodeStats getTotalLocsForLocations (list[loc] locations){
	LocationsLineOfCodeStats mapping = getLocStatsForLocations(locations);
	LinesOfCodeStats stats =  ("text": 0, "code": 0, "blank": 0, "comments": 0);
	
	for(loc location <- mapping){
		LinesOfCodeStats locationStats = mapping[location];
		for(str statisticKey <- locationStats){
			stats[statisticKey] += locationStats[statisticKey];
		}
	}
	
	return stats;
}

/**
 * Get lines of code stats for many locations.
 * 
 * Maps the location to a map of LOC statistics:
 * 
 * |java+compilationUnit:///src/../TestClass.java|:("all":28,"code":9,"blank":4,"comments":15),
 * |java+compilationUnit:///src/../TestClass2.java|:("all":28,"code":9,"blank":4,"comments":15)
 */
LocationsLineOfCodeStats getLocStatsForLocations (list[loc] locations){
	LocationsLineOfCodeStats mapping = (); 
	
	for(loc location <- locations){
		str content = readFile(location);
		mapping[location] = getLocStats(content);
	}
	
	return mapping;
}

/**
 * Get lines of code stats for a string of code.
 *
 */
LinesOfCodeStats getLocStats (str code) {
	code = "\n" + code + "\n";
	code = replaceString(code);
	
    list[str] allLines = split("\n", code);
    list[str] nonBlankLines = [l | str l <- allLines, !isLineEmpty(l)];
  	list[str] codeLines = split("\n", withoutMultiLineComments(code));
  	codeLines = [l | str l <- codeLines, !isLineEmpty(l) && !isOneLineComment(l)];
  	
  	return ("text": size(allLines),
  			"code": size(codeLines),
  			"blank": size(allLines) - size(nonBlankLines), 
  			"comments": size(nonBlankLines) - size(codeLines)
  			);
}

/**
 * Removes all multi line comments from a source code string.
 *
 * After experimenting with multiple regular expressions we decided to use:
 * \/\*[\s\S]*?\*\/
 * (Compare with: https://blog.ostermiller.org/find-comment)
 *
 */
str withoutMultiLineComments(str source){
	return visit(source){
   		case /\/\*[\s\S]*?\*\// => ""  
	};
}

/**
 * Replace strings with "S"
 *
 * Example of a problematic code without this replace string options:
 * System.out.println("Hello wolrd \*"
 *		+ "asdasd"
 *		+ "asd*\asdsdasd"
);	
 */
str replaceString(str source){
	return visit(source){
   		case /\".*\"/ => "\"S\""  
	};
}

