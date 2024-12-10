import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta_clone2/data/firebase_services/firebase_auth.dart';
import 'package:insta_clone2/utils/dialog.dart';
import 'dart:io' as io;
import 'package:insta_clone2/utils/exceptions.dart';
import 'package:insta_clone2/utils/imagepicker.dart';

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
            InkWell(
              onTap: () async {
                io.File _imagefilee =
                    await ImagePickerr().uploadImage('gallary');
                setState(() {
                  _imageFile = _imagefilee;
                });
              },
              child: Center(
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
            Textfield(email, Icons.email, 'Email', email_F),
            SizedBox(height: 25.h),
            Textfield(password, Icons.lock, 'Password', password_F),
            SizedBox(height: 25.h),
            Textfield(username, Icons.person, 'Username', username_F),
            SizedBox(height: 25.h),
            Textfield(bio, Icons.abc, 'Bio', bio_F),
            SizedBox(height: 25.h),
            Textfield(passwordConfirme, Icons.lock, 'PasswordConfirme',
                passwordConfirme_F),
            SizedBox(
              height: 20.h,
            ),
            Signup(() async {
              try {
                await Authentication().Signup(
                    email: email.text,
                    password: password.text,
                    passwordConfirme: passwordConfirme.text,
                    username: username.text,
                    bio: bio.text,
                    profile: _imageFile ?? io.File(''));
              } on exceptions catch (e) {
                dialogBuilder(context, e.message);
              }
            }),
            SizedBox(
              height: 10.h,
            ),
            Have()
          ],
        ),
      )),
    );
  }

  Widget Have() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Already have an account?",
            style: TextStyle(fontSize: 13.sp, color: Colors.grey),
          ),
          GestureDetector(
            onTap: widget.show,
            child: Text(
              " Log in ",
              style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget Signup(VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: InkWell(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 44.h,
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(10.r)),
          child: Text(
            'Sign up',
            style: TextStyle(
                fontSize: 23.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget Textfield(TextEditingController controller, IconData icon, String type,
      FocusNode focusNode) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: TextField(
          style: TextStyle(fontSize: 18.sp, color: Colors.black),
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: type,
            prefixIcon: Icon(
              icon,
              color: focusNode.hasFocus ? Colors.black : Colors.grey,
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.r),
              borderSide: BorderSide(color: Colors.grey, width: 2.w),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.r),
              borderSide: BorderSide(color: Colors.black, width: 2.w),
            ),
          ),
        ),
      ),
    );
  }
}
