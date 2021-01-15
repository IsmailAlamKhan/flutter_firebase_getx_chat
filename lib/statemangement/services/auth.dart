import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/ui/ui.dart';
import 'package:firebase_chat_app/utils/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphx/graphx.dart';
import 'package:path/path.dart' as p;
import '../statemangement.dart';

class AuthService extends GetxService {
  final FirebaseService _firebaseService = Get.find();
  final UserController userController = Get.find();
  static AuthService to = Get.find();
  FirebaseAuth auth = FirebaseAuth.instance;
  Rx<User> user = Rx<User>();
  User get currentUser => user.value;

  @override
  void onInit() {
    user.bindStream(auth.authStateChanges());
    user.bindStream(auth.userChanges());
    super.onInit();
  }

  Future<void> verifyEmail() async {
    currentUser.reload();
    if (!currentUser.emailVerified) {
      await currentUser.sendEmailVerification();
    } else {
      await UserCrud().updateuser(
        user: UserModel(
          email: currentUser.email,
          id: currentUser.uid,
          displayName: currentUser.displayName,
          emailVerified: true,
        ),
      );
    }
  }

  Future<void> updateUser(UserModel val) async {
    trace(val.id);
    if (val == null) return;
    trace(val.id);
    // debugger();
    if (val.displayName == currentUser.displayName &&
        val.email == currentUser.email &&
        val.photoURL == currentUser.photoURL) {
      showInfoSnackBar(body: 'Nothing to update');
      return;
    }
    await showLoadingWithProggress(
      wantProggress: false,
    );
    try {
      if (val.email != null && val.email != currentUser.email) {
        await currentUser.updateEmail(
          val.email,
        );
      } else if (val.displayName != null &&
          val.displayName != currentUser.displayName) {
        await currentUser.updateProfile(
          displayName: val.displayName,
        );
      } else if (val.photoURL != null && val.photoURL != currentUser.photoURL) {
        final File _photo = File(val.photoURL);
        String _fileName =
            "${p.basename(currentUser.uid)}${p.extension(val.photoURL)}";
        final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
        final Reference _ref =
            _firebaseStorage.ref().child('/profileimages/$_fileName');
        await _ref.putFile(_photo);
        final String _photoUrl = await _ref.getDownloadURL();
        await currentUser.updateProfile(photoURL: _photoUrl);
      }
      final _user = UserModel(
        displayName: currentUser.displayName,
        email: currentUser.email,
        emailVerified: currentUser.emailVerified,
        photoURL: currentUser.photoURL,
        id: currentUser.uid,
      );
      final String msg = await UserCrud().updateuser(user: _user);
      Get.back();
      showSuccessSnackBar(body: msg);
      currentUser.reload();
      Get.find<UserProfileController>().image = null;
      Get.find<UserProfileController>().imagePicked = false;
      Get.find<UserProfileController>().counter += 1;
    } catch (e) {
      Get.back();
      showErrorSnackBar(body: e.toString());
    }
  }

  Worker userWorker;
  @override
  void onReady() {
    userWorker = ever(userController.user, (UserModel val) {
      if (currentUser?.displayName != val.displayName) {
        currentUser.updateProfile(
          displayName: val.displayName,
        );
        currentUser.reload();
      }
    });
    super.onReady();
  }

  @override
  void onClose() {
    userWorker?.dispose();
  }

  Future<String> doAuth(
    AuthState authState, {
    @required String email,
    @required String password,
    @required String username,
  }) async {
    try {
      UserCredential authResult;
      switch (authState) {
        case AuthState.Login:
          authResult = await auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          break;
        case AuthState.Registration:
          authResult = await auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          final currentUser = auth.currentUser;
          await currentUser.updateProfile(displayName: username);
          final user = UserModel(
            id: currentUser.uid,
            email: currentUser.email,
            displayName: username,
            emailVerified: false,
          );

          await UserCrud().createUser(
            user: user,
          );
          break;
        default:
      }

      userController.fillUser(UserCrud().getUser(authResult.user.uid));
      return 'Sucessful';
    } on FirebaseAuthException catch (e) {
      trace(e.code);
      return Future.error(_firebaseService.firebaseErrors(e.code));
    } on FirebaseException catch (e) {
      return Future.error(_firebaseService.firebaseErrors(e.code));
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<void> logOut() async {
    try {
      await auth.signOut();
      userController.user(UserModel());
    } on FirebaseAuthException catch (e) {
      showErrorSnackBar(body: _firebaseService.firebaseErrors(e.code));
    }
  }
}
