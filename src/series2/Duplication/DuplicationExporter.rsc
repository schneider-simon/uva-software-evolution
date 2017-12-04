module series2::Duplication::DuplicationExporter

import series2::Helpers::ProjectFilesHelper;
import Set;
import List;
import IO;
alias DuplicationEntry = tuple[loc file, list[int] duplicateLines]; 
alias DuplicationExport = list[DuplicationEntry];

list[set[int]] splitInBlocks (set[int] lines){
	list[set[int]] blocks = [];
	list[int] linesList = sort(toList(lines));
	
	set[int] block = {};
	int previousLine = -1;
	for(int l <- linesList){
		if(previousLine == l - 1){
			block = block + {l};
		}
		
		if(previousLine != l - 1){
			if(size(block) > 0){
				blocks = blocks + [block];	
			}
			
			block = {l};
		}
		
		previousLine = l;
	}

	if(size(block) > 0){
		blocks = blocks + [block];	
	}

	return blocks;
}

public DuplicationExport getDuplicationExport(FileLineMapping fileLineMapping, list[str] codeLines, set[int] duplicateLineIndexes){	
	DuplicationExport duplicationExport = [];
	
	map[loc, set[int]] duplicateLinesPerFile = toMap([<getFilesForLineIndex(fileLineMapping, i)[0], i> | int i <- duplicateLineIndexes]);
	
	for(loc f <- duplicateLinesPerFile){
		set[int] duplicateLinesForFile = duplicateLinesPerFile[f];
		FileLineBounds fileLineBounds = fileLineMapping[f];
		int fileStart = fileLineBounds.fileStart;
		int fileEnd = fileLineBounds.fileEnd;
		set[int] realLinesForFile = {i - fileStart | int i <- duplicateLinesForFile};
		list[set[int]] blocks = splitInBlocks(realLinesForFile);
		list[str] fileContent = codeLines[fileStart..fileEnd];
		
		for(set[int] b <- blocks){
			DuplicationEntry duplicationEntry = <f, sort(toList(b))>;
			duplicationExport += duplicationEntry;
		}
	}
	//TODO: Test	
	return duplicationExport;
}