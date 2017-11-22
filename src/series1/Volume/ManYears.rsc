module series1::Volume::ManYears

import series1::Volume::LinesOfCode;
import series1::Ranking::Ranks;
import util::Math;
import IO;

alias ManYear = int;
alias ManYearsRanking = tuple[Ranking rankingType, ManYear minYears,ManYear maxYears,KLOC minKLOC,KLOC maxKLOC];

/*
rank MY 			Java
++   0 − 8 		0-66
+    8 − 30 		66-246
o    30 − 80 	246-665
-    80 − 160 	665-1,310 
--   > 160 > 	1310 
*/

ManYearsRanking manYears1 = <veryPositive,   0,    8,    0,   66>;
ManYearsRanking manYears2 = <positive,    	8,   30,   66,  246>;
ManYearsRanking manYears3 = <neutral,   		30,   80,  246,  665>;
ManYearsRanking manYears4 = <negative,   		80,  160,  665, 1310>;
ManYearsRanking manYears5 = <veryNegative,  	160,  -1,  1310,  -1>;

list[ManYearsRanking] manYearRankings = [manYears1, manYears2, manYears3, manYears4, manYears5];

ManYearsRanking getManYearsRanking(int linesOfCode){
	KLOC kloc = toReal(linesOfCode / 1000.0);
	
	for(ManYearsRanking ranking <- manYearRankings){
		if(ranking.maxYears == -1){
			return ranking;
		}
	
		if(floor(kloc) < ranking.maxKLOC){
			return ranking;
		}
	}
	
	return manYears5;
}

str manYearsRankingToString (ManYearsRanking ranking){
	str yearsRange = "<ranking.minYears>-<ranking.maxYears>";
	if(ranking.maxYears == -1){
		yearsRange = "\><ranking.minYears>";
	}  
	
	str klocsRange = "<ranking.minKLOC>-<ranking.maxKLOC>";
	if(ranking.maxKLOC == -1){
		klocsRange = "\><ranking.minKLOC>";
	}
	
	return "<ranking.rankingType.name> \t <yearsRange> MYs \t <klocsRange> KLOCs";
}
