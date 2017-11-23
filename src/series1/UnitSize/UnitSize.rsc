module series1::UnitSize::UnitSize

import series1::Volume::LinesOfCode;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;

import series1::Ranking::Ranks;
import series1::Ranking::RangeRanks;
import series1::Helpers::LogHelper;

import IO;
import Set;
import List;

alias UnitSize = int;
alias UnitSizesPerLocation = lrel[loc,UnitSize] ;

list[maxRisk] risks = [ <veryPositive,-1,25,0,0>,
						<positive,-1,30,5,0>,
						<neutral,-1,40,10,0>,
						<negative,-1,50,25,5>,
						<veryNegative,-1,-1,-1,-1>
					  ]; 

alias complexityRating = tuple[int min, int max];
complexityRating low = <0,30>;
complexityRating mid = <31,44>;
complexityRating high = <45,74>;
complexityRating veryHigh = <75,-1>;

Ranking getUnitSizeRanking(riskOverview risksList) {
	return getScaleRating(risksList, size(unitSizesLocations), risks);
}

riskOverview getUnitSizeRiskOverview(UnitSizesPerLocation unitSizesLocations) {
	riskOverview overview = <0,0,0,0>;

	for ( <_, int size> <- unitSizesLocations) {
		if(size >= low.min && size <= low.max) {
			overview.low += 1;
		}  else if(size >= mid.min && size <= mid.max) {
			overview.normal += 1;
		} else if (size >= high.min && size <= high.max) {
			overview.high  += 1;
		} else if (size >= veryHigh.min ) {
			overview.veryHigh  += 1;
		}
	}
	
	return overview;
}

UnitSizesPerLocation getUnitSizesPerLocation(list[loc] units){
	LocationsLineOfCodeStats stats = getLocStatsForLocations(units);
		
	UnitSizesPerLocation unitSizes = [<location,stats[location]["code"]> | location <- stats];
	
	return sort(unitSizes, bool(<loc location1,UnitSize size1>,<loc location2,UnitSize size2>) {
		return size1 > size2;
	});
}

