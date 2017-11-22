module series1::Tests::Volume::ManYearsTest

import series1::Volume::ManYears;
import series1::Ranking::Ranks;

bool assertManYears(int lines, Ranking expectedRanking){
	return getManYearsRanking(lines).rankingType == expectedRanking;
}

test bool testManYearsVeryPositive(){
	return 	assertManYears(0, veryPositive) && 
			assertManYears(66000 - 1, veryPositive) && 
			assertManYears(66000, veryPositive) == false;
}

test bool testManYearsPositive(){
	return 	assertManYears(66000, positive) && 
			assertManYears(246000 - 1, positive);
}

test bool testManYearsNeutral(){
	return 	assertManYears(246000, neutral) && 
			assertManYears(665000 - 1, neutral);
}

test bool testManYearsNegative(){
	return 	assertManYears(665000, negative) && 
			assertManYears(1310000 - 1, negative);
}

test bool testManYearsVeryNegative(){
	return 	assertManYears(1310000, veryNegative) && 
			assertManYears(99999999999, veryNegative);
}