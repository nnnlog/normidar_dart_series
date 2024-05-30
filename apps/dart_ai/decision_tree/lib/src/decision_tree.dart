import 'package:decision_tree/decision_tree.dart';

class DecisionTree {
  Node? tree;

  final ImpurityFunc criterion;

  final int maxDepth;

  final int? randomState;

  DecisionTree({
    this.tree,
    this.criterion = ImpurityFunc.giniImpurity,
    this.maxDepth = 3,
    this.randomState,
  });

  factory DecisionTree.fromModelJson(Map<String, dynamic> json) {
    return DecisionTree(
      tree: Node.fromModelJson(json['tree']),
    );
  }

  void fit(List<Map<String, num>> samples, List<String> target) {
    final tree = Node(
      criterion: criterion,
      maxDepth: maxDepth,
      randomState: randomState,
      depth: 0,
    );
    tree.splitNode(samples, target, target.toSet());
    this.tree = tree;
  }

  List<String> predict(List<Map<String, num>> samples) {
    return samples.map((sample) => tree!.predict(sample)).toList();
  }

  String predictOne(Map<String, num> sample) {
    return tree!.predict(sample);
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

  Map<String, dynamic> toJson() {
    return {
      'tree': tree?.toJson(),
      'maxDepth': maxDepth,
      'randomState': randomState,
      'criterion': criterion.name,
    };
  }

  Map<String, dynamic> toModelJson() {
    return {
      'tree': tree?.toModelJson(),
    };
  }
}
