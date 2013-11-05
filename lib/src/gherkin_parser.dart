part of dherkin;

RegExp tagsPattern = new RegExp(r"(@[^@\r\n\t ]+)");
RegExp featurePattern = new RegExp(r"Feature\s*:\s*(.+)");
RegExp scenarioPattern = new RegExp(r"Scenario\s*:\s*(.+)");
RegExp backgroundPattern = new RegExp(r"Background\s*:\s*$");
RegExp tablePattern = new RegExp(r"\|?\s*([^|]+?)\s*\|\s*");
RegExp stepPattern = new RegExp(r"(given|when|then|and|but)\s+(.+)", caseSensitive:false);

class GherkinParser {
  static final _log = LoggerFactory.getLoggerFor(GherkinParser);

  Feature<Feature> parse(File file) {

    Feature feature;
    Scenario currentScenario;
    Step currentStep;

    Completer comp = new Completer();
    file.readAsLines().then((List<String> contents) {
      var tags = [];

      var lineIter = contents.iterator;
      while (lineIter.moveNext()) {
        var line = lineIter.current;

        var iter = tagsPattern.allMatches(line).iterator;
        while (iter.moveNext()) {
          var match = iter.current;
          _log.debug(match.group(1));
          tags.add(match.group(1));
        }

        //  Feature
        iter = featurePattern.allMatches(line).iterator;
        while (iter.moveNext()) {
          var match = iter.current;
          _log.debug(match.group(1));
          feature = new Feature(match.group(1));
          feature.tags = tags;
          tags = [];
        }

        //  Scenario
        iter = scenarioPattern.allMatches(line).iterator;
        while (iter.moveNext()) {
          var match = iter.current;
          _log.debug(match.group(1));
          currentScenario = new Scenario(match.group(1));
          currentScenario.tags = tags;
          feature.scenarios.add(currentScenario);
          tags = [];
        }

        //  Background
        iter = backgroundPattern.allMatches(line).iterator;
        while (iter.moveNext()) {
          var match = iter.current;
          _log.debug("Background");
          currentScenario = new Scenario("Background");
          feature.background = currentScenario;
        }

        //  Steps
        iter = stepPattern.allMatches(line).iterator;
        while (iter.moveNext()) {
          var match = iter.current;
          currentStep = new Step(match.group(2));
          currentScenario.addStep(currentStep);
        }

        // Tables
        iter = tablePattern.allMatches(line).iterator;
        while (iter.moveNext()) {
          var match = iter.current;
          currentScenario.addStep(currentStep);
          print("TABLE: ${match[1]}");
        }


      }
    }).whenComplete(() => comp.complete(feature));

    return comp.future;
  }
}
