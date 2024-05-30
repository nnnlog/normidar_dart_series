import 'package:firebase_manager/firebase_manager.dart';
import 'package:flutter/material.dart';

class RealtimeMatcherPage extends StatefulWidget {
  const RealtimeMatcherPage({super.key});

  @override
  State<StatefulWidget> createState() => _RealtimeMatcherPageState();
}

class TestDataset extends FmMatcherDataset {
  Map<String, dynamic> map;
  TestDataset(this.map);

  String get a => map['a'];
  String get b => map['b'];
  String get c => map['c'];

  @override
  Map<String, dynamic> toMap() {
    return map;
  }
}

class _RealtimeMatcherPageState extends State<RealtimeMatcherPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: FmDataMatcher<TestDataset>(
          binder: FmRealtimeDefaultBinder(
              branch: fs.db.realtime.getRootBranch().getChild('abc'),
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
