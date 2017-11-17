module series1::UnitInterfacing::UnitInterfacing
 
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

import series1::Ranking::Ranks;

import List;
import Map;
import IO;

alias interfacingOverview = map[str,int];
alias interfacingRisks = tuple[int low, int normal, int high, int veryHigh];

public Ranking getUnitInterfacingRating(interfacingOverview overview) {
	
	interfacingRisks risks = getInterfacingRisksCount(overview);
	int totalMethods = size(overview);
	interfacingRisks rankingDiv = getInterfacingRisksDiv(risks, totalMethods);
	iprintln(rankingDiv);
	
	if(rankingDiv.normal <= 25 && rankingDiv.high <= 0 && rankingDiv.veryHigh <= 0) {
		return veryPositive;
	} else if(rankingDiv.normal <= 30 && rankingDiv.high <= 5 && rankingDiv.veryHigh <= 0) {
		return positive;
	} else if(rankingDiv.normal <= 40 && rankingDiv.high <= 10 && rankingDiv.veryHigh <= 0) {
		return positive;
	} else if(rankingDiv.normal <= 50 && rankingDiv.high <= 15 && rankingDiv.veryHigh <= 5) {
		return negative;
	} else {
		return veryNegative;
	}
}

public interfacingRisks getInterfacingRisksDiv(interfacingRisks riskCount, int totalMethods) {
	interfacingRisks rankingDiv = <0,0,0,0>;
	rankingDiv.low = riskCount.low * 100 / totalMethods;
	rankingDiv.normal = riskCount.normal * 100 / totalMethods;
	rankingDiv.high = riskCount.high * 100 / totalMethods;
	rankingDiv.veryHigh = riskCount.veryHigh * 100 / totalMethods;
	
	return rankingDiv;
}

public interfacingRisks getInterfacingRisksCount(interfacingOverview overview) {
	interfacingRisks intermRanking = <0,0,0,0>;
	for(<str name, int size> <- toList(overview)) {
		if(size < 3) {
			intermRanking.low += 1;
		} else if(size < 4) {
			intermRanking.normal += 1;
		} else if(size < 5) {
			intermRanking.high += 1;
		} else {
			intermRanking.veryHigh += 1;
		}
	}
	
	return intermRanking;
}

public interfacingOverview getUnitInterfacing(list[Declaration] declarations) {

	map[str,int] parameterMapping = ();

 	for (m <- declarations) {

        //Initializer is not an method and has no parameters
        top-down-break visit(m) {
	        case \method(_, str name, list[Declaration] parameters, _): {
	        	int parameterC = size(parameters);
	         	parameterMapping += (name:parameterC);
	         }
	        case \method(_, str name, list[Declaration] parameters, _, _): {
	      	    int parameterC = size(parameters);
	        	parameterMapping += (name:parameterC);
	        }
	        case \constructor(str name, list[Declaration] parameters, _, _): {
	        	int parameterC = size(parameters);
	        	parameterMapping += (name:parameterC);
	        }
	    };   
	}
	
	return parameterMapping;
}
