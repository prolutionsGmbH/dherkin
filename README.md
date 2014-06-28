dherkin
=======

Gherkin parser and runner for dart.
for Behavior Driven Development (BDD).


Usage
=====

Dherkin can be executed in a number of ways.

cucumberd
---------
Library comes with an executable runner script **cucumberd** in bin/ directory.
Create symbolic link in a directory on your path, like /usr/local/bin:
```
cd /usr/local/bin
ln -s path/to/dherkin/bin/cucumberd .
```

Execute:
```
cucumberd examples/test_feature.feature
```

Note: **cucumberd** will auto-include all step definitions in *steps/* sub-directory.
Ability to add steps source locations via command-line arguments is planned.

Custom Runner
-------------
Alternatively, you might opt for writing your own script:

   ```dart
   library my_bdd_runner;

   import 'package:dherkin/dherkin.dart';
   import 'my_step_defs.dart'; // import stepdefs, mandatory since no auto-scanning happens

   main(args) {
     run(args);
   }

   // write your StepDefs below
   ```
Invoke the runner : `$ dart my_bdd_runner.dart my_gherkin.feature`

Anatomy of a stepdef
--------------------
A stepdef is a top-level function annotated with one of Gherkin keywords.
Such a function can take any number of positional parameters, and up to three optional named parameters.

```dart
@And("I am a table step \"(\\w+?)\"")
i_am_a_table(arg1, {exampleRow, table, out}) {
   out.writeln("Executing...${exampleRow['column2']}");
}

```
Table found on the step will be passed in as **table**.
A scenario outline row will be passed in as **exampleRow**

Output
------
Due to asynchronous nature of execution, output of *print* statements will not appear near the gherkin step that ran them.
For that purpose, optional named parameter **out** will be injected if the stepdef function states that it takes it

Parallelism 
------------
Features and scenarios are executed in multiple workers, so there is a degree of unpredictability of the order of execution.
