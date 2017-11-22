module series1::CyclomaticComplexity::CyclomaticComplexity

import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;

import series1::Volume::LinesOfCode;

import series1::Ranking::Ranks;
import series1::Ranking::RangeRanks;

import IO;

alias complexityRating = tuple[int min, int max];
complexityRating mid = <11,20>;
complexityRating high = <21,50>;
complexityRating veryHigh = <51,-1>;

list[maxRisk] risks = [ <veryPositive,-1,25,0,0>,
						<positive,-1,30,5,0>,
						<neutral,-1,40,10,0>,
						<negative,-1,50,25,5>,
						<veryNegative,-1,-1,-1,-1>
					  ]; 

public Ranking getCyclomaticComplexityRating(list[Declaration] declMethods, M3 model, int linesOfCode) {
	riskOverview risksList = cyclomaticLinesPerPartion(declMethods, model);

	return getScaleRating(risksList, linesOfCode, risks);
}

public riskOverview cyclomaticLinesPerPartion(list[Declaration] declMethods, M3 model) {

	riskOverview complexity = <0, 0, 0, 0>;
			
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
			case \case(_) : result += 1; // case:
			case \catch(_,_) : result += 1;	 //catch() {}
	   		case \while(_,_) : result += 1;	//while(_) x
    			case \conditional(_, _, _): result += 1; //a ? c : d
    			case \infix(_, /^\|\||&&$/, _) : result += 1; //a && b. a || b
    		}

		//Determine method size, this is the weight of the method
		int methodSize = getLocsForLocations([m.src]);
		
		//Devide the complexity in the correct group
		if(result >= mid.min && result <= mid.max) {
			complexity.normal += methodSize;
		} else if (result >= high.min && result <= high.max) {
			complexity.high  += methodSize;
		} else if (result >= veryHigh.min ) {
			complexity.veryHigh  += methodSize;
		} else {
			complexity.low  += methodSize;
		}
	}
	
	return complexity;
}