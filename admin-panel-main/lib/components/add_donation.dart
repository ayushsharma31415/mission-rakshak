import 'package:admin/Database/CenterDatabase.dart';
import 'package:admin/Database/UserDatabase.dart';
import 'package:admin/Database/donationHistory.dart';
import 'package:admin/components/form_text.dart';
import 'package:admin/styles/colors.dart';
import 'package:admin/styles/text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddDonation extends StatefulWidget {
  AddDonation({this.centerData, this.userData});
  final Map centerData;
  final Map userData;
  @override
  _AddDonationState createState() => _AddDonationState();
}

class _AddDonationState extends State<AddDonation> {
  ScrollController _scrollController;
  TextEditingController _userIdController;

  final _formKey = GlobalKey<FormState>();

  double latitude;
  double longitude;

  List centerList = [];
  Map centerMap;

  Future<DocumentSnapshot> userDoc;

  bool showInfo = false;
  bool disableButton = false;

  String centerNameVal;

  List<DropdownMenuItem> centerNameDropDownItem;

  getCenterNameList() {
    centerNameDropDownItem = centerList.map((e) {
      return DropdownMenuItem<String>(
        value: e,
        child: Text(
          e,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
        ),
      );
    }).toList();
    print(centerNameDropDownItem);
  }

  Widget getButton(
      {@required isVerified,
      @required uid,
      @required firstName,
      @required lastName,
      @required mobileNumber,
      @required dob,
      @required bloodType,
      @required centerName,
      @required email}) {
    if (isVerified) {
      return Container(
        margin: EdgeInsets.only(top: 5),
        width: 350,
        height: 40,
        child: Material(
          color: Color(0xFFE94139),
          borderRadius: BorderRadius.circular(30.0),
          child: MaterialButton(
            onPressed: () async {
              String name = firstName + ' ' + lastName;

              bool temp2 = await DonationHistoryData.createDonationLog(
                  name: name,
                  bloodType: bloodType,
                  centerName: centerName,
                  userId: uid);

              setState(() {
                _userIdController.text = '';
                showInfo = false;
              });
            },
            child: Text(
              'Add to donation history',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Montserrat',
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      );
    }
    return Container(
      margin: EdgeInsets.only(top: 5),
      width: 300,
      height: 60,
      child: Material(
        color: Color(0xFFE94139),
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: () async {
            bool temp = await UserDatabase.makeUserVerified(
                firstName: firstName,
                lastName: lastName,
                mobileNumber: mobileNumber,
                DOB: dob,
                bloodType: bloodType,
                uid: uid,
                email: email);

            print(temp);

            String name = firstName + ' ' + lastName;

            bool temp2 = await DonationHistoryData.createDonationLog(
                name: name,
                bloodType: bloodType,
                centerName: centerName,
                userId: uid);

            setState(() {
              _userIdController.text = '';
              showInfo = false;
            });
          },
          child: Text(
            'Verify User and add to donation history',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Montserrat',
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _userIdController = TextEditingController();
    centerNameVal = widget.userData['centerName'];
    centerMap = widget.centerData['center_location'];
    centerMap.forEach((key, value) {
      centerList.add(key);
    });
    getCenterNameList();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _userIdController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Center(
            child: Container(
              color: primary,
              width: 500,
              child: Form(
                autovalidateMode: AutovalidateMode.always,
                key: _formKey,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  controller: _scrollController,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    FormText(
                        obscureText: false,
                        hintText: 'user Id',
                        controller: _userIdController,
                        validate: (value) {
                          if (value.isEmpty) {
                            return "user Id cant be empty";
                          } else
                            return null;
                        },
                        icon: Icons.apartment),
                    SizedBox(height: 20),
                    showInfo == true
                        ? FutureBuilder<DocumentSnapshot>(
                            future: userDoc,
                            // CenterData.getNearestCenterWithDocument(
                            //     latitude: latitude, longitude: longitude, index: centerData),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text(
                                  "Something went wrong",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                );
                              }

                              if ((snapshot.hasData && !snapshot.data.exists)) {
                                return Text(
                                  "There is no user for this Id",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                );
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                Map<String, dynamic> userData =
                                    snapshot.data.data();
                                String name = userData['firstName'] +
                                    ' ' +
                                    userData['lastName'];
                                String mobileNumber = userData['mobileNumber'];
                                String email = userData['emailId'];
                                String bloodType = userData['bloodType'];
                                bool isVerified = userData['donatedBefore'];

                                return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                        ),
                                        color: primary,
                                        child: Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'Name : ',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Text(
                                                    name,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Mobile : ',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white),
                                                  ),
                                                  Text(
                                                    mobileNumber,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Email : ',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white),
                                                  ),
                                                  Text(
                                                    email,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Blood Type : ',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white),
                                                  ),
                                                  Text(
                                                    bloodType,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20.0),
                                        child: Container(
                                          height: 60,
                                          width: 200,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            color: primary,
                                          ),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 13,
                                              ),
                                              Icon(
                                                Icons.apartment,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              DropdownButton(
                                                value: centerNameVal,
                                                dropdownColor: secondary,
                                                hint: Text(
                                                  "Center Name",
                                                  style: GoogleFonts.montserrat(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                onChanged: (val) {
                                                  if (val == null) {
                                                    setState(() {
                                                      centerNameVal = val;
                                                      print(centerNameVal);
                                                    });
                                                  } else {
                                                    setState(() {
                                                      centerNameVal = val;
                                                      print(centerNameVal);
                                                    });
                                                  }
                                                },
                                                icon: Icon(
                                                  Icons.arrow_downward,
                                                  color: Colors.white,
                                                ),
                                                items: centerNameDropDownItem,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      getButton(
                                        isVerified: isVerified,
                                        firstName: userData['firstName'],
                                        lastName: userData['lastName'],
                                        mobileNumber: mobileNumber,
                                        email: email,
                                        bloodType: bloodType,
                                        uid: _userIdController.text,
                                        dob: userData['DOB'],
                                        centerName: centerNameVal,
                                      ),
                                    ]);
                              }

                              return Text(
                                "Loading...",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              );
                            },
                          )
                        : GestureDetector(
                            onTap: () async {
                              _userIdController.text =
                                  _userIdController.text.trim();

                              setState(() {
                                userDoc = UserDatabase.userDataCollection
                                    .doc(_userIdController.text)
                                    .get();
                                showInfo = true;
                              });
                            },
                            child: Container(
                              height: 50,
                              width: 100,
                              decoration: BoxDecoration(
                                  color: accent,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                              child: Center(
                                child: Text(
                                  'Search',
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context, 'Cancel');
                      },
                      child: Container(
                        height: 45,
                        width: 50,
                        decoration: BoxDecoration(
                            color: accent,
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        child: Center(
                          child: Text(
                            'Go Back',
                            style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Text(
            "Add Donation",
            style: pageTitleStyle,
          ),
        ),
      ],
    );
  }
}
