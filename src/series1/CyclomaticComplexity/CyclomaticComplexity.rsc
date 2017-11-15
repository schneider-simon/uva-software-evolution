module series1::CyclomaticComplexity::CyclomaticComplexity

import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import series1::Volume::LinesOfCode;
import series1::Ranking::Ranks;

import IO;

/*
	What if you have:
	if(True) {
	
	}
	
	a = true;
	if(a) {
	
	}
	
	switch() {
	case 1:
	case 2:
	}
	
	
	In both cases there is only one code path. So, we need optimalisation.
*/

alias complexityRange = tuple[Ranking rank, int maxMod, int maxHigh, int maxVeryHigh];
alias complexityDivision = tuple[int mid, int high, int veryHigh];

complexityRange veryLowCodeSide = <veryPositive, 25, 0, 0>; 
complexityRange lowCodeSide = <positive, 30, 5, 0>; 
complexityRange midCodeSide = <neutral, 40, 10, 0>;
complexityRange highCodeSide = <negative, 50, 15, 5>;
complexityRange veryHighCodeSide = <veryNegative, -1, -1, -1>;
list[complexityRange] complexityRanges = [veryLowCodeSide,lowCodeSide,midCodeSide,highCodeSide,veryHighCodeSide];

alias complexityRating = tuple[int min, int max];
complexityRating mid = <11,20>;
complexityRating high = <21,50>;
complexityRating veryHigh = <51,-1>;
list[complexityRating] complexityRatings = [mid, high, veryHigh];

int testC = 0;

public Ranking getCyclomaticComplexityRating(complexityDivision division, int linesOfCode) {

	//calculate how it is divided
	int pMid = division.mid * 100 / linesOfCode;
	int pHigh = division.high * 100 / linesOfCode;
	int pVHigh = division.veryHigh * 100 / linesOfCode;
	
	//Get rating
	for(complexityRange complexity <- complexityRanges) {
		if( pMid <= complexity.maxMod || complexity.maxMod == -1 && 
			pHigh <= complexity.maxHigh || complexity.maxHigh == -1 && 
			pVHigh <= complexity.maxVeryHigh || complexity.maxVeryHigh == -1 )
			return complexity.rank;
	}
	
	//This should never happen
	return veryNegative;
}

public complexityDivision cyclomaticLinesPerPartion(list[Declaration] declMethods, M3 model) {

	complexityDivision complexity = <0, 0, 0>;
			
	for(m <- declMethods) {
		
		//Base complexity is always 1. This is the function body
		int result = 1;
		
		//Calculate in the method the complexity
		visit(m) {
    		case \do(_,_) : result += 1;
    		case \foreach(_,_,_) : result += 1;	
    		case \for(_,_,_,_) : result += 1;
	  		case \for(_,_,_) : result += 1;
	  		case \if(_,_) : result += 1;
			case \if(_,_,_) : result += 1;
			case \case(_) : result += 1; // case() 
			case \catch(_,_) : result += 1;	 //catch() {}
	   		case \while(_,_) : result += 1;	//while(_) x
    		case \conditional(_, _, _): result += 1; //a ? c : d
    		case \infix(_, /^\|\||&&$/, _) : result += 1; //a && b. a || b
    		}

		//Determine method size, this is the weight of the method
		int methodSize = getLocsForLocations([m.src]);
		
		if(result > 1) {
			testC = testC + 1;
			iprintln("<testC> <m.src>: Cyclomatic Complexity is <result>");
		}
		
		//Devide the complexity in the correct group
		if(result >= mid.min && result <= mid.max) {
			complexity.mid += methodSize;
		} else if (result >= high.min && result <= high.max) {
			complexity.high  += methodSize;
		} else if (result >= veryHigh.min ) {
			complexity.veryHigh  += methodSize;
		}
	}
	
	return complexity;
}