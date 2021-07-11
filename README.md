# Reddit
A tutorial showing how to implement a small but non-trivial web application in Pharo using Seaside, Glorp (an ORM) and PostgreSQL.

The focus is not so much on the smaller size or the higher developer productivity in Pharo, but more on the fact that we can cover so much ground using such powerful frameworks, as well as the natural development flow from model over tests and persistence to web GUI.

The following article describes the code in this repository:
https://medium.com/@svenvc/reddit-st-in-10-cool-pharo-classes-1b5327ca0740

## Installation

The following expression loads all code and its dependencies (latest [Zinc HTTP Components](https://github.com/svenvc/zinc), [NeoConsole](https://github.com/svenvc/NeoConsole), [P3 with Glorp](https://github.com/svenvc/P3) and [Seaside 3](https://github.com/seasidest/seaside)) using the project's Baseline:

````Smalltalk
Metacello new
   baseline: 'Reddit';
   repository: 'github://svenvc/Reddit';
   load.
````

Deploy instruction can be found in a separate [document](DEPLOY.md).
