module series1::Helpers::LogHelper

import IO;
import series1::Configuration;

void printDebug(value arg){
	if(DEBUG_MODE == false){
		return;
	}
	
	iprintln(arg);
}