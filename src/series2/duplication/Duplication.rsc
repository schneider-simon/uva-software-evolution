module series2::duplication::Duplication

public int countDuplicateLines(list[str] lines, int blockSize){
	blocks = [lines[n..n+blockSize] | n <- [0..size(lines) - blockSize]];
	blockMap = toMap(zip(blocks,index(blocks)));
	duplicateBlocks = {*indexes| indexes <- range(blockMap), size(indexes) > 1 };
	duplicates = {*[block..block + blockSize]| block <- duplicateBlocks};
	return size(duplicates);
}