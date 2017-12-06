module series2::CloneDetection::CloneClasses

import series2::CloneDetection::CloneDetection;
import List;
import Map;
import IO;

loc location1 = |project://TestJavaProject/src/testClass.java|(271,92,<23,22>,<31,2>);
loc location11 = |project://TestJavaProject/src/testClass.java|(271,22,<23,22>,<23,50>);
loc location12 = |project://TestJavaProject/src/testClass.java|(270,1,<23,21>,<23,22>);
loc location2 = |unresolved:///|;

alias NodeIdLocation = tuple[nodeId id, loc l];

void testCloneClasses(){	
	println(location1 >= location12);
	list[NodeIdLocation] included = findIncludedClones([<3, location11>, <4, location12>, <1,location1>, <2,location2>]);
	
	println(included);
}

/**
	Step1: Find included clones --> list of clones that may be deleted
	Step2: Get connections for clones to delete
	Step3: Only delete clones and their connections if both clones are marked as "to delete"
**/
public cloneDetectionResult removeIncludedClones(cloneDetectionResult result){
//TODO: Implement
	return result;
}

public list[NodeIdLocation] findIncludedClones(list[NodeIdLocation] nodeDetails){
	return [nl | NodeIdLocation nl <- nodeDetailsSorted, containsLargerLocation(nl, nodeDetails)];
}

public bool containsLargerLocation(NodeIdLocation nlA, list[NodeIdLocation] nls){
	return any(NodeIdLocation nlB <- nls, nlA.id != nlB.id && nlB.l >= nlA.l);
}

public bool locationIsValid(loc location){
	return location.scheme != "unresolved"; 
}