module series1::Tests::Fixture::TestHelpers

import util::Math;

int rangedNumberFromRandom(int min, int max, int randomNumber){
	return min + abs(randomNumber) % (min - max - 1);
}