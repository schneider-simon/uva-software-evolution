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

public str cloneResultToJson(cloneDetectionResult result, loc projectLocation, int linesOfCode){
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
			\"linesOfCode\": <linesOfCode>\n
		},
		\"nodes\": [<intercalate(",\n", nodesDetailsJson)>],
		\"connections\": <[toList(region) | region <- connectionRegions]>
	}";
}

str nodeDetailedToJson(nodeDetailed details){
	return "{
		\"id\": \"<details.id>\",
		\"location\": <locationToJson(details.l)>,
		\"linesOfCode\": <size(getCodeLines(details.l))>,
		\"nodesAmount\": <details.s>			
	}";
}

str locationToJson(loc location){
	if(!locationHasArea(location)){
		return "null";
	}

	return "{
		\"path\": \"<location.path>\",
		\"length\": <location.length>,
		\"startLine\": <location.begin.line>,
		\"endLine\": <location.end.line>,
		\"startColumn\": <location.begin.column>,
		\"endColumn\": <location.end.column>				
	}";
}

str locationWithoutAreaToJson(loc location){
	return "{
		\"uri\": \"<location.uri>\"			
		\"path\": \"<location.path>\"			
	}";
}