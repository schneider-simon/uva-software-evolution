module series1::UnitInterfacing::UnitInterfacing
 
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core;

import series1::Ranking::Ranks;
import series1::Ranking::RangeRanks;

import List;
import Map;
import IO;

alias interfacingOverview = map[str,int];

list[maxRisk] risks = [ <veryPositive,-1,25,0,0>,
						<positive,-1,30,5,0>,
						<neutral,-1,40,10,0>,
						<negative,-1,50,25,5>,
						<veryNegative,-1,-1,-1,-1>
					  ]; 

public Ranking getUnitInterfacingRating(interfacingOverview overview) {
	riskOverview risksList = getInterfacingRisksCount(overview);
	int totalMethods = size(overview);
	
	return getScaleRating(risksList, totalMethods, risks);
}

public riskOverview getInterfacingRisksCount(interfacingOverview overview) {
	riskOverview intermRanking = <0,0,0,0>;
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
