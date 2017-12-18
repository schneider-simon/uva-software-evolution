module series2::Helpers::ReportHelper

import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import series2::Helpers::StringHelper;

import Set;
import List;
import Map;
import IO;
import String;

alias duplications = map[str, set[int]];
alias commentRangs = tuple[int fromL, int fromC, int toL, int toC];
alias cloneDetectionResult = tuple[map[nodeId, nodeDetailed] nodeDetails, rel[nodeId f,nodeId s] connections, duplications duplicateLines];

alias nodeId = int;
alias nodeS = tuple[node d,int s];
alias nodeDetailed = tuple[nodeId id, node d, loc l, int s];
alias cloneDetectionResult = tuple[map[nodeId, nodeDetailed] nodeDetails, rel[nodeId f,nodeId s] connections, duplications duplicateLines];


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
		list[loc] commentsForFile = commentsPerFile[fileP];
						
		//Go over locations
		for(loc location <- locations) {
			int startLineNumber = location.begin.line;
			list[str] file = split("\n",readFile(location)); 
			for( int i <- [0 .. (size(file))]) {
			
				str line = trim(file[i]);
				int lineSize = size(line);
				int lineNumber = startLineNumber + i;
				
				//It is not a line of code when
				if(isOneLineComment(line) || isMultiLineCommentStart(line) || isMultiLineCommentEnd(line) || isLineEmpty(line))
					continue;
				
				//Or if it is inside a comment section
				if(any(comment <- commentsForFile, lineInLoc(comment, lineNumber, lineSize)))
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

bool lineInLoc(loc location, int lineNr, int lineSize) {
	bool startIsSameOrBefore = location.begin.line <= lineNr && location.begin.column <= lineSize;
	bool endIsSameOrAfter = (location.end.line > lineNr) || (location.end.line == lineNr && location.begin.column >= lineSize);
	
	return startIsSameOrBefore && endIsSameOrAfter;
}
