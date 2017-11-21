module series1::Duplication::DuplicationOptions

import series1::Configuration;

alias DuplicationOptions = tuple[int threshhold, bool usePruning, bool countOriginals];
public DuplicationOptions defaultDuptlicationOptions = <DUPLICATION_THRESHOLD, DUPLICATON_USE_PRUNING, DUPLICATON_COUNT_ORIGINALS>;