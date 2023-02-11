import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_communication/helper/helper_function.dart';
import 'package:flutter_communication/service/database_service.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future login(
    String email,
    String password,
  ) async {
    try {
      final response = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = response.user;

      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future register(
    String fullName,
    String email,
    String password,
  ) async {
    try {
      final response = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = response.user;

      if (user != null) {
        await DatabaseService(uid: user.uid).savingUserData(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future signOut() async {
    try {
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmailSF("");
      await HelperFunctions.saveUserNameSF("");
      await auth.signOut();
    } catch (e) {
      return null;
    }
  }
}
