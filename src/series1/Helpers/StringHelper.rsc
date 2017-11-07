module series1::Helpers::StringHelper

bool isOneLineComment(str line) {
	return /^(\s*\/\/)/ := line;
}

bool isLineEmpty(str line) {
	return /^\s*$/ := line;
}