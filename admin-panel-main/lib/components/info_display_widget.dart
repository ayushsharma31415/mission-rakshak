import 'package:admin/Database/UserDatabase.dart';
import 'package:admin/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin/styles/colors.dart';

class AdminInfoDisplay extends StatelessWidget {
  const AdminInfoDisplay({
    Key key,
    @required this.user,
  }) : super(key: key);

  final AdminUserInformation user;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      width: MediaQuery.of(context).size.width * 1 / 2,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: (MediaQuery.of(context).size.width * 1 / 4) - 30),
              child: Text(
                'Admin User',
                style: GoogleFonts.montserrat(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold),
              ),
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
                SelectableText('Name : ${user.firstName} ${user.lastName}',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                    )),
                SizedBox(
                  height: 20,
                ),
                SelectableText('Email : ${user.email}',
                    style: GoogleFonts.jetBrainsMono(color: Colors.white)),
                SizedBox(
                  height: 20,
                ),
                SelectableText('Center Name : ${user.centerName}',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                    )),
                SizedBox(
                  height: 20,
                ),
                SelectableText(
                  'Mobile Number : ${user.number}',
                  style: GoogleFonts.jetBrainsMono(color: Colors.white),
                ),
                SizedBox(
                  height: 20,
                ),
                SelectableText(
                  'Document Id : ${user.docId}',
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

class BloodGroup extends StatelessWidget {
  BloodGroup({@required this.bloodGrp});
  TextStyle _chipBaseStyle = GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );
  final String bloodGrp;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      width: 100,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2.5),
      decoration: BoxDecoration(
          color: bloodGrpColor.withOpacity(0.1),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      alignment: Alignment.center,
      child: Text(bloodGrp,
          style: _chipBaseStyle.copyWith(
              color: bloodGrpColor.withOpacity(0.8),
              fontSize: _chipBaseStyle.fontSize + 2.0)),
    );
  }
}

class AdminTag extends StatelessWidget {
  TextStyle _chipBaseStyle = GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2.5),
      decoration: BoxDecoration(
          color: adminTagColor.withOpacity(0.1),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      alignment: Alignment.center,
      child: Text("ADMIN",
          style: _chipBaseStyle.copyWith(
            color: adminTagColor.withOpacity(0.8),
          )),
    );
  }
}

class UserInfoDisplay extends StatefulWidget {
  UserInfoDisplay(this.user);
  UserInformation user;
  @override
  _UserInfoDisplayState createState() => _UserInfoDisplayState();
}

class _UserInfoDisplayState extends State<UserInfoDisplay> {
  int _calculateAge(DateTime dob) {
    Duration d = DateTime.now().difference(dob);
    int days = d.inDays;
    int years = days ~/ 365;
    return years;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      width: MediaQuery.of(context).size.width * 1 / 2,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Regular Account',
              style: GoogleFonts.montserrat(
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            FutureBuilder<DocumentSnapshot>(
              future:
                  UserDatabase.userDataCollection.doc(widget.user.docId).get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text(
                    "Something went wrong please check ur internet and try again",
                    style: TextStyle(color: Colors.white),
                  );
                }

                if ((snapshot.hasData && !snapshot.data.exists)) {
                  return Text(
                    "Document on the database does not exit",
                    style: TextStyle(color: Colors.white),
                  );
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  Map userData = snapshot.data.data();
                  // String centerName = user.centerName;
                  String name =
                      widget.user.firstName + ' ' + widget.user.lastName;
                  String email = widget.user.email;
                  String mobileNumber = widget.user.number;
                  String address = userData['address'];

                  String gender = userData['gender'];

                  List prevDonations;
                  Map lastDonation;
                  DateTime lastDonationDate;
                  String lastDonationString;
                  int numberOfDonation;

                  if (widget.user.verified) {
                    prevDonations = userData['previousDonations'];
                    numberOfDonation = prevDonations.length;
                    lastDonation = prevDonations[numberOfDonation - 1];
                    lastDonationDate = DateTime.fromMillisecondsSinceEpoch(
                      lastDonation['timeStamp'].seconds * 1000,
                    );
                    lastDonationString = lastDonationDate.day.toString() +
                        "/" +
                        lastDonationDate.month.toString() +
                        '/' +
                        lastDonationDate.year.toString();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      SelectableText(
                        'Name: $name',
                        style: GoogleFonts.montserrat(color: Colors.white),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SelectableText(
                        'Email : $email',
                        style: GoogleFonts.jetBrainsMono(color: Colors.white),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      widget.user.verified == true
                          ? SelectableText(
                              "Last Donation : ${lastDonation['centerName']}, $lastDonationString",
                              style: GoogleFonts.jetBrainsMono(
                                  color: Colors.white),
                            )
                          : SizedBox(),
                      widget.user.verified == true
                          ? SizedBox(
                              height: 20,
                            )
                          : SizedBox(),
                      widget.user.verified == true
                          ? SelectableText(
                              'Number of donations : $numberOfDonation',
                              style: GoogleFonts.jetBrainsMono(
                                  color: Colors.white),
                            )
                          : SizedBox(),
                      widget.user.verified == true
                          ? SizedBox(
                              height: 20,
                            )
                          : SizedBox(),
                      Row(
                        children: [
                          SelectableText(
                            'Blood Group :',
                            style: GoogleFonts.montserrat(color: Colors.white),
                          ),
                          BloodGroup(bloodGrp: widget.user.bloodGrp),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SelectableText(
                        'Age : ${_calculateAge(widget.user.dob)}',
                        style: GoogleFonts.montserrat(color: Colors.white),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SelectableText(
                        'Gender : $gender',
                        style: GoogleFonts.montserrat(color: Colors.white),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SelectableText(
                        'Mobile Number : $mobileNumber',
                        style: GoogleFonts.jetBrainsMono(color: Colors.white),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SelectableText(
                        'Address : $address',
                        style: GoogleFonts.montserrat(color: Colors.white),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SelectableText(
                        'ID : ${widget.user.docId}',
                        style: GoogleFonts.montserrat(color: Colors.white),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  );
                }

                return Text(
                  "Loading.........",
                  style: TextStyle(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
