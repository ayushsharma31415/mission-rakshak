import 'package:admin/Database/UserDatabase.dart';
import 'package:admin/components/info_display_widget.dart';
import 'package:admin/models/log.dart';
import 'package:admin/pages/login.dart';
import 'package:admin/styles/colors.dart';
import 'package:admin/styles/text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LogTile extends StatelessWidget {
  LogTile({@required this.log});
  final DonationLog log;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: secondary,
      ),
      child: Row(
        children: [
          // Icon(
          //   Icons.inv,
          //   color: accent,
          //   size: 30,
          // ),
          SizedBox(
            width: 10,
          ),
          BloodGroup(
            bloodGrp: this.log.bloodType,
          ),
          SizedBox(
            width: 10,
          ),
          Text(this.log.userName,
              style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          SizedBox(
            width: 10,
          ),
          Text(
            this.log.centerName,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.montserrat(fontSize: 20, color: Colors.white),
            maxLines: 1,
          ),
          Expanded(
            child: SizedBox(),
          ),
          Text(
            this.log.timestamp.day.toString() +
                '    ' +
                this.log.timestamp.hour.toString() +
                ':' +
                this.log.timestamp.minute.toString(),
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.montserrat(fontSize: 20, color: Colors.white),
            maxLines: 1,
          ),
          SizedBox(
            width: 30,
          ),
          GestureDetector(
            child: Icon(
              Icons.open_in_new,
              color: bloodGrpColor,
            ),
            onTap: () {
              showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        backgroundColor: primary,
                        title: SelectableText(
                          'Information about the user',
                          style: GoogleFonts.montserrat(color: Colors.white),
                        ),
                        content: DonationUserInfoDisplay(log.userID),
                        actions: [
                          ActionButton(
                              text: "Dismiss",
                              onPressed: () {
                                Navigator.pop(context, 'Ok');
                              },
                              enabled: true)
                        ],
                      ));
            },
          ),
          SizedBox(
            width: 30,
          ),
        ],
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

class DonationUserInfoDisplay extends StatefulWidget {
  DonationUserInfoDisplay(this.userDocId);
  String userDocId;
  @override
  _DonationUserInfoDisplayState createState() =>
      _DonationUserInfoDisplayState();
}

class _DonationUserInfoDisplayState extends State<DonationUserInfoDisplay> {
  int _calculateAge(DateTime dob) {
    Duration d = DateTime.now().difference(dob);
    int days = d.inDays;
    int years = days ~/ 365;
    return years;
  }

  Future<DocumentSnapshot> userDoc;

  @override
  void initState() {
    userDoc = UserDatabase.userDataCollection.doc(widget.userDocId).get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      width: MediaQuery.of(context).size.width * 4 / 10,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            FutureBuilder<DocumentSnapshot>(
              future: userDoc,
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
                    "This user has been deleted",
                    style: TextStyle(color: Colors.white),
                  );
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  Map userData = snapshot.data.data();
                  // String centerName = user.centerName;
                  String name =
                      userData['firstName'] + ' ' + userData['lastName'];
                  String email = userData['emailId'];
                  String mobileNumber = userData['mobileNumber'];
                  String address = userData['address'];

                  String gender = userData['gender'];

                  List prevDonations;
                  Map lastDonation;
                  DateTime lastDonationDate;
                  String lastDonationString;
                  int numberOfDonation;

                  //if (widget.user.verified) {
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
                  //}

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      SelectableText(
                        'Name : $name',
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
                      Row(
                        children: [
                          SelectableText(
                            'Blood Group :',
                            style: GoogleFonts.montserrat(color: Colors.white),
                          ),
                          BloodGroup(bloodGrp: userData['bloodType']),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SelectableText(
                        'Age : ${_calculateAge(DateTime.fromMillisecondsSinceEpoch(
                          userData['DOB'].seconds * 1000,
                        ))}',
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
                        "Last Donation : ${lastDonation['centerName']}, $lastDonationString",
                        style: GoogleFonts.jetBrainsMono(color: Colors.white),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SelectableText(
                        'Number of donations : $numberOfDonation',
                        style: GoogleFonts.jetBrainsMono(color: Colors.white),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SelectableText(
                        'Document Id : ${widget.userDocId}',
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
                  style: TextStyle(color: Colors.white),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
