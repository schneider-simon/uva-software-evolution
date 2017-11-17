module series1::Tests::RangeRanks::RangeRankTest

import series1::Ranking::RangeRanks;
import series1::Ranking::Ranks;

import IO;


test bool borderRoundUpTest(){
	riskOverview risks = <1,0,0,0>;
	int totalItems = 200;
	list[maxRisk] maxRisks = [<positive, 1, 1, 1, 1>, <neutral, -1, -1, -1, -1>];
	
	Ranking outP = getScaleRating(risks, totalItems, maxRisks);
	return outP == positive;
}

test bool borderRoundDownTest(){
	riskOverview risks = <149,0,0,0>;
	int totalItems = 10000;
	list[maxRisk] maxRisks = [<positive, 1, 1, 1, 1>, <neutral, -1, -1, -1, -1>];
	
	Ranking outP = getScaleRating(risks, totalItems, maxRisks);
	return outP == positive;
}

test bool borderRoundDownTestF(){
	riskOverview risks = <150,0,0,0>;
	int totalItems = 10000;
	list[maxRisk] maxRisks = [<positive, 1, 1, 1, 1>, <neutral, -1, -1, -1, -1>];
	
	Ranking outP = getScaleRating(risks, totalItems, maxRisks);
	return outP != positive;
}