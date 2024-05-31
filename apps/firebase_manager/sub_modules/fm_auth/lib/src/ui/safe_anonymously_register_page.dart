import 'package:firebase_auth/firebase_auth.dart';
import '../user/fire_user.dart';
import 'package:flutter/material.dart';

/// auto register anonymous user
class SafeAnonymouslyRegisterPage extends StatefulWidget {
  final Widget Function(FireUser) callback;
  final Widget loadingWidget;
  const SafeAnonymouslyRegisterPage(
      {required this.callback,
      this.loadingWidget = const CircularProgressIndicator(),
      super.key});

  @override
  State<SafeAnonymouslyRegisterPage> createState() =>
      _SafeAnonymouslyRegisterPageState();
}

class _SafeAnonymouslyRegisterPageState
    extends State<SafeAnonymouslyRegisterPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null && mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: ((_) => widget.callback(FireUser(user)))),
          (route) => false,
        );
      }
    });
    super.initState();
  }
}
