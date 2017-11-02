module FindComplexFiles

import IO;
import List;
import Exception;
import ParseTree;
import util::FileSystem;
import lang::java::\syntax::Disambiguate;
import lang::java::\syntax::Java15;

import CalculateCC;

lrel[int cc, loc method] findComplexFiles(loc project, int limit = 10) {
  println(project);
  
  result = [*maxCC(f) | /file(f) <- crawl(project), f.extension == "java"];	
  result = sort(result, bool (<int a, loc _>, <int b, loc _>) { return a < b; });
  return head(reverse(result), limit);
}

void findComplexFiles2() {
  loc project = |project://TestJavaProject/|;
  FileSystem crawled = crawl(project);
   
  list[loc] files = [*f | /file(f) <- crawl(project), f.extension == "java"];
  loc firstFile = files[0];
  println(allMethods(firstFile));
}

set[MethodDec] allMethods(loc file) 
  = {m | /MethodDec m := parse(#start[CompilationUnit], file)};

lrel[int cc, loc method] maxCC(loc file) 
  = [<cyclomaticComplexity(m), m@\loc> | m <- allMethods(file)];