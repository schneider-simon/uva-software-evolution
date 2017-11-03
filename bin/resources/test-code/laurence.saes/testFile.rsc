module testFile

import List;
import IO;
import String;

//Fibonatie with patern matching
public int fib(0) = 0;
public int fib(1) = 1;
public default int fib(int n) = fib(n - 1) + fib(n - 2);

//Basic loop over list
public int sumList(list [int] numbers) {
	int sum = 0;
	for(int i <- [0 .. size(numbers)])
      sum = sum + numbers[i];
    
    return sum;  
}

//Basic loop
public int sumTill(int stopAt) {
	int sum = 0;
	for (int i <- [1..stopAt + 1])
		sum += i;
	return sum;
}

public tuple[int,int] swapTupel(tuple[int,int] tup) {
	return <tup[1],tup[0]>; 
}

//Basic sort with list matching
int counter = 0;
public list[int] testSort(list [int] numbers) {

	while([*int beginList, int p, *int mid, int q, *int endList] := numbers && p > q ) {
		counter = counter + 1;
		println("<beginList> ++ [<q>] ++ <mid> ++ [<p>] ++ <endList>");
		numbers = beginList + [q] + mid + [p] + endList;		
	}
	
	println("Total count: <counter>");
	
	return numbers;
}

//Basic sort with switch
public list[int] testSort2(list [int] numbers) {
	switch(numbers) {
		case [*int num1, int p, *int num2, int q, *int num3]:
			if ( p > q ) {
				return testSort2 (num1 + [q] + num2 + [p] + num3);
			} else {
				fail;
			}
		
		default: return numbers;
	}
}

// Basic search with parameter binding
public list[int] testSort3([*int num1, int p, *int num2, int q, *int num3])
= testSort3(num1 + [q] + num2 + [p] + num3) when (p > q);

public default list[int] testSort3(list[int] x) = x;

//Getting even numbers. No array type, condition in for, addition in array
public list[int] even1(int till) {
	results = [];
	for (i <- [0 .. till + 1], i % 2 == 0) {
		results += i;
	}
	return results;
} 

public list[int] even2(int till) = [i | i <- [0 .. till + 1], i % 2 == 0 ];

data SomeStructure = valu(int n)
				   | btf (SomeStructure l, SomeStructure r)
				   | bts (SomeStructure l, SomeStructure r);

public int cntBtf(SomeStructure t){
   int c = 0;
   visit(t) {
     case btf(_,_): c = c + 1;      
   };
   return c;
}

public SomeStructure toBtf(SomeStructure t) {
	return visit(t) {
		case bts(l, r) => btf(l,r)
	};
}

// cntBtf (btf (bts (valu(1), valu(1)), btf (valu(2), valu(3))))

/*
	On a map:
	name = getName(M);   
    freq[name] ? 0 += 1;

	When name is not found, initialize it to 0
*/

public str capitalize(str s) {  
  return toUpperCase(substring(s, 0, 1)) + substring(s, 1);
}

public str getSomeString(str x) {
	return "public void set<capitalize(x)>(<capitalize(x)> <x>) {
         '  this.<x> = <x>;
         '}";
}

//Regex
public int countInLine1(str S){
  int count = 0;
  for(/[a-zA-Z0-9_]+/ := S){
       count += 1;
  }
  return count;
}

public int countInLine2(str S){
  int count = 0;
  
  // \w matches any word character
  // \W matches any non-word character
  // <...> are groups and should appear at the top level.
  while (/^\W*<word:\w+><rest:.*$>/ := S) { 
    count += 1; 
    S = rest; 
  }
  return count;
}

public int countInLine3(str S){
  return (0 | it + 1 | /\w+/ := S);
}

