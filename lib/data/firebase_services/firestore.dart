import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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

  Future<UserModel> getUser({String? uidd}) async {
    try {
      if (kDebugMode) {
        print('in get user function=========');
      }
      final user = await _firebaseFirestore
          .collection('users')
          .doc(uidd ?? _auth.currentUser!.uid)
          .get();
      if (kDebugMode) {
        print('getting the user from firebase======');
      }
      final snapuser = user.data()!;
      if (kDebugMode) {
        print('returning userModel ---------------');
      }
      return UserModel(
        snapuser['bio'],
        snapuser['email'],
        snapuser['followers'],
        snapuser['following'],
        snapuser['profile'],
        snapuser['username'],
      );
    } on FirebaseException catch (e) {
      throw exceptions(e.message.toString());
    }
  }

  Future<bool> CreatePost({
    required String postImage,
    required String caption,
    required String location,
  }) async {
    if (kDebugMode) {
      print('in createUser function<=========');
    }
    var uid = Uuid().v4();
    DateTime date = new DateTime.now();
    UserModel user = await getUser();
    if (kDebugMode) {
      print('getting the user in user variable======');
    }
    await _firebaseFirestore.collection('posts').doc(uid.toString()).set({
      'postImage': postImage,
      'username': user.username,
      'profileImage': user.profile,
      'caption': caption,
      'location': location,
      'uid': _auth.currentUser!.uid,
      'postId': uid.toString(),
      'like': [],
      'time': date,
    });
    print('setting the post in firebase======');
    return true;
  }

  Future<bool> CreateReel({
    required String video,
    required String caption,
  }) async {
    if (kDebugMode) {
      print('in createUser function<=========');
    }
    var uid = Uuid().v4();
    DateTime date = new DateTime.now();
    UserModel user = await getUser();
    if (kDebugMode) {
      print('getting the user in user variable======');
    }
    await _firebaseFirestore.collection('reels').doc(uid.toString()).set({
      'reelsvideo': video,
      'username': user.username,
      'profileImage': user.profile,
      'caption': caption,
      'uid': _auth.currentUser!.uid,
      'postId': uid.toString(),
      'like': [],
      'time': date,
    });
    print('setting the post in firebase======');
    return true;
  }

  Future<bool> Comments({
    required String comment,
    required String type,
    required String uidd,
  }) async {
    if (kDebugMode) {
      print('in createUser function<=========');
    }
    var uid = Uuid().v4();
    UserModel user = await getUser();
    if (kDebugMode) {
      print('getting the user in user variable======');
    }
    await _firebaseFirestore
        .collection(type)
        .doc(uidd.toString())
        .collection('comments')
        .doc(uid.toString())
        .set(
      {
        'comment': comment,
        'username': user.username,
        'profileImage': user.profile,
        'CommentUid': uid.toString(),
      },
    );
    print('setting the post in firebase======');
    return true;
  }

  Future<String> like({
    required List like,
    required String type,
    required String uid,
    required String postId,
  }) async {
    String res = 'Some error Occured';
    try {
      if (like.contains(uid)) {
        await _firebaseFirestore.collection(type).doc(postId).update(
          {
            'like': FieldValue.arrayRemove([uid]),
          },
        );
      } else {
        await _firebaseFirestore.collection(type).doc(postId).update(
          {
            'like': FieldValue.arrayUnion([uid]),
          },
        );
      }
      res = 'Successed';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> follow({
    required String uid,
  }) async {
    String res = 'Some error Occured in follow';
    DocumentSnapshot snap = await _firebaseFirestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get();
    List follow = (snap.data()! as dynamic)['following'];
    try {
      if (follow.contains(uid)) {
        await _firebaseFirestore.collection('users').doc(_auth.currentUser!.uid).update(
          {
            'following': FieldValue.arrayRemove([uid]),
          },
        );
        await _firebaseFirestore.collection('users').doc(uid).update(
          {
            'followers': FieldValue.arrayRemove([_auth.currentUser!.uid]),
          },
        );
      } else {
        await _firebaseFirestore.collection('users').doc(_auth.currentUser!.uid).update(
          {
            'following': FieldValue.arrayUnion([uid]),
          },
        ); await _firebaseFirestore.collection('users').doc(uid).update(
          {
            'followers': FieldValue.arrayUnion([_auth.currentUser!.uid]),
          },
        );
      }
      res = 'Successed';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<bool> doesCollectionExist(String collectionPath) async {
    try {
      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection(collectionPath)
          .limit(1)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error checking collection existence: $e");
      return false;
    }
  }
}
