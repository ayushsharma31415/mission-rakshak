import 'package:admin/components/error_message.dart';
import 'package:admin/components/form_text.dart';
import 'package:admin/styles/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  dynamic error_msg;
  bool ok = true;
  String error;

  getErrorMessage(e, message) {
    setState(() {
      error = CorrectMessages.getErrorMessageForLogin(e, message);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: primary,
        title: Text(
          "Login",
          style: GoogleFonts.montserrat(
              color: accent, fontSize: 40, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Text(
                "Welcome Back!",
                style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 26),
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: Container(
                  width: 700,
                  child: Form(
                    autovalidateMode: AutovalidateMode.always,
                    key: _formKey,
                    child: Column(
                      children: [
                        FormText(
                            hintText: 'Your Email',
                            controller: _emailController,
                            validate: (value) {
                              if (value.isEmpty) {
                                return "Email can't be empty";
                              } else
                                return null;
                            },
                            icon: Icons.email),
                        SizedBox(height: 20),
                        FormText(
                            obscureText: true,
                            hintText: 'Your password',
                            controller: _passwordController,
                            validate: (value) {
                              if (value.isEmpty) {
                                return "Password can't be empty";
                              } else
                                return null;
                            },
                            icon: Icons.lock),
                        error == null
                            ? Container(
                                height: 0,
                              )
                            : Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: ErrorMessage(error),
                              ),
                        Container(
                          margin: EdgeInsets.only(top: 10, bottom: 10),
                          child: ActionButton(
                            text: 'Login',
                            enabled: true,
                            onPressed: () async {
                              String errorMessaage = '';
                              if (_formKey.currentState.validate()) {
                                try {
                                  await _firebaseAuth
                                      .signInWithEmailAndPassword(
                                          email: _emailController.text,
                                          password: _passwordController.text);
                                  print('done');
                                  // ok = true;
                                } on FirebaseAuthException catch (e) {
                                  print(e);
                                  error_msg = e.code;
                                  errorMessaage = e.message;
                                  print(error_msg);
                                  ok = false;
                                } finally {
                                  if (ok) {
                                    // Navigator.pushReplacementNamed(
                                    //     context, "/auth");
                                  } else {
                                    getErrorMessage(error_msg, errorMessaage);
                                  }
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  ActionButton(
      {@required this.text, @required this.onPressed, @required this.enabled});

  final String text;
  final Function onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Material(
        elevation: 6.0,
        color: enabled ? accent : Colors.grey,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: () {
            enabled ? onPressed() : print(".");
          },
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            text,
            style: GoogleFonts.montserrat(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
