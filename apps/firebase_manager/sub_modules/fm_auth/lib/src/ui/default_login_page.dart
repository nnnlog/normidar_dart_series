import 'package:auto_exporter_annotation/auto_exporter_annotation.dart';
import 'package:flutter/material.dart';
import 'package:fm_auth/src/login/login_tool.dart';
import 'package:sign_in_button/sign_in_button.dart';


@AutoExport()
/// TODO: implement login features
class DefaultLoginPage extends StatelessWidget {
  final bool allowAnonymousLogin;
  final bool allowGoogleLogin;
  final bool allowAppleLogin;
  final bool allowEmailLogin;

  final Widget Function()? onLoginSuccessJumpTo;

  const DefaultLoginPage({
    this.onLoginSuccessJumpTo,
    this.allowAnonymousLogin = false,
    this.allowGoogleLogin = true,
    this.allowAppleLogin = false,
    this.allowEmailLogin = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (allowAnonymousLogin)
              SignInButtonBuilder(
                icon: Icons.person,
                text: 'Sign in Anonymously',
                onPressed: () {},
                backgroundColor: Colors.blueGrey.shade700,
              ),
            if (allowGoogleLogin)
              SignInButton(
                Buttons.google,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                onPressed: () async {
                  // TODO: dont use  LoginTool()
                  final result = await LoginTool().loginByGoogle();

                  final onLoginSuccessJumpTo = this.onLoginSuccessJumpTo;
                  if (onLoginSuccessJumpTo != null) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => onLoginSuccessJumpTo(),
                      ),
                    );
                  } else if (result != null) {
                    Navigator.of(context).pop();
                  } else {
                    print("unlogined");
                  }
                },
              ),
            if (allowAppleLogin) SignInButton(Buttons.apple, onPressed: () {}),
            if (allowEmailLogin)
              SignInButtonBuilder(
                icon: Icons.email,
                text: 'Sign in with Email',
                onPressed: () {},
                backgroundColor: Colors.blueGrey.shade700,
              ),
          ],
        ),
      ),
    );
  }
}
