import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:i_see_you/Tabs/Notifications.dart';
import 'package:iseeyou_2/Tabs/History.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _passwordVisible = false;
  bool _showResendButton = false;

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> _loginUser() async {
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null && !user.emailVerified) {
        await FirebaseAuth.instance.signOut();

        setState(() {
          _showResendButton = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please verify your email before logging in.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      print('Login successful');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => History()),
      );
    } on FirebaseAuthException catch (e) {
      String errormessage;
      if (e.code == 'user-not-found') {
        errormessage = "User not found";
      } else if (e.code == 'wrong-password') {
        errormessage = "Password incorrect";
      } else {
        errormessage = 'Login failed: ${e.message}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errormessage), backgroundColor: Colors.red),
      );

      print('FirebaseAuthException code: ${e.code}');
      print('FirebaseAuthException message: ${e.message}');
    }
  }

  String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email cannot be empty';

    final emailCheck = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailCheck.hasMatch(value.trim())) return 'Enter a valid email address';

    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Password cannot be empty';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    InputDecoration inputDecoration(String label, String hint) {
      return InputDecoration(
        labelText: label,
        labelStyle: textTheme.bodyMedium?.copyWith(letterSpacing: 0.0),
        hintText: hint,
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: textTheme.bodySmall?.color,
          letterSpacing: 0.0,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFCCCCCC), width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.error, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.error, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: colorScheme.background,
      );
    }

    TextStyle inputTextStyle() {
      return textTheme.bodyMedium!.copyWith(letterSpacing: 0.0);
    }

    return Scaffold(
      backgroundColor: Color(0xFFD7E8F4),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: inputDecoration('Email', 'Enter your email'),
                  style: GoogleFonts.inter(textStyle: inputTextStyle()),
                  validator: emailValidator,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  obscureText: !_passwordVisible,
                  autofillHints: [AutofillHints.password],
                  decoration: inputDecoration('Password', 'Enter your password').copyWith(
                    suffixIcon: InkWell(
                      onTap: () => setState(() => _passwordVisible = !_passwordVisible),
                      child: Icon(
                        _passwordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        size: 22,
                      ),
                    ),
                  ),
                  style: GoogleFonts.inter(textStyle: inputTextStyle()),
                  validator: passwordValidator,
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _loginUser();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Color(0xFF101651),
                    elevation: 2,
                  ),
                  child: Text(
                    'Login',
                    style: GoogleFonts.inter(
                      textStyle: textTheme.titleSmall!.copyWith(
                        color: colorScheme.onPrimary,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                if (_showResendButton) ...[
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () async {
                      final email = _emailController.text.trim();
                      final password = _passwordController.text.trim();

                      try {
                        UserCredential userCredential = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(email: email, password: password);

                        User? user = userCredential.user;

                        if (user != null && !user.emailVerified) {
                          await user.sendEmailVerification();
                          await FirebaseAuth.instance.signOut();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Verification email resent. Please check your inbox.'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Email is already verified or account not found.'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        }
                      } on FirebaseAuthException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: ${e.message}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Resend Verification Email',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}