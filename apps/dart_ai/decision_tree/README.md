# pure dart decision tree

## Installation

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  decision_tree: ^... # use the latest version on pub
```

## Usage

fit(List<Map<String, num>> data, List<String> target)

```dart
import 'package:decision_tree/decision_tree.dart';

final data = [
    {'high': 1.6, 'temp': 37.4},
    {'high': 1.7, 'temp': 37.5},
    {'high': 1.75, 'temp': 36.5},
    {'high': 1.8, 'temp': 36.6},
];
final target = ['m', 'm', 'f', 'f'];

final tree = DecisionTree(randomState: 42);
tree.fit(data, target);
print(tree.predict([
        {'high': 1.65, 'temp': 37.45},
        {'high': 1.9, 'temp': 36.55},
    ])); // ['m', 'f']
```

---

## Features and bugs

Welcome to contribute to this project.