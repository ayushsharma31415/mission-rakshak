import 'package:admin/Database/UserDatabase.dart';
import 'package:admin/components/dropdown_menue_items.dart';
import 'package:admin/styles/colors.dart';
import 'package:admin/styles/text.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:convert' show utf8;
import 'dart:typed_data' show Uint8List;
import 'package:google_fonts/google_fonts.dart';
import 'dart:html' as webFile;

class BackUp extends StatefulWidget {
  @override
  _BackUpState createState() => _BackUpState();
}

class _BackUpState extends State<BackUp> {
  ScrollController _scrollController;
  // TextEditingController _emailController;
  // TextEditingController _addressController;
  // TextEditingController _mobileNumberController;
  // TextEditingController _centerNameController;
  // TextEditingController _latitudeController;
  // TextEditingController _longitudeController;

  final _formKey = GlobalKey<FormState>();

  List<DropdownMenuItem<String>> bloodTypeDropDown = [
        DropdownMenuItem<String>(
          value: 'All',
          child: Text(
            'All',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
          ),
        )
      ] +
      bloodTypeList;

  String bloodTypeVal = 'All';

  dynamic userStream;

  String error;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  uploadData(fData) async {
    firebase_storage.Reference ref = storage.ref(
        'backups/${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}/USERS-$bloodTypeVal.csv');

    List<int> encoded = utf8.encode(fData);
    Uint8List data = Uint8List.fromList(encoded);
    // Upload Task
    await ref.putData(data);
    String url = await ref.getDownloadURL();
    // Download

    // ignore: unused_local_variable
    var anchorElement = webFile.AnchorElement(
      href: url,
    )
      ..setAttribute("download",
          "USERS-${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}-${bloodTypeVal}.csv")
      ..click();
  }

  setUserStream() {
    if (bloodTypeVal == "All") {
      setState(() {
        userStream = UserDatabase.userDataCollection
            .where("donatedBefore", isEqualTo: true)
            .snapshots();
      });
    } else {
      setState(() {
        userStream = UserDatabase.userDataCollection
            .where("donatedBefore", isEqualTo: true)
            .where("bloodType", isEqualTo: bloodTypeVal.toString())
            .snapshots();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();

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
                    // SizedBox(
                    //   height: 30,
                    // ),
                    // FormText(
                    //     obscureText: false,
                    //     hintText: 'Center Name',
                    //     controller: _centerNameController,
                    //     validate: (value) {
                    //       if (value.isEmpty) {
                    //         return "center name cant be empty";
                    //       } else if (value.length > 50) {
                    //         return 'center name length should be lower than 50';
                    //       } else
                    //         return null;
                    //     },
                    //     icon: Icons.apartment),
                    // SizedBox(height: 20),
                    // FormText(
                    //     obscureText: false,
                    //     hintText: 'Address',
                    //     controller: _addressController,
                    //     validate: (value) {
                    //       if (value.isEmpty) {
                    //         return "Address can\t be empty";
                    //       } else if (value.length > 200) {
                    //         return 'Address length should be lower than 200';
                    //       } else
                    //         return null;
                    //     },
                    //     icon: Icons.home),
                    // SizedBox(height: 20),
                    // FormText(
                    //     obscureText: false,
                    //     hintText: 'Email',
                    //     controller: _emailController,
                    //     validate: (value) {
                    //       if (value.isEmpty) {
                    //         return "Email can\t be empty";
                    //       } else
                    //         return null;
                    //     },
                    //     icon: Icons.email),
                    // SizedBox(height: 20),
                    // FormText(
                    //     obscureText: false,
                    //     hintText: 'Mobile Number',
                    //     controller: _mobileNumberController,
                    //     validate: (value) {
                    //       if (value.length < 8) {
                    //         return 'Need a valid mobile number';
                    //       }
                    //       if (value.length > 10) {
                    //         return "Mobile Number cant be greater than 10";
                    //       } else
                    //         return null;
                    //     },
                    //     icon: Icons.phone),
                    // SizedBox(height: 20),
                    // Text(
                    //   'latitude',
                    //   style: TextStyle(
                    //     color: Colors.white,
                    //   ),
                    // ),
                    // SizedBox(height: 5),
                    // FormText(
                    //     obscureText: false,
                    //     hintText: 'Latitude',
                    //     controller: _latitudeController,
                    //     validate: (value) {
                    //       if (positionChecker(value) != true) {
                    //         return 'Need to enter a number not a letter';
                    //       } else {
                    //         latitude = double.tryParse(value);
                    //         return null;
                    //       }
                    //     },
                    //     icon: Icons.place),
                    // SizedBox(height: 20),
                    // Text(
                    //   'Longitude',
                    //   style: TextStyle(
                    //     color: Colors.white,
                    //   ),
                    // ),
                    // SizedBox(height: 5),
                    // FormText(
                    //     obscureText: false,
                    //     hintText: 'Longitude',
                    //     controller: _longitudeController,
                    //     validate: (value) {
                    //       if (positionChecker(value) != true) {
                    //         return 'Need to enter a number not a letter';
                    //       } else {
                    //         longitude = double.tryParse(value);
                    //         return null;
                    //       }
                    //     },
                    //     icon: Icons.place),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    Row(
                      children: [
                        SizedBox(
                          width: 13,
                        ),
                        Icon(
                          Icons.opacity,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        DropdownButton(
                          value: bloodTypeVal,
                          dropdownColor: secondary,
                          hint: Text(
                            "Blood Type",
                            style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          onChanged: (val) {
                            setState(() {
                              bloodTypeVal = val;
                            });
                          },
                          icon: Icon(
                            Icons.arrow_downward,
                            color: Colors.white,
                          ),
                          items: bloodTypeDropDown,
                        )
                      ],
                    ),

                    SizedBox(height: 15),

                    userStream != null
                        ? StreamBuilder<QuerySnapshot>(
                            stream: userStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text(
                                  'Something went wrong',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                );
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text(
                                  "Loading...",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                );
                              }

                              Map<String, List> usersByBloodType = {
                                'O+': [],
                                'O-': [],
                                'A+': [],
                                'A-': [],
                                'AB+': [],
                                'AB-': [],
                                'B+': [],
                                'B-': [],
                              };

                              List users = snapshot.data.docs;
                              print('connected');

                              users.forEach((value) {
                                UserData curUser =
                                    UserData.getUserData(value.data());

                                usersByBloodType.update(curUser.bloodType,
                                    (value) {
                                  return value + [curUser];
                                });
                              });

                              String fData =
                                  "firstName,lastName,dob,gender,email,mobileNumber,bloodType,number of donations,lastDonation,address,verified,latitude,longitude,donations\n";

                              usersByBloodType.forEach((key, value) {
                                value.forEach((element) {
                                  fData = fData + element.createRecord();
                                });

                                //just separates the users on blood type
                                if (fData[fData.length - 2] != " ") {
                                  fData = fData + " , , , , , , , , , , , , \n";
                                }
                              });

                              uploadData(fData);

                              // var blob =
                              //     webFile.Blob([fData], 'text/csv', 'native')

                              userStream = null;

                              return Text(
                                "Done...",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              );
                            },
                          )
                        : SizedBox(),

                    SizedBox(height: 15),

                    error != null
                        ? Text(
                            error,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                        : SizedBox(),

                    SizedBox(height: 15),

                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          error = null;
                          userStream = null;
                        });

                        firebase_storage.Reference ref = storage.ref(
                            'backups/${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}/USERS-$bloodTypeVal.csv');

                        ref.getDownloadURL().then((url) {
                          print('Today\'s Backup Already Exists.');

                          // ignore: unused_local_variable
                          var anchorElement = webFile.AnchorElement(
                            href: url,
                          )
                            ..setAttribute("download",
                                "USERS-${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}-$bloodTypeVal.csv")
                            ..click();
                        }).catchError((e) async {
                          if (e.code == 'object-not-found') {
                            setState(() {
                              setUserStream();
                            });
                          } else {
                            print(e.code);
                            setState(() {
                              error = e.code;
                            });
                          }
                        });
                      },
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                            color: accent,
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        child: Center(
                          child: Text(
                            'Get User Data',
                            style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Text(
            "Back Up",
            style: pageTitleStyle,
          ),
        ),
      ],
    );
  }
}

class UserData {
  const UserData({
    @required this.address,
    @required this.dob,
    @required this.donations,
    @required this.bloodType,
    @required this.email,
    @required this.firstName,
    @required this.gender,
    @required this.hasDonated,
    @required this.lastName,
    @required this.mobileNumber,
    @required this.location,
    @required this.lastDonation,
    @required this.nDonations,
  });
  final String address;
  final DateTime dob;
  final String bloodType;
  final bool hasDonated;
  final int nDonations;
  final String email;
  final String firstName;
  final String lastName;
  final String gender;
  final String mobileNumber;
  final String lastDonation;
  final GeoPoint location;
  final List<dynamic> donations;

  static String convertDateTimeToString(DateTime date) {
    return date.day.toString() +
        "/" +
        date.month.toString() +
        "/" +
        date.year.toString();
  }

  static String convertDonationMapToString(Map lastDonationMap) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(
        lastDonationMap['timeStamp'].seconds * 1000);

    String d = convertDateTimeToString(date);

    String lastDonation = '(' + lastDonationMap['centerName'] + " " + d + ')';

    return lastDonation;
  }

  String createRecord() {
    String verified = hasDonated == true ? 'Yes' : 'No';
    String usableAddress = address.replaceAll(",", "_");
    String dobString = convertDateTimeToString(dob);
    String donationEntry = '';
    donations.forEach((element) {
      donationEntry = donationEntry + ',' + convertDonationMapToString(element);
    });
    // donationEntry=donationEntry.substring(1,donationEntry.length);
    String record =
        "${firstName},${lastName},$dobString,${gender},${email},${mobileNumber},${bloodType},${donations.length},${lastDonation},$usableAddress,${verified},${location.latitude},${location.longitude}${donationEntry}" +
            "\n";
    return record;
  }

  static UserData getUserData(Map user) {
    String address = user['address'];
    DateTime dob =
        DateTime.fromMillisecondsSinceEpoch(user['DOB'].seconds * 1000);
    List<dynamic> donations = user['previousDonations'];
    String bloodType = user['bloodType'];
    String email = user['emailId'];
    String firstName = user['firstName'];
    String gender = user['gender'];
    bool hasDonated = user['donatedBefore'];
    String lastName = user['lastName'];
    String mobileNumber = user['mobileNumber'];
    GeoPoint location = user['location'];

    Map lastDonationMap = donations[donations.length - 1];

    String lastDonation = UserData.convertDonationMapToString(lastDonationMap);

    int nDonations = donations.length;

    UserData userData = UserData(
      address: address,
      dob: dob,
      donations: donations,
      bloodType: bloodType,
      email: email,
      firstName: firstName,
      gender: gender,
      hasDonated: hasDonated,
      lastName: lastName,
      mobileNumber: mobileNumber,
      location: location,
      lastDonation: lastDonation,
      nDonations: nDonations,
    );

    // print(userData.address);
    // print(userData.dob);
    // print(userData.donations);
    // print(userData.bloodType);
    // print(userData.email);
    // print(userData.firstName);
    // print(userData.lastName);
    // print(userData.gender);
    // print(userData.hasDonated);
    // print(userData.mobileNumber);
    // print(userData.location);
    // print(userData.lastDonation);
    // print(userData.nDonations);
    return userData;
  }
}
