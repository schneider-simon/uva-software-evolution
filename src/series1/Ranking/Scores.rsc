module series1::Ranking::Scores

import series1::Ranking::Ranks;

alias CodeProperties = tuple[Ranking volume, Ranking complexityPerUnit, Ranking duplication, Ranking unitSize, Ranking unitTesting];

Ranking getAnalysability(CodeProperties properties){
	return averageRanking([metrics.volume, metrics.duplication, metrics.unitSize, metrics.unitTesting]);
}

Ranking getChangeability(CodeProperties properties){
	return averageRanking([metrics.complexityPerUnit, metrics.duplication]);
}

Ranking getStability(CodeProperties properties){
	return averageRanking([metrics.unitTesting]);
}

Ranking getTestability(CodeProperties properties){
	return averageRanking([metrics.complexityPerUnit, metrics.unitSize, metrics.unitTesting]);
}

void outputScores(CodeProperties properties){
	println("Analysability: <rankingToString(getAnalysability(properties))>");
	println("Changeability: <rankingToString(getChangeability(properties))>");
	println("Stability: <rankingToString(getStability(properties))>");
	println("Testability: <rankingToString(getTestability(properties))>");	
}