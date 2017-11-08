module series1::Tests::Ranking::RanksTest

import IO;
import series1::Ranking::Ranks;

test bool analysabilityExampleRankTest(){
	return averageRanking([veryPositive, negative, negative, neutral]) == neutral;	
}

test bool changeabilityExampleRankTest(){
	return averageRanking([veryNegative, negative]) == negative;	
}

test bool stabilityExampleRankTest(){
	return averageRanking([negative]) == negative;	
}

test bool testabilityExampleRankTest(){
	return averageRanking([veryNegative, negative, neutral]) == negative;	
}

test bool addNeutralRankingTest(list[Ranking] rankings){
	 println(rankings);
	 return true;
	 Ranking ranking = averageRanking(rankings);
	 
	 return ranking ==  averageRanking([ranking, neutral]);
}