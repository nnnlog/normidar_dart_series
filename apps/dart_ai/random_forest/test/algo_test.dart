import 'package:random_forest/random_forest.dart';
import 'package:test/test.dart';

import 'iris_test_data.dart';

void main() {
  test('Test random forest', () async {
    final forest = RandomForest(randomState: 42);
    forest.fit(irisTestData, irisTestTarget);
    expect(forest.score(irisTestData, irisTestTarget), greaterThan(0.9));
  });

  test('Test random forest predict one', () async {
    final forest = RandomForest(randomState: 42);
    forest.fit(irisTestData, irisTestTarget);
    expect(
        forest
            .predictOneDetail(irisTestData[0])
            .entries
            .reduce((value, element) =>
                value.value > element.value ? value : element)
            .key,
        equals(irisTestTarget[0]));
  });

  test('Test random forest json', () async {
    final forest = RandomForest(randomState: 42);
    forest.fit(irisTestData, irisTestTarget);
    final score = forest.score(irisTestData, irisTestTarget);

    final json = forest.toModelJson();
    final newForest = RandomForest.fromModelJson(json);
    expect(newForest.score(irisTestData, irisTestTarget), equals(score));
  });
}
