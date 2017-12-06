module series2::CloneDetection::CloneDetection

import lang::java::jdt::m3::AST;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;
import util::ValueUI;

import IO;
import List;
import Node;
import Set;

import util::Math;

alias nodeS = tuple[node d,int s];
alias nodeDetailed = tuple[nodeId id, node d, loc l]; 
alias cloneDetectionResult = tuple[list[nodeDetailed] nodeDetails, lrel[nodeId,nodeId] connections];
alias nodeId = int;

loc noLocation = |project://uva-software-evolution/|;
Type defaultType = lang::java::jdt::m3::AST::short();

//Start clone detection
//Type 2: simularity = 100
public void doCloneDetection(set[Declaration] ast, int minimalNodeGroupSize, real minimalSimularity) {

	//For type 2 - 3. Names are types are removed
	println("Get normalized AST");
	set[Declaration] normalizedAst = getNormalizedLocationAst(ast);
	println("End normalized AST");
	
	//TODO: Add index, later only compare when: a.id < b.id ZIP
	//TODO: Get locations, add next to the node! (first src?)
	//TODO: Remove the locations in the node unsetRec
	
	//Create list of all nodes
	println("Creating node list");
	list[node] nodes = declarationToNodeList(normalizedAst);
	println("End creating node list");
	
	//TODO: Do this step in the node list creation
	println("Getting size of nodes");
	list[nodeS] nodeSizes = [ <item,size> | item <- nodes, size := nodeSize(item), size >= minimalNodeGroupSize];
	println("End getting size of nodes");

	text(nodeSizes);

	println("Comparing nodes");
	int nodeItems = size(nodeSizes);
	int counter = 0;
	
	for (nodeLA <- nodeSizes) {
		iprintln("<counter> / <nodeItems>");
		counter = counter + 1;
		
		//TODO: only with higher ID!
		for (nodeLB <- nodeSizes) {
			//When the node count difference is too much, the simulairty cannot be in the margin
			if( nodeLA.s > nodeLB.s || nodeLB.s == 0 || percent(nodeLA.s,nodeLB.s) < minimalSimularity)
				continue;
			
			//Compare different and valid locations
			loc LAloc = nodeFileLocation(nodeLA.d);
			loc LBloc = nodeFileLocation(nodeLB.d);
			if(LAloc == LBloc || LAloc == noLocation || LBloc == noLocation) 
				continue;
			
			//Minimal similarity
			num similarity = nodeSimilarity(nodeLA.d, nodeLB.d);
			if(similarity < minimalSimularity)
				continue;
							
			//Log items that are the same
			iprintln("Similarity: <similarity>");
			iprintln("Loc a: <LAloc> Loc b: <LBloc>");
		}
	}
	println("End comparing nodes");
}

public int nodeSize(node nodeItem) {
	
	int counter = 0;
	visit (nodeItem) {
		case Statement _: counter += 1;
		case Expression _: counter += 1;
	}
	
	return counter;
}

public list[node] declarationToNodeList(set[Declaration] decs) {
	
	list[node] nodeList = [];
	for(dec <- decs) {
		nodeList += nodeToNodeList(dec);
	}
	return nodeList;
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

//Will remove all items that are inrelevant for type 2 and 3
public set[Declaration] getNormalizedLocationAst(set[Declaration] ast) {
	return visit(ast) {
		case node nodeItem => normalizeNode(nodeItem)
	}
}

//Will remove all items that are inrelevant for type 2 and 3
public node normalizeNode(node nodeItem) {

	return visit(nodeItem) {
		case \enumConstant(_, args, cls) => \enumConstant("enumConstant", args, cls)
		case \enumConstant(_, args) => \enumConstant("enumConstant", args)
		case \class(_, ext, imp, bod) => \class("class", ext, imp, bod)
		case \interface(_, ext, imp, bod) => \interface("interface", ext, imp, bod)
		case \method(_, _, a, b, c) => \method(defaultType, "method", a, b, c)
		case \method(Type a,str b,list[Declaration] c,list[Expression] d) => \method(a,b,c,d)
		case \constructor(_, pars, expr, impl) => \constructor("constructor", pars, expr, impl)
		case \variable(_,ext) => \variable("variableName",ext)
		case \variable(_,ext, ini) => \variable("variable",ext,ini)
		case \typeParameter(_, ext) => \typeParameter("typeParameter",ext)
		case \annotationType(_, bod) => \annotationType("annotationType", bod)
		case \annotationTypeMember(_, _) => \annotationTypeMember(defaultType, "annotationTypeMember")
		case \annotationTypeMember(_, _, def) => \annotationTypeMember(defaultType, "annotationTypeMember", def)
		case \parameter(_, _, ext) => \parameter(defaultType, "parameter", ext)
		case \vararg(_, _) => \vararg(defaultType, "vararg")
		case \characterLiteral(_) => \characterLiteral("a")
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
