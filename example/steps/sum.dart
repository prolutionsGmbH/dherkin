


import 'package:dherkin3/dherkin.dart';

import '../lib/scenario_session.dart';

class Sum {
  final ScenarioSession _scenarioSession;

  Sum(this._scenarioSession);

  @Given("I add {int}")
  void addAmount(int amt) {
    _scenarioSession.sharedStepData["add"] = ((_scenarioSession.sharedStepData["add"] ?? 0) as int) + amt;
  }

  @Given("the total should be {int}")
  void totalShouldBe(int amt) {
    var calcedVal = (_scenarioSession.sharedStepData["add"] as int);
    if (amt != calcedVal) {
      throw new Exception("amt not equal ${amt} != ${calcedVal}");
    }
  }
}