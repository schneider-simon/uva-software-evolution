# Cyclomatic complexity

With this metric, it is possible to give and indication of the complexity of a program. It measures the number of paths through the source code of a code section. In theory, how lower the cyclomatic complexity, how easier the code should be to understand. However, in practice this is not always the case.

The following method gets an lower complexity:

```java
public int complexity1(bool a) {
  int asd = 234;
  asd =* 2342;
  .....
  int asv = asd * 24234 + (a > 234 ? 234 : 3) + 234 / asd;
  asd += asv - 234;
  return asd + 123;
}
```
Then the following method:

```java
public int complexity1(bool a) {
  switch(a) {
    case 1:
      return 123523;
    case 2:
      return 12353;
  }
  return 23423344;
}
```

However, the last method is easier to understand. The complexity can be used as an indication. But it should not be used as only measure.

## How do we calculate the complexity

We calculate the complexity over all units (methods, constructors and static constructors) in the project. We iterate over every statements in the unit and increment the complexity for every do, foreach, for, if, case, catch, while, conditional and || / && infix operator. This, because these elements will result into a new branch, =

## How do you count a statement that always branches to one branch

There is the case that, for example an if statement, only will result into a single branch. For example:

```java
bool b = true;
if(b) {
  ...
}
```

This method will only result in one branch, but for the reader it adds complexity and there are many cases when you cannot know that it only will result in one branch.

## What do we call a unit in Java

Cyclomatic complexity is about the complexity of the smallest possible unit. In Java it is and method, constructor and static constructors.

# Do you calculate lambdas

For example, when you define a lambda inside a method, does it add up to the complexity? In our application we add the complexity to the unit. It is part of the unit, and it adds complexity of the reader. So, we count it as complexity.

Other tools, like Checkstyle do not calculate these kind of things to the complexity.  

## Test
As a test, we compared the result of the complexity function with Checkstyle. We generated lists of the complexity per method and compared them:

### Checkstyle output

```text
/src/smallsql/database/Command.java:106:9: Cyclomatic Complexity is 3  
/src/smallsql/database/Command.java:116:5: Cyclomatic Complexity is 2  
/src/smallsql/database/Command.java:127:9: Cyclomatic Complexity is 2  
/src/smallsql/database/Command.java:134:5: Cyclomatic Complexity is 3  
/src/smallsql/database/Command.java:148:5: Cyclomatic Complexity is 2  
/src/smallsql/database/Command.java:86:5: Cyclomatic Complexity is 3  
/src/smallsql/database/Command.java:96:5: Cyclomatic Complexity is 2  
```

### Rascal output
```text
/src/smallsql/database/Command.java|(2404,307,\<83,4\>,\<91,5\>): Cyclomatic Complexity is 3"
/src/smallsql/database/Command.java|(2719,207,\<93,4\>,\<100,5\>): Cyclomatic Complexity is 2"
/src/smallsql/database/Command.java|(2931,360,\<102,1\>,\<110,2\>): Cyclomatic Complexity is 3"
/src/smallsql/database/Command.java|(3300,313,\<112,4\>,\<121,5\>): Cyclomatic Complexity is 2"
/src/smallsql/database/Command.java|(3618,337,\<123,1\>,\<132,2\>): Cyclomatic Complexity is 2"
/src/smallsql/database/Command.java|(3963,383,\<134,4\>,\<144,5\>): Cyclomatic Complexity is 3"
/src/smallsql/database/Command.java|(4439,170,\<148,4\>,\<152,5\>): Cyclomatic Complexity is 2"
```

We compared every mismatch and reasoned if their approach is better than ours. One difference that we found was that Checkstyle does not count lambda's. In our opunion, they should be counted to the unit it is inside.
