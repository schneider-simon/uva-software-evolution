module series1::CyclomaticComplexity::CyclomaticComplexity

import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import series1::Volume::LinesOfCode;

import IO;

public map[str, int] cyclomaticLinesPerPartion(list[Declaration] methods) {

	map[str, int] complexity = ("low" : 0, "mid" : 0, "high" : 0, "very high": 0);

	for(m <- methods) {
		
		//Base complexity is always 1. This is the function body
		int result = 1;
		
		// http://tutor.rascal-mpl.org/Rascal/Libraries/lang/java/m3/AST/Declaration/Declaration.html
		visit(m) {
    		case \do(_,_) : result += 1;
    		case \foreach(_,_,_) : result += 1;	
    		case \for(_,_,_,_) : result += 1;
	  		case \for(_,_,_) : result += 1;
	  		case \if(_,_) : result += 1;
			case \if(_,_,_) : result += 1;
			case \switch(_,_) : result += 1;
			case \case(_) : result += 1;	
			case \catch(_,_) : result += 1;	
    		case \while(_,_) : result += 1;		
		}

		//if(/method(mLoc,_,_,_) := m@typ) {
			//TODO: fix the location
			loc mLoc = |file:///home/eigenaar/workspace/uva-software-evolution/src/javaProjects/basicExample/src/Factorial.java|;
			str methodBody = readFile(mLoc);
			int methodSize = getLocStats(methodBody)["code"];
			
			if(result > 10, result <= 20) {
				complexity["mid"] += methodSize;
			} else if (result > 20, result <= 50) {
				complexity["high"] += methodSize;
			} else if (result > 50) {
				complexity["very high"] += methodSize;
			} else {
				complexity["low"] += methodSize;
			}
		//}				
	}
	
	return complexity;
}