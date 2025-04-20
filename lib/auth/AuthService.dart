import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  Future<User?> signIn(String email, String password) async {
    try {
      var result = await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .timeout(const Duration(seconds: 10));
      return result.user;
    } on FirebaseAuthException catch (e) {
      return null;
    } catch (e) {
      return null;
    }
  }

  Future signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> signUp(String email, String password, String name, String id,
      String specialization, String neededspecialization, String token) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      QuerySnapshot querySnapshot =
          await users.where('suid', isEqualTo: id).get();

      if (querySnapshot.docs.isNotEmpty) {
        return 'User with this ID already exists';
      }

      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      if (user != null) {
        await users.doc(user.uid).set({
          'email': email,
          'password': password,
          'name': name,
          'suid': id,
          'specialization': specialization,
          'neededspecialization': neededspecialization,
          'swaped': false,
          'token': token
        });
        return user;
      } else {
        return 'User creation failed'; // في حال لم يتم إنشاء المستخدم لسبب ما
      }
    } catch (e) {
      return 'Error: $e'; // إرجاع رسالة خطأ واضحة
    }
  }

  Future<bool> checkSuidExists(String suid) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('suid', isEqualTo: suid)
        .limit(1)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }
}
