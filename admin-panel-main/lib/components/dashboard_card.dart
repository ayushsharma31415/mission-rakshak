import 'package:admin/components/user_tile.dart';
import 'package:admin/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:admin/styles/colors.dart';
import 'package:admin/styles/text.dart';
import 'package:google_fonts/google_fonts.dart';

class DashCard extends StatefulWidget {
  DashCard({@required this.title, @required this.data, @required this.icon});
  final String title;
  final String data;
  final IconData icon;
  @override
  _DashCardState createState() => _DashCardState();
}

class _DashCardState extends State<DashCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        width: (MediaQuery.of(context).size.width) / 2 - 100,
        height: 263.5,
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: secondary,
            boxShadow: [
              BoxShadow(
                  offset: Offset.fromDirection(0.0, 6.0),
                  color: dashboardCardShadowColor,
                  spreadRadius: 6,
                  blurRadius: 6)
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Icon(
                    widget.icon,
                    size: 52,
                    color: dashboardCardIconColor,
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                Text(
                  widget.title,
                  style: dashboardCardTitleStyle,
                ),
              ],
            ),
            SizedBox(
              height: 70,
            ),
            Row(
              children: [
                Spacer(),
                Text(
                  widget.data,
                  style: dashboardCardTitleStyle.copyWith(
                      fontSize: dashboardCardTitleStyle.fontSize + 12.0),
                ),
                Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ErrorDashCard extends StatefulWidget {
  ErrorDashCard(
      {@required this.title, @required this.data, @required this.icon});
  final String title;
  final String data;
  final IconData icon;
  @override
  _ErrorDashCardState createState() => _ErrorDashCardState();
}

class _ErrorDashCardState extends State<ErrorDashCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        width: (MediaQuery.of(context).size.width - 170) / 2,
        height: (MediaQuery.of(context).size.height - 130) / 2,
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: secondary,
            boxShadow: [
              BoxShadow(
                  offset: Offset.fromDirection(0.0, 6.0),
                  color: dashboardCardShadowColor,
                  spreadRadius: 6,
                  blurRadius: 6)
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Icon(
                    widget.icon,
                    size: 52,
                    color: dashboardCardIconColor,
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                Text(
                  widget.title,
                  style: dashboardCardTitleStyle,
                ),
              ],
            ),
            SizedBox(
              height: 70,
            ),
            Text(
              widget.data,
              style: dashboardCardTitleStyle.copyWith(
                  color: Color.fromRGBO(193, 193, 193, 1.0),
                  fontSize: dashboardCardTitleStyle.fontSize + 12.0),
            ),
          ],
        ),
      ),
    );
  }
}

class UserCount extends StatefulWidget {
  UserCount(
      {@required this.title,
      @required this.verified_users,
      @required this.unverified_users,
      @required this.admin_users,
      @required this.count,
      @required this.icon});
  final String title;
  final String verified_users;
  final String unverified_users;
  final String admin_users;
  final IconData icon;
  final Map count;
  @override
  _UserCountState createState() => _UserCountState();
}

class _UserCountState extends State<UserCount> {
  @override
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        width: (MediaQuery.of(context).size.width - 200) / 2,
        height: 263.5,
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: secondary,
            boxShadow: [
              BoxShadow(
                  offset: Offset.fromDirection(0.0, 6.0),
                  color: dashboardCardShadowColor,
                  spreadRadius: 6,
                  blurRadius: 6)
            ]),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Icon(
                    widget.icon,
                    size: 52,
                    color: dashboardCardIconColor,
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                Text(
                  widget.title,
                  style: dashboardCardTitleStyle,
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        VStatus(isVerified: true),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          widget.verified_users,
                          style: dashboardCardTitleStyle.copyWith(
                              color: Color.fromRGBO(193, 193, 193, 1.0),
                              fontSize: dashboardCardTitleStyle.fontSize - 5),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        VStatus(isVerified: false),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          widget.unverified_users,
                          style: dashboardCardTitleStyle.copyWith(
                              color: Color.fromRGBO(193, 193, 193, 1.0),
                              fontSize: dashboardCardTitleStyle.fontSize - 5),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AStatus(),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          widget.admin_users,
                          style: dashboardCardTitleStyle.copyWith(
                              color: Color.fromRGBO(193, 193, 193, 1.0),
                              fontSize: dashboardCardTitleStyle.fontSize - 5),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: ActionButton(
                          text: "View More",
                          onPressed: () {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      backgroundColor: primary,
                                      title: Text(
                                        'User Count according to blood',
                                        style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      content:
                                          bloodgroupDisplay(widget: widget),
                                      actions: <Widget>[
                                        ActionButton(
                                          text: "Dismiss",
                                          enabled: true,
                                          onPressed: () {
                                            Navigator.pop(context, "Cancel");
                                          },
                                        ),
                                      ],
                                    ));
                          },
                          enabled: true),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class bloodgroupDisplay extends StatelessWidget {
  const bloodgroupDisplay({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final dynamic widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      width: MediaQuery.of(context).size.width * 4 / 10,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Verfied Users',
              style: GoogleFonts.montserrat(
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                SelectableText(
                  'O+  : ${widget.count['O+']}',
                  style: GoogleFonts.jetBrainsMono(color: Colors.white),
                ),
                SizedBox(
                  height: 20,
                ),
                SelectableText(
                  'O-  : ${widget.count['O-']}',
                  style: GoogleFonts.jetBrainsMono(color: Colors.white),
                ),
                SizedBox(
                  height: 20,
                ),
                SelectableText(
                  "A+  : ${widget.count['A+']}",
                  style: GoogleFonts.jetBrainsMono(color: Colors.white),
                ),
                SizedBox(
                  height: 20,
                ),
                SelectableText(
                  'A-  : ${widget.count['A-']}',
                  style: GoogleFonts.jetBrainsMono(color: Colors.white),
                ),
                SizedBox(
                  height: 20,
                ),
                SelectableText(
                  'B+  : ${widget.count['B+']}',
                  style: GoogleFonts.jetBrainsMono(color: Colors.white),
                ),
                SizedBox(
                  height: 20,
                ),
                SelectableText(
                  'B-  : ${widget.count['B-']}',
                  style: GoogleFonts.jetBrainsMono(color: Colors.white),
                ),
                SizedBox(
                  height: 20,
                ),
                SelectableText(
                  'AB+ : ${widget.count['AB+']}',
                  style: GoogleFonts.jetBrainsMono(color: Colors.white),
                ),
                SizedBox(
                  height: 20,
                ),
                SelectableText(
                  'AB- : ${widget.count['AB-']}',
                  style: GoogleFonts.jetBrainsMono(color: Colors.white),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AStatus extends StatelessWidget {
  AStatus();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      // width: 130,
      padding: EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: adminTagColor.withOpacity(0.1)),
      child: Icon(
        Icons.error,
        color: adminTagColor.withOpacity(0.8),
        size: 20,
      ),
      alignment: Alignment.center,
    );
  }
}
