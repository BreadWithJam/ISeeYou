
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Tabs/History.dart';

class LoginLogic {
  static Future<void> loginUser({
    required BuildContext context,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required GlobalKey<FormState> formKey,
    required void Function(bool) showResendCallback,
    required void Function(String) showPopup,
  }) async {
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null && !user.emailVerified) {
        await FirebaseAuth.instance.signOut();

        showResendCallback(true);
        showPopup('Please verify your email before logging in.');
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => History()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = "User not found";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Password incorrect";
      } else {
        errorMessage = 'Login failed: Please make sure your email and password are correct';
      }

      showPopup(errorMessage);

      print('FirebaseAuthException code: ${e.code}');
      print('FirebaseAuthException message: ${e.message}');
    }
  }
}


class PopUpDialog {
  static void showPopup(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}