import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/app_user.dart';

class AuthProvider extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _users = FirebaseFirestore.instance.collection('users');

  AppUser? currentUser;
  bool isLoading = false;
  bool initialized = false; // to check if init() finished

  /// Call this from your main.dart before showing SplashPage
  void init() {
    _auth.authStateChanges().listen((user) async {
      if (user != null) {
        try {
          final doc = await _users.doc(user.uid).get();
          if (doc.exists) {
            currentUser = AppUser.fromJson(doc.data()!);
          } else {
            currentUser = AppUser(uid: user.uid, email: user.email ?? '');
            await _users.doc(user.uid).set(currentUser!.toJson());
          }
        } catch (e) {
          debugPrint("Firestore read failed: $e");
          // Keep currentUser as Firebase Auth user if Firestore fails
          currentUser ??= AppUser(uid: user.uid, email: user.email ?? '');
        }
      } else {
        currentUser = null;
      }
      notifyListeners();
    });
  }

  Future<void> signInWithEmail(String email, String password) async {
    isLoading = true;
    notifyListeners();
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> registerWithEmail(
      String email, String password, {String? name}) async {
    isLoading = true;
    notifyListeners();
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final u =
      AppUser(uid: cred.user!.uid, email: email, name: name);
      await _users.doc(cred.user!.uid).set(u.toJson());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginWithGoogle() async {
    isLoading = true;
    notifyListeners();
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      await _auth.signInWithCredential(credential);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(
      {String? name, String? photoUrl, String? phone}) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    final doc = await _users.doc(uid).get();
    final data = (doc.data() ?? {});
    final updated = AppUser(
      uid: uid,
      email: data['email'] ?? _auth.currentUser?.email ?? '',
      name: name ?? data['name'],
      photoUrl: photoUrl ?? data['photoUrl'],
      phone: phone ?? data['phone'],
    );
    await _users.doc(uid).set(updated.toJson(), SetOptions(merge: true));
    currentUser = updated;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _auth.signOut();
    currentUser = null;
    notifyListeners();
  }
}
