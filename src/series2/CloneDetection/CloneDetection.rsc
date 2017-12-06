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
alias nodeDetailed = tuple[nodeId id, node d, loc l, int s]; 
alias cloneDetectionResult = tuple[map[nodeId, nodeDetailed] nodeDetails, rel[nodeId f,nodeId s] connections];
alias nodeId = int;

loc noLocation = |unresolved:///|;
Type defaultType = lang::java::jdt::m3::AST::short();

//Start clone detection
//Type 2: simularity = 100
//Type 3: simularity = 30?
public cloneDetectionResult doCloneDetection(set[Declaration] ast, bool normalizeAST, int minimalNodeGroupSize, real minimalSimularity) {

	cloneDetectionResult results = <(),{}>;

	//For type 2 - 3. Names are types are removed
	set[Declaration] testOnAst = ast;
	if(normalizeAST) {
		println("Get normalized AST");
		testOnAst = getNormalizedLocationAst(ast);
		println("End normalized AST");
	}
	
	//Create list of all nodes
	println("Creating node list");
	list[node] nodes = declarationToNodeList(testOnAst);
	println("End creating node list");
	
	println("Adding node details");
	list[tuple[int id, node n]] nodeWId = zip([1..(size(nodes) + 1)], nodes);
	list[nodeDetailed] nodeWLoc = [ <id, unsetRec(nodeI), nLoc, size> | 
									<id,nodeI> <- nodeWId, 
									nLoc := nodeFileLocation(nodeI), 
									size := nodeSize(nodeI),
									size >= minimalNodeGroupSize,
									nLoc != noLocation ];
							
	println("End adding node details");

	println("Comparing nodes");
	int nodeItems = size(nodeWLoc);
	int counter = 0;
	for (nodeLA <- nodeWLoc) {
		iprintln("<counter> / <nodeItems>");
		counter = counter + 1;
		
		//TODO: only with higher ID!
		for (nodeLB <- nodeWLoc) {
				
			//Only comapre with biger items, otherwise duplicates
			if(nodeLA.id >= nodeLB.id)
				continue;
				
			//Compare different and valid locations
			if(nodeLA.l == nodeLB.l || nodeLA.l == noLocation || nodeLB.l == noLocation) 
				continue;
		
			//When the node count difference is too much, the simulairty cannot be in the margin
			if( nodeLA.s > nodeLB.s || nodeLB.s == 0 || nodeLA.s == 0 || percent(nodeLA.s,nodeLB.s) < minimalSimularity)
				continue;
			
			//Minimal similarity
			num similarity = nodeSimilarity(nodeLA.d, nodeLB.d);
			if(similarity < minimalSimularity)
				continue;
							
			//Log items that are the same
			iprintln("Similarity: <similarity>");
			iprintln("Loc a: <nodeLA.l> Loc b: <nodeLB.l>");
			results.connections[nodeLA.id] = nodeLB.id;
		}
	}
	println("End comparing nodes");
	
	for(nodeI <- nodeWLoc) {
		results.nodeDetails += (nodeI.id:nodeI);
	}
	
	return results;
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
	
	//iprintln("sameElements: <sameElements> totalItems: <totalItems>");
	
	return sameElements / totalItems * 100;
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
