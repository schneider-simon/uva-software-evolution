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
	set[Declaration] normalizedAst = getNormalizedLocationAst(ast);
	println("End get normalized AST");
	
	//Get combinations
	//nodeLocR nodeCombinations = normalizedAst * normalizedAst;
	
	//TODO: Remove reflective and symmetric clones!
	
	for (nodeLA <- normalizedAst) {
		for (nodeLB <- normalizedAst) {
			num similarity = nodeSimilarity(nodeLA, nodeLB);
		
			iprintln("Similarity: <similarity>");
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
public set[Declaration] getNormalizedLocationAst(set[Declaration] ast) {

	return visit(ast) {
		case \enumConstant(_, args, cls) => \enumConstant("enumConstant", args, cls)
		case \enumConstant(_, args) => \enumConstant("enumConstant", args)
		case \class(_, ext, imp, bod) => \class("class", ext, imp, bod)
		case \interface(_, ext, imp, bod) => \interface("interface", ext, imp, bod)
			//case \field(_, frags): return \field(defaultType, frags);
		case \method(_, _, pars, expr, imp) => \method(defaultType, "method", pars, expr, imp)
		case \method(_, _, a, b) => \method(lang::java::jdt::m3::AST::float(), "method", a, b)
		case \constructor(_, pars, expr, impl) => \constructor("constructor", pars, expr, impl)
		case \variable(_,ext) => \variable("variableName",ext)
		case \variable(_,ext, ini) => \variable("variable",ext,ini)
		case \typeParameter(_, ext) => \typeParameter("typeParameter",ext)
		case \annotationType(_, bod) => \annotationType("annotationType", bod)
		case \annotationTypeMember(_, _) => \annotationTypeMember(defaultType, "annotationTypeMember")
		case \annotationTypeMember(_, _, def) => \annotationTypeMember(defaultType, "annotationTypeMember", def)
		case \parameter(_, _, ext) => \parameter(defaultType, "parameter", ext)
		case \vararg(_, _) => \vararg(defaultType, "vararg")
			//case \newArray(_, dim, ini): return \newArray(defaultType, dim, ini);
			//case \newArray(_, dim): return \newArray(defaultType, dim);
			//case \cast(_, exp): return \cast(defaultType, exp);
		case \characterLiteral(_) => \characterLiteral("a")
			//case \newObject(exp, _, arg, cls): return \newObject(exp, defaultType, arg, cls);
			//case \newObject(exp, _, arg, cls): return \newObject(exp, defaultType, arg);
	    	//case \newObject(_, arg, cls): return \newObject(defaultType, arg, cls);
			//case \newObject(_, arg, cls): return \newObject(defaultType, arg);
			//case \fieldAccess(is, ex, _): return \fieldAccess(is, ex, "fa");
		case \fieldAccess(is, _) => \fieldAccess(is, "fa")
		case \methodCall(is, _, arg) => \methodCall(is, "methodCall", arg)
		case \methodCall(is, expr, _, arg) => \methodCall(is, expr, "methodCall", arg)
		case \number(_) => \number("1")
		case \booleanLiteral(_) => \booleanLiteral(true)
		case \stringLiteral(_) => \stringLiteral("str")
		case \type(_) => \type(defaultType)
		case \simpleName(_) => \simpleName("simpleName")
		case \markerAnnotation(_) => \markerAnnotation("markerAnnotation")
		case \normalAnnotation(_, memb) => \normalAnnotation("normalAnnotation", memb)
		case \memberValuePair(_, vl) => \memberValuePair("memberValuePair", vl)    
		case \singleMemberAnnotation(_, vl) => \singleMemberAnnotation("singleMemberAnnotation", vl)
		case \break(_) => \break("break")
		case \continue(_) => \continue("continue")
		case \label(_, bdy) => \label("label", bdy)
		case Type _ => defaultType
		case Modifier _ => lang::java::jdt::m3::AST::\public()
	}
}
