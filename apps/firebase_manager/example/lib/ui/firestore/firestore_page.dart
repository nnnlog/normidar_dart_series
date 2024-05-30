import 'package:firebase_manager/firebase_manager.dart';
import 'package:flutter/material.dart';

import 'storedata_page.dart';

class FirestorePage extends StatefulWidget {
  const FirestorePage({super.key});

  @override
  State<StatefulWidget> createState() => _FirestorePageState();
}

class _FirestorePageState extends State<FirestorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => StoredataPage(
                        coll: fs.db.fireStore.getMainColl(),
                      )));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.send),
      ),
    );
  }
}
