module series1::Main

import IO;
import List;
import Set;

import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import series1::Helpers::ProjectFilesHelper;
import series1::ClomaticComplexity::CyclomaticComplexity;

public void testExampleJavaProject() {
	doAnalyses(|project://uva-software-evolution/src/javaProjects|);
}

public void doAnalyses(loc eclipsePath) {

	int totalLinesOfCode = 0;

	//Create M3 model
	M3 model = createM3FromEclipseProject(eclipsePath);

	//Get a list off all files that are relevant to test
	list[loc] files = toList(files(model));
	list[loc] projectFiles = getProjectFiles(files); 
	
	//Extract all the methods
	list[Declaration] declarations = [ createAstFromFile(file, true) | file <- projectFiles]; 
	list[Declaration] methods = [];
	for(int i <- [0 .. size(declarations)]) {
		methods = methods + [dec | /Declaration dec := declarations[i], dec is method];
	}
	
	//Get cyclomatic complexity partitions
	map[str, int] cyclomaticPartitions = cyclomaticLinesPerPartion(methods);	
	
	
	println(cyclomaticPartitions);
	//list[loc] productionSourceFiles = [file | file <- files(model)];

}