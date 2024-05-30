import 'package:firebase_manager/firebase_manager.dart';
import 'package:flutter/material.dart';

class RealDataPage extends StatefulWidget {
  final RealtimeBranch branch;

  const RealDataPage({required this.branch, super.key});

  @override
  State<StatefulWidget> createState() => _RealDataPageState();
}

class _RealDataPageState extends State<RealDataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: widget.branch.getListView(
        orderByChild: 'id',
        itemBuilder: (context, result) {
          return ListTile(
            title: Text(result.path),
            onTap: () {
              final child = widget.branch.getChild(result.name);
              child.read().then((value) {});
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => RealDataPage(
                          branch: widget.branch.getChild(result.name))));
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.send),
      ),
    );
  }
}
