# Software evolution report series 2
- Simon Schneider
- Laurance Saess

# Clone detection

In pseudo code:

Where:
* x is the clone type
* y is the project location
* z is the min number of sub notes
* a is the minimum similarity

```
type = x

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
	similarity nodea nodeb = nodea.subItems `similar` nodeb.subItems
	/ (nodea.subcount + nodeb.subcount) * 100
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
* normalizeAST = false
* minimalSimularity = 100

Type 2:
* normalizeAST = true
* minimalSimularity = 100

Type 3:
* normalizeAST = true
* minimalSimularity = 50 <- or any other similarity factor you prefer.


* y is the project location
* z is the min number of sub notes
* a is the minimum similarity


set[Declaration] ast,
bool normalizeAST,
int minimalNodeGroupSize,
real minimalSimularity
