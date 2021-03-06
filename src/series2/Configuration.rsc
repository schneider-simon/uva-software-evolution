module series2::Configuration

public loc CSV_OUTPUT = |file:///tmp/output.csv|;

public bool DEBUG_MODE = false;
public bool BENCHMARK_MODE = true;

public int minimumCodeSize = 6;
public int minimalNodeGroupSize = 0;
public real minimalSimularityT3 = 80.0;