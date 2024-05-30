import 'package:app_exm/firebase_options.dart';
import 'package:firebase_manager/firebase_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'ui/firestore/firestore_matcher_page.dart';

void main() {
  FirebaseManager.share.initApp(
    FirebaseInitOptions(
      requiresLogin: true,
      firebaseOptions: DefaultFirebaseOptions.currentPlatform,
      home: () => const FirestoreMatcherPage(),
    ),
  );
}

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const FirestoreMatcherPage(),
      routes: [
        /// test router by
        /// adb shell 'am start -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d "https://normidar.com/details"' com.normidar.firebase_manager_example
        GoRoute(
          path: 'details',
          builder: (_, state) => Scaffold(
            appBar: AppBar(title: const Text('Details Screen')),
            body: Center(
              child: Text(state.params.toString()),
            ),
          ),
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ABC'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final mainColl = fs.db.fireStore.getMainColl();
          final doc = mainColl.getDoc('abc');
          await doc.checkFieldExists('fsdf');
        },
      ),
    );
  }
}
