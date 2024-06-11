import 'package:flutter/material.dart';
import 'package:fm_firestore/doc/fire_doc.dart';

class FirestoreCheckbox extends StatelessWidget {
  final FireDoc doc;
  final String dataKey;
  final bool disableIfDataNull;
  const FirestoreCheckbox({
    required this.doc,
    required this.dataKey,
    this.disableIfDataNull = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: doc.readStream(),
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (data != null) {
          final value = data[dataKey];
          if (value is bool?) {
            return Checkbox(
              value: value ?? false,
              onChanged: (v) => doc.update(
                {dataKey: v},
              ),
            );
          } else {
            return const Checkbox(value: false, onChanged: null);
          }
        } else {
          return Checkbox(
            value: false,
            onChanged: (v) => doc.update(
              {dataKey: v},
            ),
          );
        }
      },
    );
  }
}
