module series2::Helpers::OutputHelper

import IO;
import List;
import String;

import series2::Helpers::LogHelper;
import series2::Aliases;


void writeCsv(loc location, OutputHeads heads, OutputRows rows){
	str output = "";
	
	if(exists(location)){
		output = readFile(location) + "\n" +  stringifyRows(rows);
	} else {
		output = stringifyRows([heads] + rows);
	}
	
	writeFile(location,output);
	printDebug("WROTE CSV TO: <location>");
}

void writeCsv(loc location, list[HeadValue] mapping){
	OutputHeads heads = [_map.headVal | HeadValue _map <- mapping];
	OutputRow row = [_map.val | HeadValue _map <- mapping];
	OutputRows rows = [row];
	
	writeCsv(location, heads, rows);
}

str stringifyRow(OutputRow row){
	return intercalate(";", [replaceAll(r, ";", ",") | r <- row]);
}

str stringifyRows(OutputRows rows){
	return intercalate("\n", [stringifyRow(r) | r <- rows]);
}

void printThankYou(){
	println("888888 88  88    db    88b 88 88  dP     Yb  dP  dP\"Yb  88   88");
	println("  88   88  88   dPYb   88Yb88 88odP       YbdP  dP   Yb 88   88");   
	println("  88   888888  dP__Yb  88 Y88 88\"Yb        8P   Yb   dP Y8   8P");     
	println("  88   88  88 dP\"\"\"\"Yb 88  Y8 88  Yb      dP     YbodP  `YbodP\'");     
}


public void printSeperator(){
	println("=============================================");
}

public void printSubSeperator(){
	println("---------------------------------------------");
}
