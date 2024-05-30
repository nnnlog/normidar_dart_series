import 'dart:math';

import 'package:decision_tree/decision_tree.dart';

class RandomForest {
  final int numEstimators;

  final int? randomState;

  List<DecisionTree>? trees;

  RandomForest({
    this.numEstimators = 100,
    this.randomState,
    this.trees,
  });

  void fit(List<Map<String, num>> samples, List<String> target) {
    final random = Random(randomState);

    final trees = <DecisionTree>[];
    for (int i = 0; i < numEstimators; i++) {
      final DecisionTree tree = DecisionTree(randomState: randomState);
      trees.add(tree);
      final (rsSamples, rsTarget) = reselectSamples(
        samples: samples,
        target: target,
        random: random,
      );
      tree.fit(rsSamples, rsTarget);
    }
    this.trees = trees;
  }

  List<String> predict(List<Map<String, num>> samples) {
    final pred = <List<String>>[];
    for (final e in trees!) {
      pred.add(e.predict(samples));
    }

    final label = samples
        .map((e) => _predict(e))
        .map((e) => e.entries.reduce((a, b) => a.value > b.value ? a : b).key)
        .toList();

    return label;
  }

  Map<String, double> predictOneDetail(Map<String, num> sample) {
    final label = _predict(sample);
    final total = label.values.reduce((a, b) => a + b);
    return label.map((key, value) => MapEntry(key, value / total));
  }

  /// shuffle the samples and target and take sqrt-ceil of it
  (List<Map<String, num>>, List<String>) reselectSamples({
    required List<Map<String, num>> samples,
    required List<String> target,
    required Random random,
  }) {
    final numSamples = samples.length;
    final numFeatures = samples.first.keys.length;

    final rsSampleIndex =
        List.generate(numSamples, (_) => random.nextInt(numSamples));
    final rsNumFeatures = sqrt(numFeatures).ceil();
    final removeFeatures = samples.first.keys.toList()
      ..shuffle(random)
      ..removeRange(0, numFeatures - rsNumFeatures);

    final rsSample = <Map<String, num>>[];
    for (int e in rsSampleIndex) {
      final toAdd =
          samples.elementAt(e).map((key, value) => MapEntry(key, value));
      toAdd.removeWhere((key, value) => removeFeatures.contains(key));
      rsSample.add(toAdd);
    }

    final rsTargets = <String>[];
    for (int e in rsSampleIndex) {
      rsTargets.add(target[e]);
    }

    return (rsSample, rsTargets);
  }

  double score(List<Map<String, num>> samples, List<String> target) {
    final predictions = predict(samples);
    final correct = predictions
        .asMap()
        .entries
        .where((entry) => target[entry.key] == entry.value)
        .length;
    return correct / target.length;
  }

  Map<String, dynamic> toModelJson() {
    return {
      'numEstimators': numEstimators,
      'randomState': randomState,
      'trees': trees!.map((e) => e.toModelJson()).toList(),
    };
  }

  Map<String, int> _predict(Map<String, num> sample) {
    final pred = trees!.map((e) => e.predictOne(sample));
    final label = <String, int>{};
    for (final e in pred) {
      label.update(e, (value) => value + 1, ifAbsent: () => 1);
    }
    return label;
  }

  static RandomForest fromModelJson(Map<String, dynamic> json) {
    return RandomForest(
      numEstimators: json['numEstimators'],
      randomState: json['randomState'],
      trees: (json['trees'] as List)
          .map((e) => DecisionTree.fromModelJson(e))
          .toList(),
    );
  }
}
