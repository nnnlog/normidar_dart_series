import 'package:firebase_manager/firebase_manager.dart';
import 'package:flutter/material.dart';

class FirestoreMatcherPage extends StatefulWidget {
  const FirestoreMatcherPage({super.key});

  @override
  State<StatefulWidget> createState() => _FirestoreMatcherPageState();
}

class _FirestoreMatcherPageState extends State<FirestoreMatcherPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: FmDataMatcher<TestDataset>(
          binder: FmFirestoreDefaultBinder(
              doc: fs.db.fireStore.getMainColl().getDoc('abc'),
              constructor: TestDataset.new),
          builder: (context, dataset) {
            return Column(
              children: [
                Text(dataset.a),
                Text(dataset.b),
                Text(dataset.c),
              ],
            );
          },
        ));
  }
}

class TestDataset extends FmMatcherDataset {
  TestDataset(this.map);
  Map<String, dynamic> map;

  String get a => map['a'];
  String get b => map['b'];
  String get c => map['c'];

  @override
  Map<String, dynamic> toMap() {
    return map;
  }
}
