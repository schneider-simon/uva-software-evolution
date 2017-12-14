# Software evolution report series 2
- Simon Schneider
- Laurance Saess

# TO DO
We expect
you to find some literature on this topic yourself and use it in your design.

<< add that the ast approach is from the paper

Compared to Lab Series 1, this assignment will be more open. Your solution
will be graded using more generic criteria, with a stronger emphasis on motivation
and argumentation. You will need to use literature discussed and referenced in the
lectures to find and motivate good solutions: for instance for finding an appropriate
clone detection algorithm.

From the ass:
* The detected clone classes are written to file in a textual representation.
* Clone classes that are strictly included in others are dropped
* Show % of duplicated lines
* Show number of clones
* Show number of clone classes
* Show biggest clone (in lines),
* Show biggest clone class
* Show example clones
* one insightful vizualization of the cloning in a project.
* A convincing test harness (an automated regression test framework) that ensures your clone detector work
* Design documentation that describes and motivates the following
	* The 3 main requirements your tool satisfies from the perspective of a maintainer (see for instance [18]), and the related implementation choices.
	* The exact type of clones your tool detects. Start from Type 1, Type 2, ... but become more specific.
	* The core of the clone detection algorithm that you use (in pseudocode).
	* The vizualization(s) you implemented: how do they help a maintainer or developer?
* BONUS: Also detect Type 2 and Type 3 clone classes.
* BONUS: Implement more vizualizations that provide additional insight
* BONUS: Make sure your tool works on bigger projects such as hsqlsb16
* BONUS: Produce maintainable code that is covered by unit tests.

# Clone detection

In pseudo code:

Where:
* x is the clone type
* y is the project location
* z is the min number of sub notes

```
type = x
a = (for type = 1:100 2:100 3:30)

ast = loadAstForProject(y);
ast <- normalize @ type 2 / type 3
astList = getAllNodes(ast)
astList <- remove when subitems less than z
astList <- remove with invalid location

@no duplicate compares
@sub nodes for every node is minimal <a>
@similarity of nodeA and NodeB > a
compare astList astList to nodeA nodeB:
	return add connection:<nodeA.l,nodeB.l>

return set nodes:astList
return

where:
	similarity nodea nodeb =
	nodea.subItems `similar` nodeb.subItems /
	(nodea.subcount + nodeb.subcount) * 100
```

## Parameters

The real project has the following parameters:
* set[Declaration] ast
* bool normalizeAST
* int minimalNodeGroupSize
* real minimalSimularity

What is a little bit different than the pseudo code. In the section we are going to describe what every parameter is and how it translates to the real project.

### X is the clone type

You can define the clone type in the pseudo code. In the real project you have to translate it like this:

Type 1:
* normalizeAST = ```false```
* minimalSimularity = ```100```

Type 2:
* normalizeAST = ```true```
* minimalSimularity = ```100```

Type 3:
* normalizeAST = ```true```
* minimalSimularity = ```50``` <- or any other similarity factor you prefer.

For these settings, normalizeAST will remove all information that are type or name related. With this setting `int test` is the same as `float test2`.

For these setting, minimalSimularity will defined a percentage of how much of the node has to be the same to be considered equivalent.

### Y is the project location

The pseudo code will genarate an AST based on the location of the project. The clone detection function requires the AST already what is done in the main.

* ast = ```createAstsFromEclipseProject(createM3FromEclipseProject(y), true);```

### Z is the min number of sub notes

You can display the AST as an tree. When you compare the nodes, there will be a lot of useless small clones. This parameter can be used to define a minimum size. Nodes are only considered that contain z sub nodes.

* minimalSimularity = ```z```

# Clone classes

![Clone classes](docs/clone_classes.png)



# Visualization

![Clone map](docs/clone_map.png)

Figure: Clone map

![Edges graph](docs/edges_graph_ori.png)

Figure: Graph of clone classes

![Files graph](docs/files_graph.png)

Figure: Graph of clone files