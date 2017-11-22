module testRelation

import Set;
import Relation;
import analysis::graphs::Graph;

alias Proc = str;

// Test struct
rel[Proc, Proc] getCalls() {
	return {<"a", "b">, <"b", "c">, <"b", "d">, <"d", "c">, <"d", "e">, <"f", "e">, <"f", "g">, <"g", "e">};
}

// carrier gets all elememnts in both lists
// domain left parts
// range right part
// top all parts that connect to others but do not have a connection
// bottom parts that have receiving connections but do not have connections out
// xxxx+ is trans closure of xxxx
// closureCalls. What element is directly and indirectly related
// rel & rel = What element is in both


alias proc = str;
alias comp = str;

public rel[comp,comp] lift(rel[proc,proc] aCalls, rel[proc,comp] aPartOf){
	return { <C1, C2> | <proc P1, proc P2> <- aCalls, <comp C1, comp C2> <- aPartOf[P1] * aPartOf[P2]};
}