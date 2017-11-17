module series1::Ranking::RangeRanks

import series1::Ranking::Ranks;

import util::Math;

import List;
import Map;
import IO;

alias riskOverview = tuple[int low, int normal, int high, int veryHigh];

alias maxRisk = tuple[Ranking rankLevel, int low, int normal, int high, int veryHigh];

public Ranking getScaleRating(riskOverview risks, int totalItems, list[maxRisk] maxRisks) {

	riskOverview rankingDiv = getRisksDiv(risks, totalItems);
	for(maxRiskItem <- maxRisks) {
		if((rankingDiv.low <= maxRiskItem.low || maxRiskItem.low == -1) &&
		   (rankingDiv.normal <= maxRiskItem.normal || maxRiskItem.normal == -1) &&
		   (rankingDiv.high <= maxRiskItem.high || maxRiskItem.high == -1) &&
		   (rankingDiv.veryHigh <= maxRiskItem.veryHigh || maxRiskItem.veryHigh == -1)) {
			return maxRiskItem.rankLevel;
		} 
	}

	return veryNegative;
}

public riskOverview getRisksDiv(riskOverview riskCount, num totalMethods) {
	riskOverview rankingDiv = <0,0,0,0>;
	rankingDiv.low = round(toRat(riskCount.low,1) * 100.0 / totalMethods); //TODO: to real. Round
	rankingDiv.normal = round(toRat(riskCount.normal,1) * 100.0 / totalMethods);
	rankingDiv.high = round(toRat(riskCount.high,1) * 100.0 / totalMethods);
	rankingDiv.veryHigh = round(toRat(riskCount.veryHigh,1) * 100.0 / totalMethods);
	
	return rankingDiv;
}
