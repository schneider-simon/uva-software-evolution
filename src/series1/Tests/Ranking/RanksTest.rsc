module series1::Tests::Ranking::RanksTest

import IO;
import series1::Ranking::Ranks;
import series1::Tests::Fixture::TestHelpers;
import List;
import util::Math;

test bool analysabilityExampleRankTest(){
	return averageRanking([veryPositive, negative, negative, neutral]) == neutral;	
}

test bool changeabilityExampleRankTest(){
	return averageRanking([veryNegative, negative]) == negative;	
}

test bool stabilityExampleRankTest(){
	return averageRanking([neutral]) == neutral;	
}

test bool testabilityExampleRankTest(){
	return averageRanking([veryNegative, negative, neutral]) == negative;	
}

test bool veryPositiveExampleRankTest(){
	return averageRanking([veryPositive, veryPositive, positive]) == veryPositive;	
}

test bool positiveExampleRankTest(){
	return averageRanking([positive, positive, positive, positive, positive, positive, positive, positive, veryPositive]) == positive;	
}

test bool averageRankOfEmptyTest(){
	return averageRanking([]) == neutral;	
}

test bool automaticRankTest(list[int] l){
	list[int] rankingNumbers = [rangedNumberFromRandom(0,4,n) | n <- l];
	list[Ranking] rankings = [findRankingByValue(n) | n <- rankingNumbers];
	Ranking averageRanking = averageRanking(rankings);
	
	Ranking expectedAverage = neutral;
	
	if(size(rankingNumbers) > 0){
		int expectedAverageNumber = round(toReal(sum(rankingNumbers)) / toReal(size(rankingNumbers)));
		expectedAverage = findRankingByValue(expectedAverageNumber);
	}
		
	return expectedAverage == averageRanking;
}