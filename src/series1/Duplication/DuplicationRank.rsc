module series1::Duplication::DuplicationRank

import series1::Ranking::Ranks;
import IO;

public BoundRanking veryPositiveDuplication = <veryPositive, 0, 3>;
public BoundRanking positiveDuplication = <positive, 3, 5>;
public BoundRanking neutralDuplication = <neutral, 5, 10>;
public BoundRanking negativeDuplication = <negative, 10, 20>;
public BoundRanking veryNegativeDuplication = <veryNegative, 20, 100>;

public list[BoundRanking] allDuplicationRankings = [veryPositiveDuplication, positiveDuplication,neutralDuplication, negativeDuplication, veryNegativeDuplication];  

Ranking getDuplicationRanking(num duplicatedLines, num linesOfCode){	
	return getDuplicationRanking(duplicatedLines / linesOfCode * 100);
}

Ranking getDuplicationRanking(num percentDuplicated){
	 return getBoundRanking(percentDuplicated, allDuplicationRankings).ranking;
}