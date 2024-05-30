import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_manager/firebase_manager.dart';
import 'package:flutter/material.dart';

class ContainerPage extends StatefulWidget {
  const ContainerPage({
    super.key,
    required this.folders,
    required this.files,
    required this.folder,
  });

  final List<FireFolderRef> folders;
  final List<FireFileRef> files;
  final FireFolderRef folder;

  @override
  State<StatefulWidget> createState() => _ContainerPageState();
}

class _ContainerPageState extends State<ContainerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Wrap(
        children: [
          ...widget.folders
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    color: Colors.blue,
                    child: InkWell(
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(e.getName())),
                      onTap: () async {
                        final folders = await e.listFolders();
                        final files = await e.listFiles();
                        if (mounted) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ContainerPage(
                              folders: folders,
                              folder: e,
                              files: files,
                            );
                          }));
                        }
                      },
                    ),
                  ),
                ),
              )
              .toList(),
          ...widget.files
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    color: Colors.red,
                    child: InkWell(
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(e.getName())),
                      onTap: () async {
                        String? selectedDirectory =
                            await FilePicker.platform.getDirectoryPath();

                        if (selectedDirectory != null) {
                          e.download(File("$selectedDirectory/${e.getName()}"));
                        }
                      },
                    ),
                  ),
                ),
              )
              .toList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles();

          if (result != null) {
            final path = result.files.single.path;
            if (path != null) {
              File file = File(path);
              await widget.folder.upload(file);
              if (mounted) {
                Navigator.pop(context);
              }
            }
          } else {
            // User canceled the picker
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
