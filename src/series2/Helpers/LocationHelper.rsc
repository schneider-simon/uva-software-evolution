module series2::Helpers::LocationHelper

public int getSafeOffset(loc location){
	try return location.offset; catch: return -1;
}

public bool locationHasArea(loc location){
	return getSafeOffset(location) != -1;
}