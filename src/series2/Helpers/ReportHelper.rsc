module series2::Helpers::ReportHelper

import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import series2::Helpers::StringHelper;

import Set;
import List;
import Map;
import IO;
import String;

import series2::Aliases;

public duplications getDuplicateLinesPerFile(M3 model, cloneDetectionResult cloneDetectionResult) {

	duplications result = ();
	
	//Get all dup locations		
	set[loc] locations = {};
	locations = ({} | it + e | e <- {{cloneDetectionResult.nodeDetails[a].l, cloneDetectionResult.nodeDetails[b].l} |
					connection <- cloneDetectionResult.connections,
					a := connection.f, 
					b := connection.s
				});

	//Create a file path -> loc overview
	map[str, list[loc]] locationsPerFile = getLocationsPerFile(locations);
	map[str, list[loc]] commentsPerFile = getLocationsPerFile({ d.comments | d <- model.documentation});
		
	//Go through the comments, and determine if it is inside a comment
	for( fileP <- locationsPerFile) {
		result[fileP] = {};
		list[loc] locations = locationsPerFile[fileP];
		 		
		//Get all comments in the file
		list[loc] commentsForFile = [];
		if( fileP in commentsPerFile) {
			commentsForFile = commentsPerFile[fileP];
		}		

		//Go over locations
		for(loc location <- locations) {
			int startLineNumber = location.begin.line;
			list[str] file = split("\n",readFile(location)); 
			for( int i <- [0 .. (size(file))]) {
			
				//reduceL: How much from the left (of the comment line) has to be reduced
				//Total line size - how many spaces in the left - how many columns are skipped in this duplicate
			
				str line = trim(file[i]);
				int lineSize = size(file[i]);
				int reduceL = lineSize - (size(trim(file[i] + "a")) - 1) + location.begin.column;  
				int lineNumber = startLineNumber + i;
				
				//It is not a line of code when
				if(isOneLineComment(line) || /*isMultiLineCommentStart(line) ||*/ isMultiLineCommentEnd(line) || isLineEmpty(line))
					continue;
				
				//Or if it is inside a comment section
				set[bool] isComment = {true | comment <- commentsForFile, lineInLoc(comment, lineNumber, lineSize, reduceL)};				
				if( isComment != {})
					continue;
				
				result[fileP] += lineNumber;
			}			
		}		
	}
	
	return result;
}

//Converts to map
private map[str, list[loc]] getLocationsPerFile(set[loc] location) {
	map[str, list[loc]] locationsPerFile = ();
	for( loci <- location) {
		if(loci.path notin locationsPerFile)
			 locationsPerFile[loci.path] = [];
		
		//Add location to path
		locationsPerFile[loci.path] += loci;
	}
	
	return locationsPerFile;
}

private list[loc] getLocationInsideLocations(list[loc] setA, list[loc] setB) {
 
 	list[loc] dups = [];
 	
 	for(loc a <- setA) {
 		//Check location is 2nth
 		for(loc b <- setB) {
 			if(a.path == b.path && a <= b) {
 				dups += a;
 				break;
 			}
 		}
 	}
 	
 	return dups;
 }

list[int] getAllLinesInFile(loc location) {
	return [(location.begin.line) .. (location.end.line + 1)];
}

bool lineInLoc(loc location, int lineNr, int lineSize, int reduceL) {
	bool startIsSameOrBefore = location.begin.line <= lineNr && location.begin.column - reduceL <= 0;
	bool endIsSameOrAfter = (location.end.line > lineNr) || (location.end.line == lineNr && location.end.column >= lineSize);
	
	return startIsSameOrBefore && endIsSameOrAfter;
}
