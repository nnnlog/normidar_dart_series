import 'dart:math';

import 'package:decision_tree/decision_tree.dart';

class Node {
  ImpurityFunc criterion;

  final int maxDepth;

  final int? randomState;

  final int depth;

  Node? left;

  Node? right;

  String? feature;

  double? threshold;

  String? label;

  double? impurity;

  double infoGain = 0;

  Node({
    required this.criterion,
    required this.depth,
    this.maxDepth = 3,
    this.randomState,
  });

  double calculateInfoGain(
      List<String> target, List<String> targetLeft, List<String> targetRight) {
    final crip = criterionString(target);
    final cripLeft = criterionString(targetLeft);
    final cripRight = criterionString(targetRight);
    return crip -
        target.length / target.length * cripLeft -
        targetRight.length / target.length * cripRight;
  }

  double criterionString(List<String> target) {
    final classCount = target
        .toSet()
        .map((e) => target.where((element) => element == e).length)
        .toList();
    return criterion.criterion(classCount);
  }

  String predict(Map<String, num> sample) {
    final feature = this.feature;
    final left = this.left;
    final right = this.right;
    if (left == null || right == null) {
      return label!;
    } else {
      if (sample[feature]! <= threshold!) {
        return left.predict(sample);
      } else {
        return right.predict(sample);
      }
    }
  }

  void splitNode(List<Map<String, num>> samples, List<String> target,
      Set<String> iniNumClassess) {
    if (target.length == 1) {
      label = target[0];
      impurity = criterion.criterion([target.length]);
      return;
    }
    final classCount = {
      for (var e in iniNumClassess)
        e: target.where((element) => element == e).length
    };
    label = classCount.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    impurity = criterion.criterion(classCount.values.toList());

    final random = Random(randomState);
    final fLoopOrder = samples[0].keys.toList()..shuffle(random);
    for (final f in fLoopOrder) {
      final uniqFeature = samples.map((e) => e[f]!).toSet().toList();
      final splitPoints = List.generate(uniqFeature.length - 1,
          (index) => (uniqFeature[index] + uniqFeature[index + 1]) / 2.0);

      for (final t in splitPoints) {
        final targetLeft = <String>[];
        final targetRight = <String>[];
        for (var i = 0; i < samples.length; i++) {
          if (samples[i][f]! <= t) {
            targetLeft.add(target[i]);
          } else {
            targetRight.add(target[i]);
          }
        }
        final val = calculateInfoGain(target, targetLeft, targetRight);
        if (val > infoGain) {
          infoGain = val;
          feature = f;
          threshold = t;
        }
      }

      if (infoGain == 0) {
        return;
      }
      if (depth == maxDepth) {
        return;
      }

      final leftSamples =
          samples.where((element) => element[feature!]! <= threshold!).toList();
      final leftTarget = <String>[];
      for (var i = 0; i < samples.length; i++) {
        if (samples[i][feature!]! <= threshold!) {
          leftTarget.add(target[i]);
        }
      }
      final left = Node(
          criterion: criterion,
          maxDepth: maxDepth,
          depth: depth + 1,
          randomState: randomState);
      left.splitNode(leftSamples, leftTarget, iniNumClassess);
      this.left = left;

      final rightSamples =
          samples.where((element) => element[feature!]! > threshold!).toList();
      final rightTarget = <String>[];
      for (var i = 0; i < samples.length; i++) {
        if (samples[i][feature!]! > threshold!) {
          rightTarget.add(target[i]);
        }
      }
      final right = Node(
          criterion: criterion,
          maxDepth: maxDepth,
          depth: depth + 1,
          randomState: randomState);
      right.splitNode(rightSamples, rightTarget, iniNumClassess);
      this.right = right;
    }
  }

  Map<String, dynamic> toJson() {
    final rt = {
      'feature': feature,
      'depth': depth,
      'threshold': threshold,
      'left': left?.toJson(),
      'right': right?.toJson(),
      'label': label,
      'impurity': impurity,
      'infoGain': infoGain,
    };
    return rt;
  }

  /// output the json that only contains the model
  Map<String, dynamic> toModelJson() {
    final rt = <String, dynamic>{};
    final left = this.left;
    final right = this.right;
    if (left != null && right != null) {
      rt['feature'] = feature;
      rt['threshold'] = threshold;
      rt['left'] = left.toModelJson();
      rt['right'] = right.toModelJson();
    } else {
      rt['label'] = label;
    }
    return rt;
  }

  static Node fromModelJson(Map<String, dynamic> json) {
    final node = Node(
      criterion: ImpurityFunc.giniImpurity,
      depth: 0,
      maxDepth: 0,
      randomState: 0,
    );
    node.feature = json['feature'];
    node.threshold = json['threshold'];
    node.label = json['label'];
    if (json['left'] != null) {
      node.left = fromModelJson(json['left']);
    }
    if (json['right'] != null) {
      node.right = fromModelJson(json['right']);
    }
    return node;
  }
}
