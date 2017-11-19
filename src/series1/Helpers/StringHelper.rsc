module series1::Helpers::StringHelper

import String;
import IO;
import series1::Configuration;


bool isOneLineComment(str line) {
	return /^(\s*\/\/)/ := line;
}

bool isLineEmpty(str line) {
	return /^\s*$/ := line;
}

/*
 * Removes all multi line comments from a source code string.
 *
 * After experimenting with multiple regular expressions we decided to use:
 * \/\*[\s\S]*?\*\/
 * (Compare with: https://blog.ostermiller.org/find-comment)
 *
 */
str withoutMultiLineComments(str source){
	return visit(source){
   		case /\/\*[\s\S]*?\*\// => ""  
	};
}

/**
 * Replace strings with "S"
 *
 * Example of a problematic code without this replace string options:
 * System.out.println("Hello wolrd \/*"
 *		+ "asdasd"
 *		+ "asd*\/asdsdasd"
);	"Hello world \/*" --> "Hello world COMMENT_START_TOKEN"
 */
str replaceStrings(str source){	
	return visit(source){
   		case /"<stringstart:.*><commentstart:\/\*><stringend:.*>"/ => "\"<stringstart><COMMENT_START_TOKEN><stringend>\""
   		case /"<stringstart:.*><commentend:\*\/><stringend:.*>"/ => "\"<stringstart><COMMENT_END_TOKEN><stringend>\""
	};
}

list[str] getCodeLines(str source){
	source = "\n" + source + "\n";
	source = replaceStrings(source);
	source = withoutMultiLineComments(source);
	
  	list[str] codeLines = split("\n", source);
  	return [l | str l <- codeLines, !isLineEmpty(l) && !isOneLineComment(l)];
}