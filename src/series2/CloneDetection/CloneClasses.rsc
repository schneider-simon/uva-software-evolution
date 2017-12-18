module series2::CloneDetection::CloneClasses

import series2::CloneDetection::CloneDetection;
import series2::Aliases;

import List;
import Map;
import IO;
import Relation;

loc location1 = |project://TestJavaProject/src/testClass.java|(271,92,<23,22>,<31,2>);
loc location11 = |project://TestJavaProject/src/testClass.java|(271,22,<23,22>,<23,50>);
loc location11_1 = |project://TestJavaProject/src/testClass.java|(271,22,<23,22>,<23,50>);
loc location11_2 = |project://TestJavaProject/src/testClass2.java|(271,22,<23,22>,<23,50>);
loc location12 = |project://TestJavaProject/src/testClass.java|(270,1,<23,21>,<23,22>);
loc location2 = |unresolved:///|;

node EMPTY_NODE = "empty"(true);

map[nodeId, nodeDetailed] SAMPLE_NODE_DETAILS = (
	1: <1, EMPTY_NODE, location1, 0>,
	2: <2, EMPTY_NODE, location11, 0>,
	3: <3, EMPTY_NODE, location12, 0>,
	4: <4, EMPTY_NODE, location11_1, 0>,
	5: <5, EMPTY_NODE, location11_2, 0>
);

rel[nodeId f,nodeId s] SAMPLE_CONNECTIONS = {<2,4>,<4,5>};
cloneDetectionResult SAMLE_CLONE_RESULT = <SAMPLE_NODE_DETAILS, SAMPLE_CONNECTIONS, ()>;

void testCloneClasses(){	
	println(location1 >= location12);
	list[NodeIdLocation] included = findIncludedClones([<3, location11>, <4, location12>, <1,location1>, <2,location2>]);
	
	println(included);
}

void testRemoval(){	
	removeSubsumedClones(SAMLE_CLONE_RESULT, 100.0);
}

/**
	Step1: Find included clones --> list of clones that may be deleted
	Step2: Get connections for clones to delete
	Step3: Only delete clones and their connections if both clones are marked as "to delete"
**/
public cloneDetectionResult removeSubsumedClones(cloneDetectionResult result, real minimalSimularity){
	map[nodeId, nodeDetailed] includedNodes = findIncludedClones(result.nodeDetails);
	
	rel[nodeId f, nodeId s] connections = result.connections;
	
	//Add transitive relations (transitive closure) for clones that are not type 3
	if(minimalSimularity == 100.0){
		connections = connections+;
	}

	rel[nodeId f, nodeId s] filteredConnections = {<c.f,c.s> | c <- connections, c.f in includedNodes && c.s in includedNodes};
	
	set[nodeId] filteredNodeIds = domain(filteredConnections);
	
	if(minimalSimularity == 100.0){
		filteredConnections = filteredConnections+;
	}
	
	map[nodeId, nodeDetailed] filteredNodes = (id: result.nodeDetails[id] | nodeId id <- result.nodeDetails, id in filteredConnections);
		
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