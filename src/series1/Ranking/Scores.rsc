module series1::Ranking::Scores

import series1::Ranking::Ranks;
import IO;
import DateTime;

alias CodeProperties = tuple[Ranking volume, Ranking complexityPerUnit, Ranking duplication, Ranking unitSize, Ranking unitTesting, Ranking unitInterfacing];
alias HeadValue = tuple[str headVal, str val];

public CodeProperties emptyCodeProperties = <neutral, neutral, neutral, neutral, neutral, neutral>;

Ranking getAnalysability(CodeProperties properties){
	return averageRanking([properties.volume, properties.duplication, properties.unitSize, properties.unitTesting]);
}

Ranking getChangeability(CodeProperties properties){
	return averageRanking([properties.complexityPerUnit, properties.duplication]);
}

Ranking getStability(CodeProperties properties){
	return averageRanking([properties.unitTesting]);
}

Ranking getTestability(CodeProperties properties){
	return averageRanking([properties.complexityPerUnit, properties.unitSize, properties.unitTesting]);
}

void outputProperties(CodeProperties properties){
	println("Volume: <rankingToString(properties.volume)>");
	println("ComplexityPerUnit: <rankingToString(properties.complexityPerUnit)>");
	println("Dupliction: <rankingToString(properties.duplication)>");
	println("UnitSize: <rankingToString(properties.unitSize)>");
	println("UnitTesting: <rankingToString(properties.unitTesting)>");
	println("UnitInterfacing: <rankingToString(properties.unitInterfacing)>");
}

void outputScores(CodeProperties properties){
	println("Analysability: <rankingToString(getAnalysability(properties))>");
	println("Changeability: <rankingToString(getChangeability(properties))>");
	println("Stability: <rankingToString(getStability(properties))>");
	println("Testability: <rankingToString(getTestability(properties))>");	
}

list[HeadValue] getCodeResultMapping(CodeProperties properties){
	return [
		<"Volume",rankingToString(properties.volume)>,
		<"ComplexityPerUnit", rankingToString(properties.complexityPerUnit)>, 
		<"Dupliction", rankingToString(properties.duplication)>,
		<"UnitSize", rankingToString(properties.unitSize)>,
		<"UnitTesting", rankingToString(properties.unitTesting)>,
		<"UnitInterfacing", rankingToString(properties.unitInterfacing)>,
		<"Analysability", rankingToString(getAnalysability(properties))>,
		<"Changeability", rankingToString(getChangeability(properties))>,
		<"Stability", rankingToString(getStability(properties))>,
		<"Testability", rankingToString(getTestability(properties))>		
	];
}