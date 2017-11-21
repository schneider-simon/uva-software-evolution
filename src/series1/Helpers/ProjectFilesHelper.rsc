module series1::Helpers::ProjectFilesHelper

import List;
import String;
import IO;
import util::FileSystem;
import series1::Helpers::StringHelper;
import series1::Configuration;
import series1::Helpers::LogHelper;
import series1::Helpers::BenchmarkHelper;
import util::FileSystem;

list[str] invalidFolders = ["/test/","/generated/"];

alias ProjectFileOptions = tuple[bool addPageBreakTokens];
public ProjectFileOptions defaultProjectFileOptions = <false>;

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

public str getConcatinatedSourceFromFiles(list[loc] files) {
	return getConcatinatedSourceFromFiles(files, defaultProjectFileOptions);
}


public str getConcatinatedSourceFromFiles(list[loc] files, ProjectFileOptions options){
	str code = "";
	str pageBreak = "\n";
	
	if(options.addPageBreakTokens){
		pageBreak = "\n<PAGE_BREAK_TOKEN>\n";
	}

	return ("" | it + pageBreak +  readFile(l) | loc l <- files);
}

public list[str] getCodeLinesFromFiles(list[loc] files) {
	return getCodeLinesFromFiles(files, defaultProjectFileOptions);
}

public list[str] getCodeLinesFromFiles(list[loc] files, ProjectFileOptions options){
	str source = getConcatinatedSourceFromFiles(files, options);	
	list[str] lines = getCodeLines(source);
	
	return lines;
}

