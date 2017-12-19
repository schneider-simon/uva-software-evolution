module series2::Helpers::BenchmarkHelper

import series2::Helpers::LogHelper;
import util::Benchmark;
import util::Math;
import series2::Configuration;
import IO;

public map[str, int] measures = ();

void startMeasure(str measureKey){
	measures[measureKey] = realTime(); 
	printMeasure("START: <measureKey>");
}

void stopMeasure(str measureKey){
	if(measureKey in measures == false){
		printDebug("Measure key not in storage.");
		return;
	}
	
	int measure = measures[measureKey];
	num seconds = toReal( realTime() - measure) / toReal(1000);
	
	printMeasure("FINISHED: <measureKey> after <seconds>s");
}

void printMeasure(str measureText){
	if(!BENCHMARK_MODE){
		return;
	}
	
	println(measureText);
}