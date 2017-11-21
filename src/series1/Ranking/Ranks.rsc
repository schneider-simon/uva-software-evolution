module series1::Ranking::Ranks

import util::Math;
import List;
import IO;

alias Ranking = tuple[str name,int val];
alias BoundRanking = tuple[Ranking ranking, num lower, num upper];

public Ranking veryPositive = <"++", 4>;
public Ranking positive = <"+", 3>;
public Ranking neutral = <"o", 2>;
public Ranking negative = <"-", 1>;
public Ranking veryNegative = <"--", 0>;

public list[Ranking] allRankings = [veryPositive, positive, neutral, negative, veryNegative];

Ranking averageRanking(list[Ranking] rankings){
	if(size(rankings) == 0){
		return neutral;
	}

	int average = round(toReal(sum([r.val | r <- rankings])) / toReal(size(rankings)));	
	
	return findRankingByValue(average);
}

Ranking findRankingByValue(int val){
	assert val >= 0 : "Ranking value must be \>= 0";
	assert val <= 4 : "Ranking value must be \<= 4";
	
	return [r | r <- allRankings, r.val == val][0];
}

str rankingToString(Ranking ranking){
	return ranking.name;
}

BoundRanking getBoundRanking(num rankingValue, list[BoundRanking] rankings){
	assert size(rankings) > 0: "You have to provide at least one bound ranking";
	
	for(BoundRanking ranking <- rankings){	
		if(round(rankingValue) < ranking.upper){
			return ranking;
		}
	}
	
	return last(rankings);
}