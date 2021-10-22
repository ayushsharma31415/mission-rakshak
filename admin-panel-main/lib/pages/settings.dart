import 'package:admin/pages/login.dart';
import 'package:admin/styles/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(initialScrollOffset: 50.0);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    signOut() async {
      await FirebaseAuth.instance.signOut();
    }

    return Container(
      child: ListView(
        physics: BouncingScrollPhysics(),
        controller: _scrollController,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              "Settings",
              style: pageTitleStyle,
            ),
          ),
          // DashCard(title: "Centers", data: "12,000", icon: Icons.room)
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
        ],
      ),
    );
  }
}
