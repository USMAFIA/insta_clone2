import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta_clone2/data/firebase_services/firestore.dart';
import 'package:insta_clone2/utils/exceptions.dart';

class Authentication {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> Signup({
    required String email,
    required String password,
    required String passwordConfirme,
    required String username,
    required String bio,
    required File profile,
  }) async {
    String? URL;
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          bio.isNotEmpty &&
          username.isNotEmpty) {
        if (password == passwordConfirme) {
          await _auth.createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );
          if (profile != File('')) {
            URL = profile.toString();
          } else {
            URL = '';
          }
          await Firebase_Firestore().CreateUser(
              email: email,
              bio: bio,
              username: username,
              profile: URL == ''
                  ? 'https://miro.medium.com/v2/resize:fit:563/1*DdnXquBUvghgIhH0L56t-A.jpeg'
                  : URL);
        } else {
          throw exceptions('password and confirm password should be same');
        }
      } else {
        throw exceptions('enter all the fields');
      }
    } on FirebaseException catch (e) {
      throw exceptions(e.message.toString());
    }
  }
}
