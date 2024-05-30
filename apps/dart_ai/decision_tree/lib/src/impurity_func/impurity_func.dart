import 'dart:math';

typedef ImpFunc = double Function(Iterable<int> classes);

class Entropy extends ImpurityFunc {
  static const funcName = 'entropy';

  const Entropy();

  @override
  String get name => funcName;

  @override
  double criterion(Iterable<int> classes) {
    final total = classes.fold(0, (a, b) => a + b);
    final sum = classes.fold(0.0, (a, b) => a + (b / total) * log(b / total));
    return -sum;
  }
}

/// gini impurity is an evaluation metric used to evaluate the quality of a split in a dataset.
/// It is calculated as the probability of a random sample being misclassified.
class GiniImpurity extends ImpurityFunc {
  static const funcName = 'gini';

  const GiniImpurity();

  @override
  String get name => funcName;

  @override
  double criterion(Iterable<int> classes) {
    final total = classes.fold(0, (a, b) => a + b);
    final sum = classes.fold(0.0, (a, b) => a + pow(b / total, 2));
    return 1 - sum;
  }
}

sealed class ImpurityFunc {
  static const entropy = Entropy();
  static const giniImpurity = GiniImpurity();
  const ImpurityFunc();

  String get name;

  double criterion(Iterable<int> classes);

  static ImpurityFunc? fromString(String name) {
    switch (name) {
      case Entropy.funcName:
        return entropy;
      case GiniImpurity.funcName:
        return giniImpurity;
      default:
        return null;
    }
  }

  static ImpurityFunc original(ImpFunc criterion, String name) =>
      OriginalImpurityFunc(criterion, name);
}

class OriginalImpurityFunc extends ImpurityFunc {
  final String funcName;

  final ImpFunc _criterion;

  const OriginalImpurityFunc(ImpFunc criterion, this.funcName)
      : _criterion = criterion;

  @override
  String get name => funcName;

  @override
  double criterion(Iterable<int> classes) => _criterion(classes);
}
