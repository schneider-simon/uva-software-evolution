module series1::Helpers::OutputHelper

import IO;
import List;

alias OutputHeads = list[str];
alias OutputRow = list[str];
alias OutputRows = list[OutputRow];
alias HeadValue = tuple[str headVal, str val];

void csvTest(){
	writeCsv(|file:///tmp/helloworld.csv|, ["head1", "head2"], [["r11", "r12"], ["r21", "r22"]]);
}

void writeCsv(loc location, OutputHeads heads, OutputRows rows){
	str output = stringifyRows([heads] + rows);
	
	
	writeFile(location,output);
	println("WROTE CSV TO: <location>");
}

void writeCsv(loc location, list[HeadValue] mapping){
	OutputHeads heads = [_map.headVal | HeadValue _map <- mapping];
	OutputRow row = [_map.val | HeadValue _map <- mapping];
	OutputRows rows = [row];
	
	writeCsv(location, heads, rows);
}

str stringifyRow(OutputRow row){
	return intercalate(";", row);
}

str stringifyRows(OutputRows rows){
	return intercalate("\n", [stringifyRow(r) | r <- rows]);
}