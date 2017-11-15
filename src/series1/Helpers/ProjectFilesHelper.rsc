module series1::Helpers::ProjectFilesHelper

import List;
import String;
import IO;
import util::FileSystem;
import series1::Helpers::StringHelper;

list[str] invalidFolders = ["/test/","/generated/"];

public list[loc] getProjectFiles(list[loc] files) {

	list[loc] validFiles = [];
	for(int i <- [0 .. size(files)]) {
		loc file = files[i];
		
		if(isValidProjectFile(file.path)) {
			validFiles += file;
		}
	}
	
	return validFiles;
}

public bool isValidProjectFile(str file) {
	
	if(!contains(file, "/src/"))
		return false;
	
	for(int i <- [0..size(invalidFolders)]) {
		if(contains(file,invalidFolders[i]))
			return false;
	}

	return true;
}

public str getConcatinatedSourceFromFiles(list[loc] files){
	str code = "";

	return ("" | it + "\n" +  readFile(l) | loc l <- files);
}

public list[str] getCodeLinesFromFiles(list[loc] files){
	println("files");
	println(files);
	str source = getConcatinatedSourceFromFiles(files);
	return getCodeLines(source);
}