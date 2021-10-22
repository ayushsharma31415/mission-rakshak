import 'package:admin/pages/login.dart';
import 'package:admin/styles/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoInfo extends StatefulWidget {
  @override
  _NoInfoState createState() => _NoInfoState();
}

class _NoInfoState extends State<NoInfo> {
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
                Icons.error_outline,
                color: accent,
                size: 100,
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "your user does not have any information. \nPlease input your info through the app",
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

class NoInternetPage extends StatefulWidget {
  @override
  _NoInternetPageState createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
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
                Icons.error_outline,
                color: accent,
                size: 100,
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "No internet connection, \nplease check your internet and try again",
                style: GoogleFonts.montserrat(
                    color: accent, fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: ActionButton(
                  text: 'Refresh',
                  enabled: true,
                  onPressed: () async {
                    Navigator.pushReplacementNamed(context, "/auth");
                  },
                ),
              ),
            ]),
      ),
    );
  }
}
