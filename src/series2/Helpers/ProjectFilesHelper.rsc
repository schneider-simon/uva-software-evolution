module series2::Helpers::ProjectFilesHelper

import List;
import String;
import IO;
import util::FileSystem;
import series2::Helpers::StringHelper;
import series2::Configuration;
import series2::Helpers::LogHelper;
import series2::Helpers::BenchmarkHelper;
import util::FileSystem;

list[str] invalidFolders = ["/test/","/generated/"];

alias FileLineBounds = tuple[int fileStart, int fileEnd];
alias FileLineMapping = map[loc, FileLineBounds];
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

public tuple[FileLineMapping fileMapping, list[str] codeLines] getConcatinatedCodeFromFiles(list[loc] files, ProjectFileOptions options){
	list[str] code = [];
	FileLineMapping fileMapping = ();

	for(loc file <- files){
		list[str] fileCode = getCodeLines(readFile(file));
		fileMapping[file] = <size(code), size(code) + size(fileCode) - 1>;
		code = fileCode + code;
	}

	return <fileMapping, code>;
}

public tuple[FileLineMapping fileMapping, list[str] codeLines] getCodeLinesFromFiles(list[loc] files) {
	return getCodeLinesFromFiles(files, defaultProjectFileOptions);
}

public tuple[FileLineMapping fileMapping, list[str] codeLines] getCodeLinesFromFiles(list[loc] files, ProjectFileOptions options){
	return getConcatinatedCodeFromFiles(files, options);
}

public list[loc] getFilesForLineIndex(FileLineMapping fileMapping, int lineIndex){	
	/* Does not work, should do same as for loop below -> investigate?
	return ([] | (isInBoundaries) ? it : [file] | 
						loc file <- fileMapping,
						FileLineBounds fileBoundaries := fileMapping[file],
						bool isInBoundaries := fileBoundaries.fileStart <= lineIndex && fileBoundaries.fileEnd >= lineIndex
			);
			*/
	
	for(loc file <- fileMapping){
		FileLineBounds fileBoundaries = fileMapping[file];
		bool isInBoundaries = fileBoundaries.fileStart <= lineIndex && fileBoundaries.fileEnd >= lineIndex;
		
		if(isInBoundaries){
			return [file];
		}			
	}
	
	return [];
}

