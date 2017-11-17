module series1::Helpers::OutputHelper

import IO;
import List;

alias OutputHeads = list[str];
alias OutputRow = list[str];
alias OutputRows = list[OutputRow];

void csvTest(){
	writeCsv(|file:///tmp/helloworld.csv|, ["head1", "head2"], [["r11", "r12"], ["r21", "r22"]]);
}

void writeCsv(loc location, OutputHeads heads, OutputRows rows){
	str output = stringifyRows([heads] + rows);
	
	
	writeFile(location,output);
	println("WROTE CSV TO: <location>");
}

void writeCsv(loc location, map[str, str] mapping){
	OutputHeads heads = [head | str head <- mapping];
	OutputRow row = [mapping[head] | str head <- mapping];
	OutputRows rows = [row];
	
	writeCsv(location, heads, rows);
}

str stringifyRow(OutputRow row){
	return intercalate(";", row);
}

str stringifyRows(OutputRows rows){
	return intercalate("\n", [stringifyRow(r) | r <- rows]);
}