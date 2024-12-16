import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta_clone2/data/firebase_services/firebase_auth.dart';
import 'package:insta_clone2/screens/home.dart';
import 'package:insta_clone2/utils/dialog.dart';
import 'dart:io' as io;
import 'package:insta_clone2/utils/exceptions.dart';
import 'package:insta_clone2/utils/imagepicker.dart';

import '../utils/widgets/widgets.dart';

class SignupScreen extends StatefulWidget {
  final VoidCallback show;
  const SignupScreen(this.show, {super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final email = TextEditingController();
  FocusNode email_F = FocusNode();
  final password = TextEditingController();
  FocusNode password_F = FocusNode();
  final bio = TextEditingController();
  FocusNode bio_F = FocusNode();
  final username = TextEditingController();
  FocusNode username_F = FocusNode();
  final passwordConfirme = TextEditingController();
  FocusNode passwordConfirme_F = FocusNode();
  io.File? _imageFile;
  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
    bio.dispose();
    username.dispose();
    passwordConfirme.dispose();
  }

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
              height: 30.h,
            ),
            Center(
              child: Image.asset('images/logo.jpg'),
            ),
            SizedBox(
              height: 60.h,
            ),
            Center(
              child: InkWell(
                onTap: () async {
                  io.File _imagefilee =
                      await ImagePickerr().uploadImage('camera');
                  setState(() {
                    _imageFile = _imagefilee;
                  });
                },
                child: CircleAvatar(
                  radius: 36.r,
                  backgroundColor: Colors.green,
                  child: _imageFile == null
                      ? CircleAvatar(
                          radius: 34.r,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage:
                              const AssetImage('images/person.png'),
                        )
                      : CircleAvatar(
                          radius: 34.r,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                          ).image,
                        ),
                ),
              ),
            ),
            SizedBox(
              height: 50.h,
            ),
            Widgets().Textfield(email, Icons.email, 'Email', email_F),
            SizedBox(height: 25.h),
            Widgets().Textfield(password, Icons.lock, 'Password', password_F),
            SizedBox(height: 25.h),
            Widgets().Textfield(username, Icons.person, 'Username', username_F),
            SizedBox(height: 25.h),
            Widgets().Textfield(bio, Icons.abc, 'Bio', bio_F),
            SizedBox(height: 25.h),
            Widgets().Textfield(passwordConfirme, Icons.lock,
                'PasswordConfirme', passwordConfirme_F),
            SizedBox(
              height: 20.h,
            ),
            Widgets().IsSignup(() async {
              try {
                await Authentication().Signup(
                    email: email.text,
                    password: password.text,
                    passwordConfirme: passwordConfirme.text,
                    username: username.text,
                    bio: bio.text,
                    profile: _imageFile!);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Home()));
              } on exceptions catch (e) {
                print('error======>${e.message}');
                dialogBuilder(context, e.message);
              }
            }, true),
            SizedBox(
              height: 10.h,
            ),
            Widgets().Have(widget.show, true),
          ],
        ),
      )),
    );
  }
}
