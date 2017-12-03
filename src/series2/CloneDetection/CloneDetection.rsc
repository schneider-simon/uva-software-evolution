module series2::CloneDetection::CloneDetection

import lang::java::jdt::m3::AST;

import IO;
import List;
import Set;

alias nodeLoc = tuple[loc l, node n];
alias nodeLocR = lrel[nodeLoc l, nodeLoc r];

loc noLocation = |project://uva-software-evolution/|;
Type defaultType = lang::java::jdt::m3::AST::short();

//Start clone detection
public void doCloneDetection(set[Declaration] ast) {

	//For type 2 - 3. Names are types are removed
	println("Get normalized AST");
	list[nodeLoc] normalizedAst = getNormalizedLocationAst(ast);
	println("End get normalized AST");
	
	//Get combinations
	//nodeLocR nodeCombinations = normalizedAst * normalizedAst;
	
	//TODO: Remove reflective and symmetric clones!
	
	for (nodeLA <- normalizedAst) {
		for (nodeLB <- normalizedAst) {
			num similarity = nodeSimilarity(nodeLA.n, nodeLB.n);
		
			iprintln("Loc: <nodeLA.l> - <nodeLB.l> : similarity: <similarity>");
		}
	}
	
}

public list[node] nodeToNodeList(node iNode) {
	list[node] nodeList = [];
	visit (iNode) {
		case node x: {
			nodeList += x;
		}
	}
	
	return nodeList;
}

/*
	Todo: Extract the lines per node. Use these to determine how many % is the same
		  Also return how many lines are the same?
*/
public num nodeSimilarity(node nodeA, node nodeB) {
	list[node] nodeList1 = nodeToNodeList(nodeA);
	list[node] nodeList2 = nodeToNodeList(nodeB);
	
	num sameElements = size(nodeList1 & nodeList2);
	num totalItems = size(nodeList1) + size(nodeList2) - sameElements;
	
	return sameElements / totalItems;
}

//Will remove all items that are inrelevant for type 2 and 3
public list[nodeLoc] getNormalizedLocationAst(set[Declaration] ast) {

	list[nodeLoc] astLocations = [];

	visit(ast) {
		case node nodeItem: {
			node normalizedNode = normalizeNode(nodeItem);
			loc location = nodeFileLocation(normalizedNode);
			astLocations += <location,normalizedNode>;
		}
	}
	
	return astLocations;
}

/*
	We are not interested in other locations. We compare blocks, and a block 
	is a Declaration, Expression or Statement
*/
public loc nodeFileLocation(node n) {

	if (Declaration d := n) { 
		return d.decl;
	}
	
	if (Expression e := n) { 
		return e.src;
	}
	
	if (Statement s := n) { 
		return s.src;
	}	 
	
	return noLocation;
}

/**
	The following elements do not have to be changed:
		* compilationUnit
		* enum
		* class without name
		* initializer
		* import
		* package
		* arrayAccess
		* arrayInitializer
		* assignment
		* qualifiedName
		* conditional
		* instanceof
		* null
		* ....
*/
public node normalizeNode(nodeItem) {
	switch(nodeItem) {
		case \enumConstant(_, args, cls): return \enumConstant("enumConstant", args, cls);
		case \enumConstant(_, args): return \enumConstant("enumConstant", args);
		case \class(_, ext, imp, bod): return \class("class", ext, imp, bod);
		case \interface(_, ext, imp, bod): return \interface("interface", ext, imp, bod);
			//case \field(_, frags): return \field(defaultType, frags);
		//case \method(_, _, pars, expr, imp): return lang::java::jdt::m3::AST::method(defaultType, "method", pars, expr, imp)
		//case \method(_, _, pars, expr): return lang::java::jdt::m3::AST::method(defaultType, "method", pars, expr)
		case \constructor(_, pars, expr, impl): return \constructor("constructor", pars, expr, impl);
		case \variable(_,ext): return \variable("variableName",ext);
		case \variable(_,ext, ini): return \variable("variable",ext,ini);
		case \typeParameter(_, ext): return \typeParameter("typeParameter",ext);
		case \annotationType(_, bod): return \annotationType("annotationType", bod);
		case \annotationTypeMember(_, _): return \annotationTypeMember(defaultType, "annotationTypeMember");
		case \annotationTypeMember(_, _, def): return \annotationTypeMember(defaultType, "annotationTypeMember", def);
		case \parameter(_, _, ext): return \parameter(defaultType, "parameter", ext);
		case \vararg(_, _): return \vararg(defaultType, "vararg");
			//case \newArray(_, dim, ini): return \newArray(defaultType, dim, ini);
			//case \newArray(_, dim): return \newArray(defaultType, dim);
			//case \cast(_, exp): return \cast(defaultType, exp);
		case \characterLiteral(_): return \characterLiteral("a");
			//case \newObject(exp, _, arg, cls): return \newObject(exp, defaultType, arg, cls);
			//case \newObject(exp, _, arg, cls): return \newObject(exp, defaultType, arg);
	    	//case \newObject(_, arg, cls): return \newObject(defaultType, arg, cls);
			//case \newObject(_, arg, cls): return \newObject(defaultType, arg);
			//case \fieldAccess(is, ex, _): return \fieldAccess(is, ex, "fa");
		case \fieldAccess(is, _): return \fieldAccess(is, "fa");
		case \methodCall(is, _, arg): return \methodCall(is, "methodCall", arg);
		case \methodCall(is, expr, _, arg): return \methodCall(is, expr, "methodCall", arg);
		case \number(_): return \number("1");
		case \booleanLiteral(_): return \booleanLiteral(true);
		case \stringLiteral(_): return \stringLiteral("str");
		case \type(_): return \type(defaultType);
		case \simpleName(_): return \simpleName("simpleName");
		case \markerAnnotation(_): return \markerAnnotation("markerAnnotation");
		case \normalAnnotation(_, memb): return \normalAnnotation("normalAnnotation", memb);
		case \memberValuePair(_, vl): return \memberValuePair("memberValuePair", vl);          
		case \singleMemberAnnotation(_, vl): return \singleMemberAnnotation("singleMemberAnnotation", vl);
		case \break(_): return \break("break");
		case \continue(_): return \continue("continue"); 
		case \label(_, bdy): return \label("label", bdy);
		case Type _: return defaultType;
		case Modifier _: return \public();
	}
	
	return nodeItem;
}