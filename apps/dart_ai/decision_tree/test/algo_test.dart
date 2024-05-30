import 'dart:math';

import 'package:decision_tree/decision_tree.dart';
import 'package:test/test.dart';

void main() {
  const double epsilon = 0.0001;
  test('Test gini impurity', () {
    expect(ImpurityFunc.giniImpurity.criterion([3, 2, 4]),
        closeTo(0.642, epsilon));
  });

  test('Test entropy', () {
    expect(
        ImpurityFunc.entropy.criterion([3, 2, 4]), closeTo(1.0608569, epsilon));
  });

  test('Test permutation', () {
    final random = Random(42);
    expect(
        [1, 2, 3, 4, 5, 6, 7]..shuffle(random), equals([4, 3, 6, 2, 5, 1, 7]));
    expect([]..shuffle(random), equals([]));
    expect([1]..shuffle(random), equals([1]));
    expect([1, 2]..shuffle(random), anyOf(equals([1, 2]), equals([2, 1])));
  });

  test('Test Node', () async {
    final data = [
      {'high': 1.6, 'temp': 37.4},
      {'high': 1.7, 'temp': 37.5},
      {'high': 1.75, 'temp': 36.5},
      {'high': 1.8, 'temp': 36.6},
    ];
    final target = ['m', 'm', 'f', 'f'];

    final tree = DecisionTree(randomState: 42);
    tree.fit(data, target);
    expect(
        tree.predict([
          {'high': 1.65, 'temp': 37.45},
          {'high': 1.9, 'temp': 36.55},
        ]),
        equals([
          'm',
          'f',
        ]));
    // json ファイルに保存する
    final model = tree.toModelJson();
    final jTree = DecisionTree.fromModelJson(model);
    expect(
        jTree.predict([
          {'high': 1.65, 'temp': 37.45},
          {'high': 1.9, 'temp': 36.55},
        ]),
        equals([
          'm',
          'f',
        ]));
  });
}
