import 'package:app_exm/ui/storage/container_page.dart';
import 'package:firebase_manager/firebase_manager.dart';
import 'package:flutter/material.dart';

class StoragePage extends StatefulWidget {
  const StoragePage({super.key});

  @override
  State<StatefulWidget> createState() => _StoragePageState();
}

class _StoragePageState extends State<StoragePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Column(
        children: [],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final folder = fs.db.storage.rootFolderRef();
          final folders = await folder.listFolders();
          final files = await folder.listFiles();
          if (mounted) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ContainerPage(
                folders: folders,
                folder: folder,
                files: files,
              );
            }));
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.send),
      ),
    );
  }
}
