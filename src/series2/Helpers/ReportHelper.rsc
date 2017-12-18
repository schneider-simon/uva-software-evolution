module series2::Helpers::ReportHelper

import series2::CloneDetection::CloneDetection;

import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import Set;
import List;
import Map;
import IO;


alias duplications = map[str, set[int]];

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
		list[loc] locations = locationsPerFile[fileP];
	
		//Stop when the file does not have comments
		if( fileP notin commentsPerFile)
			continue;
	
		//Get all comments in the file
		list[loc] commentsForFile = commentsPerFile[fileP];
		
		//Go over al locations
		for(locationItem <- locations) {
			list[loc] allLocation = getAllLocsInside(locationItem);
			
			list[loc] dupsForFile = getLocationInsideLocations(allLocation, commentsForFile);
			result[fileP] = dupsForFile;
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

private list[loc] getAllLocsInside(loc location) {

	//Create locations that have to be checked
	loc locationB = location;
	locationB.beg
	list[loc] locationsToCheck = [locations.begin, locations.end];
	
	list[int] locationList = [ line | line  <-[(locations.begin.line + 1)..(locations.end.line - 1)]];
	for(int line <- locationList) {
		loc locToAdd = locations.begin;
		locToAdd.line = line;
		locToAdd.column = 0;
		locationsToCheck += locToAdd;
	}	
	
	return locationsToCheck;
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

