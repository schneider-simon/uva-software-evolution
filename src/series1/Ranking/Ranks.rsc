module series1::Ranking::Ranks

import util::Math;
import List;

alias Ranking = tuple[str name,int val];
alias BoundRanking = tuple[Ranking ranking, num lower, num upper];

public Ranking veryPositive = <"++", 2>;
public Ranking positive = <"+", 1>;
public Ranking neutral = <"o", 0>;
public Ranking negative = <"-", -1>;
public Ranking veryNegative = <"--", -2>;

public list[Ranking] allRankings = [veryPositive, positive, neutral, negative, veryNegative];

Ranking averageRanking(list[Ranking] rankings){
	if(size(rankings) == 0){
		return neutral;
	}

	int average = floor(sum([r.val | r <- rankings]) / size(rankings));	
	
	//TODO: Really use floor? Paper is unclear on that.
	return findRankingByValue(average);
}

Ranking findRankingByValue(int val){
	assert val >= -2 : "Ranking value must be \>= -2";
	assert val <= 2 : "Ranking value must be \<= +2";
	
	return [r | r <- allRankings, r.val == val][0];
}

Ranking rankingToString(Ranking ranking){
	return ranking.name;
}

BoundRanking getBoundRanking(num rankingValue, list[BoundRanking] rankings){
	for(BoundRanking ranking <- rankings){	
		if(floor(rankingValue) < ranking.upper){
			return ranking;
		}
	}
	
	return last(rankings);
}