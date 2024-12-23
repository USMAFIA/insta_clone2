import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:insta_clone2/data/firebase_services/firestore.dart';
import 'package:insta_clone2/utils/exceptions.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> Login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
    } on FirebaseAuthException catch (e) {
      throw exceptions(e.message ??
          'An unknown error occurred with Firebase in logging in the user.');
    } on exceptions catch (e) {
      rethrow;
    } catch (e) {
      throw exceptions('An unexpected error occurred in logging in: $e');
    }
  }

  Future<void> Signup({
    required String email,
    required String password,
    required String passwordConfirme,
    required String username,
    required String bio,
    required File? profile, // Made profile nullable
  }) async {
    String? profileUrl;

    try {
      // Validate input fields
      if (email.isEmpty ||
          password.isEmpty ||
          username.isEmpty ||
          bio.isEmpty) {
        throw exceptions('Please fill in all the required fields.');
      }

      if (password != passwordConfirme) {
        throw exceptions('Password and confirm password should match.');
      }

      // Create user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      // Upload profile picture if provided
      if (profile != null && profile.existsSync() && profile != File('')) {
        final cloudinary = CloudinaryPublic('dbnrlfylq', 'sotg4hri');
        try {
          CloudinaryResponse response = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(profile.path),
          );
          if (kDebugMode) {
            print('Profile picture uploaded: ${response.secureUrl}');
          }

          profileUrl = response.secureUrl;
        } on CloudinaryException catch (e) {
          throw exceptions('Failed to upload profile picture: ${e.message}');
        } on DioException catch (e) {
          if (e.response?.statusCode == 401) {
            throw exceptions(
                'Cloudinary authentication failed. Verify your credentials.');
          } else {
            throw exceptions('Failed to upload profile picture: ${e.message}');
          }
        }
      } else {
        // Use a default profile picture if none is provided
        profileUrl =
            'https://miro.medium.com/v2/resize:fit:563/1*DdnXquBUvghgIhH0L56t-A.jpeg';
      }

      // Save user data to Firestore
      await Firebase_Firestore().Createuser(
        email: email,
        bio: bio,
        username: username,
        profile: profileUrl,
      );

      if (kDebugMode) {
        print('User registered successfully: ${userCredential.user?.uid}');
      }
    } on FirebaseAuthException catch (e) {
      throw exceptions(e.message ?? 'An unknown error occurred with Firebase.');
    } on exceptions catch (e) {
      rethrow;
    } catch (e) {
      throw exceptions('An unexpected error occurred: $e');
    }
  }

}
