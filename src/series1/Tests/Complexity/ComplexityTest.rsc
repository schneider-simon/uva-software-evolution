module series1::Tests::Complexity::ComplexityTest

import series1::Helpers::ProjectFilesHelper;

import IO;
import Set;
import List;

test bool concatinatedFilesDuplicatesTest() {

	//Path
	loc eclipsePath = |project://uva-software-evolution/src/resources/series1/test-code|;

	//Create M3 model for complexity files
	M3 model = createM3FromEclipseProject(eclipsePath);
	list[loc] projectFiles = [ f <- files(model), contains(f.path, "test-code/complexity/")];
	
	//Extract all methods
	list[Declaration] declarations = [ createAstFromFile(file, true) | file <- projectFiles]; 
	list[Declaration] methods = [];
	for(int i <- [0 .. size(declarations)]) {
		methods = methods + [dec | /Declaration dec := declarations[i], dec is method || dec is constructor || dec is initializer];
	}
	
	//Get cyclomatic complexity partitions
	<int l, int m, int h, int vh> := cyclomaticLinesPerPartion(methods, model);
	
	return l != 0 && m != 0 && h != 0 && vh != 0;

}
