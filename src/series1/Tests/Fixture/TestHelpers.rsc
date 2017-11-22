module series1::Tests::Fixture::TestHelpers

import util::Math;
import List;
import String;

int rangedNumberFromRandom(int min, int max, int randomNumber){
	return min + abs(randomNumber) % (min - max - 1);
}

str generateRandomString(list[str] characters, int minLength, int maxLength){
	int range = arbInt(maxLength - minLength + 1);
	int length = minLength + range;
	
	return intercalate("", [getRandomFromList(characters) | i <- [0..length]]);
}

str generateRandomString(list[str] characters, int minLength, int maxLength, int amount){
	return [generateRandomString(characters, minLength, maxLength) | i <- [0..amount]];
}

str getRandomFromList(list[str] l){
	return l[arbInt(size(l))];
}