module series2::CloneDetection::CloneClasses

import series2::CloneDetection::CloneDetection;
import series2::Aliases;

import List;
import Map;
import IO;
import Relation;

/**
	Step1: Find included clones --> list of clones that may be deleted
	Step2: Get connections for clones to delete
	Step3: Only delete clones and their connections if both clones are marked as "to delete"
**/
public cloneDetectionResult removeSubsumedClones(cloneDetectionResult result, real minimalSimularity){
	set[nodeId] duplicateNodeIds = carrier(result.connections);

	map[nodeId, nodeDetailed] nodeDetails = (nodeId: result.nodeDetails[nodeId] | nodeId <- result.nodeDetails, nodeId in duplicateNodeIds);
	
	map[nodeId, nodeDetailed] flagForRemovalNodes = findIncludedClones(nodeDetails);
	
	rel[nodeId f, nodeId s] connections = result.connections;
	
	//Add transitive relations (transitive closure) for clones that are not type 3
	if(minimalSimularity == 100.0){
		connections = connections+;
	}

	rel[nodeId f, nodeId s] filteredConnections = {<c.f,c.s> | c <- connections, c.f notin flagForRemovalNodes || c.s notin flagForRemovalNodes};
	
	set[nodeId] filteredNodeIds = carrier(filteredConnections);
	
	if(minimalSimularity == 100.0){
		filteredConnections = filteredConnections+;
	}
	
	
	map[nodeId, nodeDetailed] filteredNodes = (id: nodeDetails[id] | nodeId id <- nodeDetails, id in filteredNodeIds);

	return <filteredNodes, filteredConnections, result.duplicateLines>;
}

public map[nodeId, nodeDetailed] findIncludedClones(map[nodeId, nodeDetailed] nodeDetails){
	return (id: nodeDetails[id] | nodeId id <- nodeDetails, isIncludedInAny(nodeDetails[id], nodeDetails));
}

public bool isIncludedInAny(nodeDetailed nodeA, map[nodeId, nodeDetailed] otherNodes){	
	return any(nodeId idB <- otherNodes, 
			nodeA.id != otherNodes[idB].id &&
			nodeA.l.path == otherNodes[idB].l.path &&
			nodeA.l <= otherNodes[idB].l
		);
}

public bool locationIsValid(loc location){
	return location.scheme != "unresolved"; 
}