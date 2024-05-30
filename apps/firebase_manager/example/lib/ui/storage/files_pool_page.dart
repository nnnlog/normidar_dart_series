import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_manager/firebase_manager.dart';
import 'package:flutter/material.dart';

class FilesPoolPage extends StatefulWidget {
  const FilesPoolPage({super.key});

  @override
  State<FilesPoolPage> createState() => _FilesPoolPageState();
}

class _FilesPoolPageState extends State<FilesPoolPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: TextButton(
          child: const Text('Pick'),
          onPressed: () async {
            // pick files
            final result = await FilePicker.platform.pickFiles();
            if (result != null) {
              for (var element in result.files) {
                await fs.db.storage
                    .uploadPoolFile(File(element.path!));
              }
            }

            // pick image
            // final ImagePicker picker = ImagePicker();
            // final XFile? image = await picker.pickImage(
            //   source: ImageSource.gallery,
            // );
            // if (image != null) {
            //   await FirebaseManager.share.storage
            //       .uploadPoolFile(File(image.path));
            // }
          },
        ),
      ),
    );
  }
}
