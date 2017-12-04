module series2::Duplication::Duplication

import List;
import Map;
import Set;
import IO;

alias CodeBlock = list[str];

list[str] CODE_EXAMPLE_4 = [		// Assume treshhold = 3 4
    "package java;", 			//0
"public class Duplicates {", 	//1
	"public void method1() {", 	//2
		"int a = 1;", 			//3 DUPLICATE?
		"int b = 2;",			//4 DUPLICATE?
		"int c = 3;", 			//5 DUPLICATE?
		"int d = 4;", 			//6 DUPLICATE?
	"}",							//7 DUPLICATE?
	"public void method2() {", 	//8
		"int a = 1;",			//9  DUPLICATE!
		"int b = 2;",			//10 DUPLICATE!
		"int c = 3;",			//11 DUPLICATE!
	"}",							//12
	"public void method3() {",	//13
		"int b = 2;",			//14 DUPLICATE!
		"int c = 3;",			//15 DUPLICATE!
		"int d = 4;",			//16 DUPLICATE!
	"}",							//17 DUPLICATE!
"}"								//18
];

public void testCount(){
	int result = getDuplicateLineIndexes(CODE_EXAMPLE_4, 3);
	
	println(result);
}

public set[int] getDuplicateLineIndexes(list[str] lines, int blockSize){
	list[CodeBlock] blocks = [lines[n..n+blockSize] | n <- [0..size(lines) - blockSize]];	
	map[CodeBlock, set[int]] blockMap = toMap(zip(blocks,index(blocks)));	
	set[int] blockStartIndexes = {*indexes| indexes <- range(blockMap), size(indexes) > 1 };
	set[int] blockIndexes = {*[block..block + blockSize]| block <- blockStartIndexes};
	
	return blockIndexes;
}