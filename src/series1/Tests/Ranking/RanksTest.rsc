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