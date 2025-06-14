import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iseeyou_2/Tabs/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _positionController= TextEditingController();

  bool _passwordVisible = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email cannot be empty';

    final emailCheck = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailCheck.hasMatch(value.trim())) return 'Enter a valid email address';

    return null;
  }

  String? mobileValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Mobile number cannot be empty';
    final mobilenuminput = value.trim();
    final validMobilenum = RegExp(r'^\d{11}$').hasMatch(mobilenuminput);

    if(!validMobilenum){
      return "Mobile number must be exactly 11 digits";
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Password cannot be empty';
    final passwordInput = value.trim();

    if(passwordInput.length < 8){
      return 'Password must be at least 8 characters long';
    }

    final hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(passwordInput);
    if(!hasSpecialChar){
      return 'Password must contain at least one special character';
    }

    return null;
  }

  String? lastnameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field cannot be empty';
    }
    final lastnameInput = value.trim();
    final validInput = RegExp(r'^[a-zA-Z\s]+$').hasMatch(lastnameInput);

    if(!validInput) {
      return 'This field should not contain special characters';
    }
    return null;
  }

  String? firstnameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field cannot be empty';
    }

    final firstnameinput = value.trim();
    final validfnInput = RegExp(r'^[a-zA-Z\s]+$').hasMatch(firstnameinput);

    if(!validfnInput){
      return 'This field should not contain any special characters';
    }
    return null;
  }

  String? positionValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field cannot be empty';
    }
    final positionInput = value.trim();
    final validInput = RegExp(r'^[a-zA-Z\s]+$').hasMatch(positionInput);

    if(!validInput) {
      return 'This field should not contain special characters';
    }
    return null;
  }

  ////////////////////////////////////////////UI/////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Text(
                      'I See You',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF101651),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Create an account',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Please fill in your details to get started',
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
                TextFormField(
                  controller: _lastnameController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: inputDecoration('Lastname', 'Enter your lastname'),
                  style: GoogleFonts.inter(
                    textStyle: inputTextStyle(),
                  ),
                  validator: lastnameValidator,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _firstnameController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: inputDecoration('Firstname', 'Enter your firstname'),
                  style: GoogleFonts.inter(
                    textStyle: inputTextStyle(),
                  ),
                  validator: firstnameValidator,
                ),
                SizedBox(height: 16),

                TextFormField(
                  controller: _positionController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: inputDecoration('Position', 'Enter your position'),
                  style: GoogleFonts.inter(
                    textStyle: inputTextStyle(),
                  ),
                  validator: positionValidator,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: inputDecoration('Email', 'Enter your email'),
                  style: GoogleFonts.inter(
                    textStyle: inputTextStyle(),
                  ),
                  validator: emailValidator,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  decoration: inputDecoration('Mobile number', 'Enter your mobile number'),
                  style: GoogleFonts.inter(
                    textStyle: inputTextStyle(),
                  ),
                  validator: mobileValidator,
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
                  style: GoogleFonts.inter(
                    textStyle: inputTextStyle(),
                  ),
                  validator: passwordValidator,
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      try{
                        final lastname = _lastnameController.text.trim();
                        final firstname = _firstnameController.text.trim();
                        final email = _emailController.text.trim();
                        final mobilenum = _mobileController.text.trim();
                        final password = _passwordController.text.trim();
                        final Position = _positionController.text.trim();

                        UserCredential userCredential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(email: email, password: password);

                        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
                          'lastname': lastname,
                          'firstname': firstname,
                          'Position': Position,
                          'email': email,
                          'mobilenum': mobilenum,
                          'password': password,
                          'createdAt': FieldValue.serverTimestamp(),
                        });
                        //i redirect sa login
                        await userCredential.user!.sendEmailVerification();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Account created! A verification email has been sent.'),
                            backgroundColor: Colors.green,
                          ),
                        );

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );

                      } on FirebaseAuthException catch (e) {
                        String errorMessage = 'Something went wrong. Please try again.';

                        if (e.code == 'email-already-in-use') {
                          errorMessage = 'This email is already in use.';
                        } else if (e.code == 'weak-password') {
                          errorMessage = 'Password is too weak.';
                        } else if (e.code == 'invalid-email') {
                          errorMessage = 'Invalid email address.';
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(errorMessage),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('An unknown error occurred.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
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
                    'SignUp',
                    style: GoogleFonts.inter(
                      textStyle: textTheme.titleSmall!.copyWith(
                        color: colorScheme.onPrimary,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: inputTextStyle(),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=> Login()),
                        );
                      },
                      child: Text(
                        'Sign In',
                        style: GoogleFonts.inter(
                          textStyle: inputTextStyle().copyWith(
                            color: Color(0xFF1A73E8),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}