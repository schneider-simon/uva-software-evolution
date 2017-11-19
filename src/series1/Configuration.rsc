module series1::Configuration

public str PAGE_BREAK_TOKEN = "%%%|||RASCAL_PAGE_BREAK|||%%%%";

public int DUPLICATION_THRESHOLD = 6;
public bool DUPLICATON_USE_PRUNING = true;
public bool DUPLICATON_COUNT_ORIGINALS = false;

public str UNIQUE_LINES_TOKEN = "%%%|||RASCAL_UNIQUE_LINES|||%%%%";
public str COMMENT_START_TOKEN = "%%%|||RASCAL_COMMENT_START|||%%%";
public str COMMENT_END_TOKEN = "%%%|||RASCAL_COMMENT_END|||%%%";

public bool DEBUG_MODE = false;