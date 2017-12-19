module series2::Tests::CloneClassesTest

import series2::CloneDetection::CloneClasses;
import series2::Aliases;


loc location1 = |project://TestJavaProject/src/testClass.java|(271,92,<23,22>,<31,2>);
loc location11 = |project://TestJavaProject/src/testClass.java|(271,22,<23,22>,<23,50>);
loc location11_1 = |project://TestJavaProject/src/testClass.java|(271,22,<23,22>,<23,50>);
loc location11_2 = |project://TestJavaProject/src/testClass2.java|(271,22,<23,22>,<23,50>);
loc location12 = |project://TestJavaProject/src/testClass.java|(270,1,<23,21>,<23,22>);
loc location1_f2 = |project://TestJavaProject/src/testClass_otherFile.java|(271,92,<23,22>,<31,2>);
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

test bool testIsIncludedInAny(){	
	nodeDetailed nodeA = <2, EMPTY_NODE, location11, 0>;
	map[nodeId, nodeDetailed] otherNodes =  (
		1: <1, EMPTY_NODE, location1, 0>
	);
	
	return isIncludedInAny(nodeA, otherNodes) == true;
} 

test bool testIsNotIncludedInChild(){	
	nodeDetailed nodeA = <2, EMPTY_NODE, location1, 0>;
	map[nodeId, nodeDetailed] otherNodes =  (
		1: <1, EMPTY_NODE, location11, 0>
	);
	
	return isIncludedInAny(nodeA, otherNodes) == false;
} 

test bool testIsNotIncludedInSelf(){	
	nodeDetailed nodeA = <1, EMPTY_NODE, location1, 0>;
	map[nodeId, nodeDetailed] otherNodes =  (
		1: <1, EMPTY_NODE, location1, 0>
	);
	
	return isIncludedInAny(nodeA, otherNodes) == false;
} 

test bool testIsNotIncludedInOtherFile(){	
	nodeDetailed nodeA = <1, EMPTY_NODE, location1, 0>;
	map[nodeId, nodeDetailed] otherNodes =  (
		2: <1, EMPTY_NODE, location1_f2, 0>
	);
	
	return isIncludedInAny(nodeA, otherNodes) == false;
} 