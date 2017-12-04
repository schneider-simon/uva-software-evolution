module series2::Helpers::LogHelper

import IO;
import series2::Configuration;

void printDebug(value arg){
	if(DEBUG_MODE == false){
		return;
	}
	
	iprintln(arg);
}