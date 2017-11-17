# Software evolution report
- Simon Schneider
- Laurance Saess

## Cyclomatic complexity

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

### Score

We rank every method to a risk level

| Risk                        | parameters |
| --------------------------- |:---------: |
| Low risk        | 0 - 10      |
| Moderate risk   | 11 - 20      |
| High risk       | 21 - 50      |
| Very-high risk  | > 50      |

And then we calculate the total percentage per risk, what results in a score.

| Risk            | C Low risk  | C Moderate risk | C High risk | C Very-high risk |
| -------------   |:---------:  |:--------------: |:----------: | :---------:      |
| ++              | ∞           | max 25%         | Max 0%      | max 0 %          |              
| +               | ∞           | max 30%         | Max 5%      | max 0 %          |   
| o               | ∞           | max 40%         | Max 10%     | max 0 %          |   
| -               | ∞           | max 50%         | Max 25%     | max 5 %          |   
| --              | ∞           | ∞               | ∞           | ∞                |


## Code duplication

### Prune / preprocessing the code

To remove the amount of lines that the relativly costly code duplication algorithm has to check we are using pruning as a filter before the actual line-search algorithm.

Example:

```
a
b
c
d
e
ZZ
f
g
1
2
3
a
b
c
d
e
f
g
...
```

Now we can iterate over the lines and count the occurences:

```
"a" -> 3
"b" -> 2
"c" -> 2
"d" -> 2
"e" -> 2
"f" -> 2
"g" -> 1
"1" -> 1
"2" -> 1
"3" -> 1
"ZZ" -> 1
```

Can be replaced by

```
a
b
c
d
e
%UNIQUE_LINE%
f
%UNIQUE_LINE%
%UNIQUE_LINE%
%UNIQUE_LINE%
a
a
b
c
d
e
f
%UNIQUE_LINE%
...
```

This can be even further be reduced to:

```
%UNIQUE_LINES%
a
a
b
c
d
e
f
%UNIQUE_LINES%
...
```

Because we only care for 6 lines that are unique in a row. We then feed this reduced list of lines to an algorithm that knows how to handle the "%UNIQUE_LINES%" token that we introduced.

The first part of the algorithm has a complexity of O(2n) -> O(n), the actual search algorithm could be as bad as O(n^2), but with a reduced number of lines. This preprocessing will only be benefitial for cases in which the code does not consist out of non-unique lines.

# Unit interfacing

Unit interfacing is a metric for changeability and testability. How more more parameters there are for a method, how harder it is to test and change the functionality.

The metric is calculated like the cyclomatic complexity with the following risk devisions for the parameters:

| Risk                        | parameters |
| --------------------------- |:---------: |
| Interfacing Low risk        | 0 - 2      |
| Interfacing Moderate risk   | 2 - 3      |
| Interfacing High risk       | 3 - 4      |
| Interfacing Very-high risk  | 4 - ∞      |

As described in the following paper:

Alves, T. L., Correia, J. P., & Visser, J. (2011, November). Benchmark-based aggregation of metrics to ratings. In Software Measurement, 2011 Joint Conference of the 21st Int'l Workshop on and 6th Int'l Conference on Software Process and Product Measurement (IWSM-MENSURA) (pp. 20-29). IEEE.

The risk devision for the whole project is calculated and converted to a risk with the following table:

| Risk            | I Low risk  | I Moderate risk | I High risk | I Very-high risk |
| -------------   |:---------:  |:--------------: |:----------: | :---------:      |
| ++              | ∞           | max 25%         | Max 0%      | max 0 %          |              
| +               | ∞           | max 30%         | Max 5%      | max 0 %          |   
| o               | ∞           | max 40%         | Max 10%     | max 0 %          |   
| -               | ∞           | max 50%         | Max 25%     | max 5 %          |   
| --              | ∞           | ∞               | ∞           | ∞                |   

We use the same as they used for cyclometic complexity

## Why this metric

Unit interfacing is a metric for changeability and testability. How more more parameters there are for a method, how harder it is to test and change the functionality.

## Test

We compared some of our output to the smallsql source code:

```
"updateCharacterStream":3:
public void updateCharacterStream(int columnIndex, Reader x, int length) throws SQLException

"testNotInsertRow":0:
private void testNotInsertRow() throws SQLException

"calcMillis":7
static long calcMillis(int year, int month, final int day, final int hour, final int minute, final int second, final int millis)
```



# Unit size

The metric is calculated like the cyclomatic complexity with the following risk devisions for the parameters:

| Risk                        | parameters |
| --------------------------- |:---------: |
| U Low risk        | 0 - 30      |
| U Moderate risk   | 31 - 44      |
| U High risk       | 45 - 74      |
| U Very-high risk  | 75 - ∞      |

As described in the following paper:

Alves, T. L., Correia, J. P., & Visser, J. (2011, November). Benchmark-based aggregation of metrics to ratings. In Software Measurement, 2011 Joint Conference of the 21st Int'l Workshop on and 6th Int'l Conference on Software Process and Product Measurement (IWSM-MENSURA) (pp. 20-29). IEEE.

The risk devision for the whole project is calculated and converted to a risk with the following table:

| Risk            | U Low risk  | U Moderate risk | U High risk | U Very-high risk |
| -------------   |:---------:  |:--------------: |:----------: | :---------:      |
| ++              | ∞           | max 25%         | Max 0%      | max 0 %          |              
| +               | ∞           | max 30%         | Max 5%      | max 0 %          |   
| o               | ∞           | max 40%         | Max 10%     | max 0 %          |   
| -               | ∞           | max 50%         | Max 25%     | max 5 %          |   
| --              | ∞           | ∞               | ∞           | ∞                |   

# Testing

For testing we calculate how many assertions there are for each test method. We calculate it in the following way:

We divide assertions by methods and multiply it by 100. The output 50 means that there is one assertion for every 2 methods. The output 100 means that there are as many test methods as methods. The output 200 means that there are 2 test methods per method.   

| Risk           | Assertions per production method |
| -------------- |:--------------------: |
| ++ | 3-10 assertions per method  |
| +  | 2-3 assertions per method  |
| O  | 1-2 assertions per method  |
| -  | 0.5-1 assertions per method  |
| -- | 0-0.5 assertions per method  |

An alternative approach would be to calculate how many assertions there are per test method. We used assertions per because then you get an better idea on how many of all the functionality is tested. Normally you would do this by an converge test, but this is not possible in Rascal.   
