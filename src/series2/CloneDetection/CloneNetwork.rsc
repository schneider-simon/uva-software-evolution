module series2::CloneDetection::CloneNetwork

import IO;
import List;
import Set;
import series2::CloneDetection::CloneDetection;

rel[int,int] TEST_NETWORK = {<1,2>,<2,3>,<5,4>};

void testCloneNetwork(){
	cubeCloneNetwork(TEST_NETWORK);
}

public list[set[int]] cubeCloneNetwork(rel[int,int] cloneNetwork){
	list[set[int]] cubes = [];

	for(connection <- cloneNetwork){
		int foundCubeIndex = -1;
		
		for(cubeIndex <- [0..size(cubes)]){
			set[int] cube = cubes[cubeIndex];
			
			if(connection[0] in cube || connection[1] in cube){
				foundCubeIndex = cubeIndex;
				break;
			}
		}
		
		if(foundCubeIndex == -1){
			cubes = push({connection[0], connection[1]}, cubes);
			continue;
		}	
		
		cubes[foundCubeIndex] += {connection[0], connection[1]};
	}

	return cubes;
} 

public set[int] getAllIdsInNetwork(rel[int,int] cloneNetwork){
	tuple[list[int],list[int]] unzipped = unzip(toList(cloneNetwork));
	return toSet(unzipped[0]) + toSet(unzipped[1]);
}