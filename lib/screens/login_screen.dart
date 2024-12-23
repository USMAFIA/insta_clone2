import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta_clone2/data/firebase_services/firebase_auth.dart';
import 'package:insta_clone2/utils/widgets/widgets.dart';

import '../utils/dialog.dart';
import '../utils/exceptions.dart';
import '../utils/widgets/navigation.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback show;
  const LoginScreen(this.show, {super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  FocusNode email_F = FocusNode();
  final password = TextEditingController();
  FocusNode password_F = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: 96.w,
              height: 100.h,
            ),
            Center(
              child: Image.asset('images/logo.jpg'),
            ),
            SizedBox(
              height: 120.h,
            ),
            Widgets().Textfield(email, Icons.email, 'Email', email_F),
            SizedBox(height: 25.h),
            Widgets().Textfield(password, Icons.lock, 'Password', password_F),
            SizedBox(height: 10.h),
            Widgets().Forgot(),
            SizedBox(
              height: 10.h,
            ),
            Widgets().IsSignup(() async {
              try {
                await Authentication().Login(email: email.text, password: password.text);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Navigations()));
              } on exceptions catch (e) {
                print('error======>${e.message}');
                dialogBuilder(context, e.message);
              }
            }, false),
            SizedBox(
              height: 10.h,
            ),
            Widgets().Have(widget.show, false),
          ],
        ),
      )),
    );
  }
}
