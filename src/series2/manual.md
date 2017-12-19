# Duplication visualizer manual

## 1. Using the report tool

First you have to import the main file of the series2 assignment 

```java
import series2::Main;
```

Then you can run one of these functions: 

```java
/*
	Will exexute the meterics on a test project 
*/
public void testExampleJavaProject() {
	writeAnalyses("test-project", |project://use-test-project|);
}

/*
	Will exexute the meterics on smallsql
*/
public void testSmallsqlJavaProject() {
	writeAnalyses("smallsql", |project://smallsql|);
}


/*
	Will exexute the meterics on hsqldb
*/
public void testHsqlJavaProject() {
	writeAnalyses("hsqldb", |project://hsqldb|);
}
```

## 2. Running tests

Some of the tests are based on the M3 model which requires a valid Java project. 

To run these tests you need a project called `use-test-project` in your eclipse workspace.

This project can be found here: [https://github.com/lauwdude/use-test-project](https://github.com/lauwdude/use-test-project)

After importing the files from `series2/Tests` you should be able to run `:test` successfully.



## 3. Visualization

The resulting JSON files can be pasted into: http://software-evolution.schneider.click/

If you want to build the visualization tool, which is based on React, D3.js and vis.js, from source you can clone this repository: 

https://github.com/schneider-simon/duplication-visualization

Prerequisites to build the visualization tool are:

1. Node
2. NPM
3. Yarn

```bash
# install dependencies
yarn

# run development server
yarn start
```

Now you can access the tool at `localhost:3000`

