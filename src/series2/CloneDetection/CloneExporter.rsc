module series2::CloneDetection::CloneExporter

import Set;
import List;
import String;
import IO;
import series2::CloneDetection::CloneNetwork;
import series2::CloneDetection::CloneDetection;

public str cloneResultToJson(cloneDetectionResult result){
	list[set[int]] connectionRegions = cubeCloneNetwork(result.connections);
	
	list[str] nodesDetailsJson = [];
	set[nodeId] ids = getAllIdsInNetwork(result.connections);
	
	for(nodeId id <- ids){
		nodeDetailed details = result.nodeDetails[id];
		nodesDetailsJson += [nodeDetailedToJson(details)];
	}
	
	return "{
		\"nodes\": [<intercalate(",\n", nodesDetailsJson)>],
		\"connections\": <[toList(region) | region <- connectionRegions]>
	}";
}

str nodeDetailedToJson(nodeDetailed details){
	return "{
		\"id\": \"<details.id>\",
		\"location\": <locationToJson(details.l)>,
		\"nodesAmount\": <details.s>			
	}";
}

str locationToJson(loc location){
	//TODO: Return null if location does not have a line begin and end
	return "{
		\"path\": \"<location.path>\",
		\"length\": <location.length>,
		\"startLine\": <location.begin.line>,
		\"endLine\": <location.end.line>,
		\"startColumn\": <location.begin.column>,
		\"endColumn\": <location.end.column>				
	}";
}