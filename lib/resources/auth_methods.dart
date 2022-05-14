import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/resources/storage_methods.dart';
import 'package:instagram_flutter/utils/utils.dart.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  signUpUser({
    required String email,
    required String username,
    required String bio,
    required String password,
    required Uint8List file,
  }) async {
    String res = "Some Error Occured";
    try {
      //user aurh
      if (email.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          password.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoUrl = await StorageMethods()
            .uploadImagetoStorage('profilePics', file, false);
        print(photoUrl);
        //storing user cred
        await _firestore.collection('users').doc(cred.user!.uid).set({
          'username': username,
          'uid': cred.user!.uid,
          'bio': bio,
          'following': [],
          'followers': [],
          'photoUrl': photoUrl,
        });
        res = 'Success';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
