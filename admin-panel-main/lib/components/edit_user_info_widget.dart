import 'package:admin/Database/UserDatabase.dart';
import 'package:admin/components/form_text.dart';
import 'package:admin/models/user.dart';
import 'package:admin/pages/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditInfoWidget extends StatefulWidget {
  EditInfoWidget({
    Key key,
    @required this.user,
    @required this.reload,
    @required GlobalKey<FormState> formKey,
  })  : _formKey = formKey,
        super(key: key);

  final UserInformation user;

  final Function reload;

  final GlobalKey<FormState> _formKey;

  @override
  _EditInfoWidgetState createState() => _EditInfoWidgetState();
}

class _EditInfoWidgetState extends State<EditInfoWidget> {
  final TextEditingController firstNameController = TextEditingController();

  final TextEditingController lastNameController = TextEditingController();

  final TextEditingController mobileNumberController = TextEditingController();

  final TextEditingController addressController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    mobileNumberController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    firstNameController.text = widget.user.firstName;
    lastNameController.text = widget.user.lastName;
    mobileNumberController.text = widget.user.number;

    return Container(
      width: MediaQuery.of(context).size.width * 7 / 10,
      child: SingleChildScrollView(
        child: Column(
          children: [
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
                    style: GoogleFonts.montserrat(color: Colors.white),
                  );
                }

                if ((snapshot.hasData && !snapshot.data.exists)) {
                  return Text(
                    "Document on the database does not exit",
                    style: GoogleFonts.montserrat(color: Colors.white),
                  );
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> userData = snapshot.data.data();

                  addressController.text = userData['address'];

                  return Form(
                    autovalidateMode: AutovalidateMode.always,
                    key: widget._formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        FormText(
                          controller: firstNameController,
                          validate: (val) {
                            if (val.length < 2) {
                              return 'the name entered is too short';
                            }
                            return null;
                          },
                          icon: Icons.person,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FormText(
                          controller: lastNameController,
                          validate: (val) {
                            if (val.length < 2) {
                              return 'the name entered is too short';
                            }
                            return null;
                          },
                          icon: Icons.person,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FormText(
                          controller: mobileNumberController,
                          validate: (val) {
                            if (val.length < 8) {
                              return 'Mobile number needs to be valid';
                            }
                            if (val.length > 10) {
                              return 'Mobile number needs to be valid';
                            }
                            return null;
                          },
                          icon: Icons.phone,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FormText(
                          controller: addressController,
                          validate: (val) {
                            if (val.length < 2) {
                              return 'the address entered is too short';
                            }
                            if (val.length > 300) {
                              return 'the address entered is too long';
                            }
                            return null;
                          },
                          icon: Icons.house,
                        ),
                        SizedBox(height: 30),
                        ActionButton(
                          text: "Update",
                          enabled: true,
                          onPressed: () async {
                            if (widget._formKey.currentState.validate()) {
                              lastNameController.text =
                                  lastNameController.text.trim();
                              firstNameController.text =
                                  firstNameController.text.trim();
                              mobileNumberController.text =
                                  mobileNumberController.text.trim();

                              firstNameController.text =
                                  firstNameController.text.toLowerCase();
                              lastNameController.text =
                                  lastNameController.text.toLowerCase();
                              addressController.text =
                                  addressController.text.trim();

                              if (!widget.user.verified) {
                                if (await UserDatabase
                                    .updateUnauthorizedUserDataFromProfilePage(
                                  firstName: firstNameController.text,
                                  lastName: lastNameController.text,
                                  mobileNumber: mobileNumberController.text,
                                  address: addressController.text,
                                  oldFirstName: widget.user.firstName,
                                  oldLastName: widget.user.lastName,
                                  oldMobileNumber: widget.user.number,
                                  DOB: userData['DOB'],
                                  bloodType: widget.user.bloodGrp,
                                  docId: widget.user.docId,
                                  emailId: widget.user.email,
                                )) {
                                  Navigator.pop(context, 'Ok');

                                  if (widget.reload != null) {
                                    widget.reload();
                                  }
                                }
                              } else {
                                if (await UserDatabase
                                    .updateVerifiedUserDataFromProfilePage(
                                  firstName: firstNameController.text,
                                  lastName: lastNameController.text,
                                  mobileNumber: mobileNumberController.text,
                                  address: addressController.text,
                                  oldFirstName: widget.user.firstName,
                                  oldLastName: widget.user.lastName,
                                  oldMobileNumber: widget.user.number,
                                  DOB: userData['DOB'],
                                  bloodType: widget.user.bloodGrp,
                                  docId: widget.user.docId,
                                  emailId: widget.user.email,
                                )) {
                                  Navigator.pop(context, 'Ok');

                                  if (widget.reload != null) {
                                    widget.reload();
                                  }
                                }
                              }
                            }
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ActionButton(
                          onPressed: () async {
                            Navigator.pop(context, 'Cancel');
                          },
                          text: "Cancel",
                          enabled: true,
                        ),
                      ],
                    ),
                  );
                }

                return Text(
                  "Loading.........",
                  style: GoogleFonts.montserrat(color: Colors.white),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
