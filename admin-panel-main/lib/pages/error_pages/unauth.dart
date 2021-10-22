import 'package:admin/pages/login.dart';
import 'package:admin/styles/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotAuthorized extends StatefulWidget {
  @override
  _NotAuthorizedState createState() => _NotAuthorizedState();
}

class _NotAuthorizedState extends State<NotAuthorized> {
  signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock,
                color: accent,
                size: 100,
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Access Denied. only admin users \nhave permissions to access this page",
                style: GoogleFonts.montserrat(
                    color: accent, fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: ActionButton(
                  text: 'Sign Out',
                  enabled: true,
                  onPressed: () async {
                    signOut();
                  },
                ),
              ),
            ]),
      ),
    );
  }
}
