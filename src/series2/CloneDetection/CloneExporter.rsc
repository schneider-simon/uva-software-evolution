module series2::CloneDetection::CloneExporter

import Set;
import List;
import IO;
alias DuplicationEntry = tuple[loc file, list[int] duplicateLines]; 
alias DuplicationExport = list[DuplicationEntry];

