module series2::CloneDetection::CloneDetection

import lang::java::jdt::m3::AST;

import IO;

alias nodeLoc = tuple[loc l, node n];

loc noLocation = |project://uva-software-evolution/|;
Type defaultType = lang::java::jdt::m3::AST::short();

//Start clone detection
public void doCloneDetection(set[Declaration] ast) {

	//For type 2 - 3. Names are types are removed
	list[nodeLoc] normalizedAst = getNormalizedLocationAst(ast);
}

//Will remove all items that are inrelevant for type 2 and 3
public list[nodeLoc] getNormalizedLocationAst(set[Declaration] ast) {

	list[nodeLoc] astLocations = [];

	visit(ast) {
		case node nodeItem: {
			node normalizedNode = normalizeNode(nodeItem);
			/*loc location = */nodeFileLocation(normalizedNode);
			//astLocations += <location,normalizedNode>;
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
	return visit(nodeItem) {
		case \enumConstant(_, args, cls) => \enumConstant("enumConstant", args, cls)
		case \enumConstant(_, args) => \enumConstant("enumConstant", args) 
		case \class(_, ext, imp, bod) => \class("class", ext, imp, bod)
		case \interface(_, ext, imp, bod) => \interface("interface", ext, imp, bod)
		case \field(_, frags) => \field(defaultType, frags)
		//case \method(_, _, pars, expr, imp) => lang::java::jdt::m3::AST::method(defaultType, "method", pars, expr, imp)
		//case \method(_, _, pars, expr) => lang::java::jdt::m3::AST::method(defaultType, "method", pars, expr)
		
		case \method(rret, nnam, pparms, eexce, iimp) => \method(rret, nnam, pparms, eexce, iimp) 
    	case \method(rret, nnam, pparms, eexce) => \method(rret, nnam, pparms, eexce)
   
		case \constructor(_, pars, expr, impl) => \constructor("constructor", pars, expr, impl)
		case \variable(_,ext) => \variable("variableName",ext) 
		case \variable(_,ext, ini) => \variable("variable",ext,ini) 
		case \typeParameter(_, ext) => \typeParameter("typeParameter",ext)
		case \annotationType(_, bod) => \annotationType("annotationType", bod)
		case \annotationTypeMember(_, _) => \annotationTypeMember(defaultType, "annotationTypeMember")
		case \annotationTypeMember(_, _, def) => \annotationTypeMember(defaultType, "annotationTypeMember", def)
		case \parameter(_, _, ext) => \parameter(defaultType, "parameter", ext)
		case \vararg(_, _) => \vararg(defaultType, "vararg") 
		case \newArray(_, dim, ini) => \newArray(defaultType, dim, ini)
		case \newArray(_, dim) => \newArray(defaultType, dim)
		case \cast(_, exp) => \cast(defaultType, exp) 
		case \characterLiteral(_) => \characterLiteral("a")
		case \newObject(exp, _, arg, cls) => \newObject(exp, defaultType, arg, cls)
		case \newObject(exp, _, arg, cls) => \newObject(exp, defaultType, arg)
    	case \newObject(_, arg, cls) => \newObject(defaultType, arg, cls)
		case \newObject(_, arg, cls) => \newObject(defaultType, arg)
		case \fieldAccess(is, ex, _) => \fieldAccess(is, ex, "fa")
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
		case Modifier _ => \public()
	}
}