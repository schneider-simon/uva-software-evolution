module series1::UnitSize::UnitSize

import series1::Volume::LinesOfCode;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import IO;
import Set;
import List;

alias UnitSize = int;
alias UnitSizesPerLocation = lrel[loc,UnitSize] ;

void testUSize(){
	M3 myModel = createM3FromEclipseProject(|project://TestJavaProject|);
	list[loc] modelMethods = toList(methods(myModel));
	
	
	
	iprintln(getUnitSizesPerLocation(modelMethods));
}

UnitSizesPerLocation getUnitSizesPerLocation(list[loc] units){
	LocationsLineOfCodeStats stats = getLocStatsForLocations(units);
		
	UnitSizesPerLocation unitSizes = [<location,stats[location]["code"]> | location <- stats];
	
	return sort(unitSizes, bool(<loc location1,UnitSize size1>,<loc location2,UnitSize size2>) {
		return size1 > size2;
	});
}

