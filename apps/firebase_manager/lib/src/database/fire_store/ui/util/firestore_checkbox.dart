import 'package:firebase_manager/firebase_manager.dart';
import 'package:flutter/material.dart';

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
            Log.debug(() => 'FirestoreCheckbox: value is not bool?');
            return Checkbox(value: false, onChanged: null);
          }
        } else {
          Log.debug(() => 'FirestoreCheckbox: stream data is null');
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
