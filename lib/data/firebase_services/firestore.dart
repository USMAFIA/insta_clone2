import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta_clone2/data/model/user_model.dart';
import 'package:insta_clone2/utils/exceptions.dart';
import 'package:uuid/uuid.dart';

class Firebase_Firestore {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<bool> Createuser({
    required String email,
    required String bio,
    required String username,
    required String profile,
  }) async {
    await _firebaseFirestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .set({
      'email': email,
      'username': username,
      'bio': bio,
      'profile': profile,
      'followers': [],
      'following': [],
    });
    return true;
  }

  Future<UserModel> getUser() async {
    try {
      final user = await _firebaseFirestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();
      final snapuser = user.data()!;
      return UserModel(
        snapuser['bio'],
        snapuser['email'],
        snapuser['followers'],
        snapuser['following'],
        snapuser['profile'],
        snapuser['username'],
      );
    }on FirebaseException catch(e){
      throw exceptions(e.message.toString());
    }
  }

  Future<bool> CreateUser({
    required String postImage,
    required String caption,
    required String location,
  })async{
    var uid = const Uuid().v4;
    DateTime date = new DateTime.now();
    UserModel user = await getUser();
    await _firebaseFirestore.collection('posts').doc(uid.toString()).set({
      'postImage':postImage,
      'username':user.username,
      'profileImage':user.profile,
      'caption':caption,
      'location':location,
      'uid':_auth.currentUser!.uid,
      'postId':uid,
      'like':[],
      'time':date,
    });
    return true;
  }
}
