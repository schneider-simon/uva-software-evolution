module series2::ast::AstTransformation

import IO;
import ParseTree;
import util::ValueUI;
import lang::java::\syntax::Java15;

CompilationUnit removeIdentifiers(CompilationUnit unit) {
	innermost visit(unit) {
		case (Stm) `if (!<Expr cond>) <Stm a> else <Stm b>` :
			iprintln("IF FOUND");
		}
	}
		   
	return unit;
}

bool testAstTransformation() {
  code = (CompilationUnit) `class MyClass { int m() { if (!x) println("x"); else println("y");  if (x) return true; else return false; } }`;
  
  code2 = removeIdentifiers(code);
    
  return code2 == (CompilationUnit) `class MyClass    { int m() { if (x) { println("y"); } else { println("x"); }  return x; } }` ;
}