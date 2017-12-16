module series2::CloneDetection::CloneExporter

import Set;
import List;
import String;
import IO;
import lang::json::IO;
import series2::Helpers::LocationHelper;
import series2::Helpers::StringHelper;
import series2::CloneDetection::CloneNetwork;
import series2::CloneDetection::CloneDetection;

public str cloneResultToJson(cloneDetectionResult result, loc projectLocation, int linesOfCode, list[loc] projectFiles){
	list[set[int]] connectionRegions = cubeCloneNetwork(result.connections);
	
	list[str] nodesDetailsJson = [];
	set[nodeId] ids = getAllIdsInNetwork(result.connections);
	
	for(nodeId id <- ids){
		nodeDetailed details = result.nodeDetails[id];
		nodesDetailsJson += [nodeDetailedToJson(details)];
	}
	
	projectName = projectLocation.authority;
		
	return "{
		\"project\": { \n
			\"name\": \"<projectName>\",
			\"location\": <locationWithoutAreaToJson(projectLocation)>,\n
			\"linesOfCode\": <linesOfCode>,\n
			\"projectFiles\": <size(projectFiles)>
		},
		\"nodes\": [<intercalate(",\n", nodesDetailsJson)>],
		\"connections\": <[toList(region) | region <- connectionRegions]>
	}";
}

str nodeDetailedToJson(nodeDetailed details){
	int linesOfCode = size(getCodeLines(details.l));
	
	return "{
		\"id\": \"<details.id>\",
		\"location\": <locationToJson(details.l, linesOfCode)>,
		\"linesOfCode\": <linesOfCode>,
		\"nodesAmount\": <details.s>			
	}";
}

str locationToJson(loc location) = locationToJson(location, 0);

str locationToJson(loc location, int linesOfCode){
	if(!locationHasArea(location)){
		return "null";
	}

	return "{
		\"path\": \"<location.path>\",
		\"length\": <location.length>,
		\"startLine\": <location.begin.line>,
		\"endLine\": <location.end.line>,
		\"startColumn\": <location.begin.column>,
		\"endColumn\": <location.end.column>,	
		\"linesOfCode\": <linesOfCode>		
	}";
}

str locationWithoutAreaToJson(loc location){
	return "{
		\"uri\": \"<location.uri>\",	
		\"path\": \"<location.path>\"			
	}";
}