module series1::Tests::Helpers::StringHelperTest

import series1::Tests::Fixture::TestHelpers;
import series1::Helpers::StringHelper;
import IO;
import String;

list[str] WHITE_SPACES = ["\u0009","\u000A","\u000B","\u000C","\u000D"];
list[str] NON_WHITE_SPACES = ["a", "[", "]", "Z", "A", "ä", "ß", "?", "(", ";", "\<", "\>", ")", "%", "&"];
list[str] COMMENT_CHARACTERS = ["/", "*"];

test bool isEmptyLineTest(int length){
	length = rangedNumberFromRandom(0, 200, length);
	str randomEmptyString = generateRandomString(WHITE_SPACES, 0, length);
	return isLineEmpty(randomEmptyString) == true;
}

test bool isLineNotEmptyTest(int length){
	length = rangedNumberFromRandom(1, 200, length);
	str randomNonEmptyString = generateRandomString(NON_WHITE_SPACES, 1, length);
	return isLineEmpty(randomNonEmptyString) == false;
}

test bool bracketIsCodeLineTest(){
	return isCodeLine("{", false) == false && 
			isCodeLine("}", false) == false &&
			isCodeLine("}", true) == true &&
			isCodeLine("{", true) == true;
}

test bool emptyIsNotCodeTest(str line){
	line = replaceAll(line, "\n", "");
	
	if(isLineEmpty(line) && isCodeLine(line, true)){
		return false;
	}
	
	return true;
}
