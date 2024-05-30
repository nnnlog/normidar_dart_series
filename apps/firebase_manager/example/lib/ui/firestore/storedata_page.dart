import 'package:firebase_manager/firebase_manager.dart';
import 'package:flutter/material.dart';

class StoredataPage extends StatefulWidget {
  const StoredataPage({required this.coll, super.key});

  final FireColl coll;

  @override
  State<StatefulWidget> createState() => _StoredataPageState();
}

class _StoredataPageState extends State<StoredataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: widget.coll.getListView(
        orderBy: ('id', false),
        itemBuilder: (context, result) {
          return ListTile(
            title: Text(result.runtimeType.toString()),
            onTap: () {},
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
