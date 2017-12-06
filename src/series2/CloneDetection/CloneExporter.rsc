module series2::CloneDetection::CloneExporter

import Set;
import List;
import IO;
import series2::CloneDetection::CloneNetwork;
import series2::CloneDetection::CloneDetection;

public str cloneResultToJson(cloneDetectionResult result){
	list[set[int]] connectionRegions = cubeCloneNetwork(result.connections);
	println(connectionRegions);
	
	return "";
}