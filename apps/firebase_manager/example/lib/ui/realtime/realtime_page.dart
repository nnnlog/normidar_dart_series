import 'package:app_exm/ui/realtime/real_data_page.dart';
import 'package:firebase_manager/firebase_manager.dart';
import 'package:flutter/material.dart';

class RealtimePage extends StatefulWidget {
  const RealtimePage({super.key});

  @override
  State<StatefulWidget> createState() => _RealtimePageState();
}

class _RealtimePageState extends State<RealtimePage> {
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
                  builder: (_) => RealDataPage(
                      branch: fs.db.realtime.getRootBranch().getChild('tt'))));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.send),
      ),
    );
  }
}
