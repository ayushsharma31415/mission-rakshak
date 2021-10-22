import 'package:admin/Database/CenterDatabase.dart';
import 'package:admin/Database/RequextDatabase.dart';
import 'package:admin/components/form_text.dart';
import 'package:admin/models/center.dart';
import 'package:admin/pages/login.dart';
import 'package:admin/styles/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditCenterInfo extends StatefulWidget {
  EditCenterInfo({
    Key key,
    @required this.center,
    @required this.reload,
    @required GlobalKey<FormState> formKey,
  })  : _formKey = formKey,
        super(key: key);

  final CenterInformation center;
  final Function reload;

  final GlobalKey<FormState> _formKey;

  @override
  _EditCenterInfoState createState() => _EditCenterInfoState();
}

class _EditCenterInfoState extends State<EditCenterInfo> {
  final _formKey = GlobalKey<FormState>();

  double latitude;

  double longitude;

  final TextEditingController emailIdController = TextEditingController();

  final TextEditingController mobileNumberController = TextEditingController();

  final TextEditingController addressController = TextEditingController();

  final TextEditingController _contactNameController = TextEditingController();

  final TextEditingController _latitudeController = TextEditingController();

  final TextEditingController _longitudeController = TextEditingController();

  bool positionChecker(String string) {
    // Null or empty string is not a number
    if (string == null || string.isEmpty) {
      return false;
    }
    final double num = double.tryParse(string);
    if (num == null) {
      return false;
    }
    return true;
  }

  @override
  void initState() {
    latitude = widget.center.lat;
    longitude = widget.center.long;
    _longitudeController.text = longitude.toString();
    _latitudeController.text = latitude.toString();
    super.initState();
  }

  @override
  void dispose() {
    emailIdController.dispose();
    mobileNumberController.dispose();
    addressController.dispose();
    _contactNameController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    addressController.text = widget.center.address;
    emailIdController.text = widget.center.email;
    mobileNumberController.text = widget.center.number;
    _contactNameController.text = widget.center.contactName;

    return Container(
      width: MediaQuery.of(context).size.width * 7 / 10,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Form(
              autovalidateMode: AutovalidateMode.always,
              key: widget._formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FormText(
                    controller: emailIdController,
                    validate: (val) {
                      if (val.length < 2) {
                        return 'the email has to be valid';
                      }
                      return null;
                    },
                    icon: Icons.email,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FormText(
                      controller: addressController,
                      validate: (val) {
                        if (val.length < 2) {
                          return 'the address cant be empty';
                        }
                        return null;
                      },
                      icon: Icons.house),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Contact Details',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  FormText(
                      obscureText: false,
                      hintText: 'Contact Name',
                      controller: _contactNameController,
                      validate: (value) {
                        return null;
                      },
                      icon: Icons.person),
                  SizedBox(
                    height: 10,
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
                      icon: Icons.phone),
                  SizedBox(
                    height: 20,
                  ),
                  ActionButton(
                    onPressed: () async {
                      _contactNameController.text =
                          _contactNameController.text.trim();
                      _contactNameController.text =
                          _contactNameController.text.toLowerCase();

                      addressController.text = addressController.text.trim();

                      mobileNumberController.text =
                          mobileNumberController.text.trim();

                      emailIdController.text = emailIdController.text.trim();
                      emailIdController.text =
                          emailIdController.text.toLowerCase();

                      bool temp = await CenterData.updateBloodDonationCenter(
                        name: widget.center.name,
                        emailId: emailIdController.text,
                        mobileNumber: mobileNumberController.text,
                        address: addressController.text,
                        contactName: _contactNameController.text,
                      );

                      if (temp) {
                        Navigator.pop(context, 'Ok');
                      }
                      widget.reload();
                    },
                    text: "Update",
                    enabled: true,
                  ),
                ],
              ),
            ),
            Text(
              'Update center location',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            Form(
              autovalidateMode: AutovalidateMode.always,
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'latitude',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  FormText(
                      obscureText: false,
                      hintText: 'Latitude',
                      controller: _latitudeController,
                      validate: (value) {
                        if (value.length == 0 || value.length == null) {
                          return 'Latitude can not be empty';
                        }
                        if (positionChecker(value) != true) {
                          return 'Need to enter a number not a letter';
                        }
                        if (double.tryParse(value) > 90 ||
                            double.tryParse(value) < -90) {
                          return 'Latitude needs to be valid';
                        } else {
                          latitude = double.tryParse(value);
                          return null;
                        }
                      },
                      icon: Icons.place),
                  SizedBox(height: 20),
                  Text(
                    'Longitude',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  FormText(
                      obscureText: false,
                      hintText: 'Longitude',
                      controller: _longitudeController,
                      validate: (value) {
                        if (value.length == 0 || value.length == null) {
                          return 'Longitude can not be empty';
                        }
                        if (positionChecker(value) != true) {
                          return 'Need to enter a number not a letter';
                        }
                        if (double.tryParse(value) > 180 ||
                            double.tryParse(value) < -180) {
                          return 'Longitude needs to be valid';
                        } else {
                          longitude = double.tryParse(value);
                          return null;
                        }
                      },
                      icon: Icons.place),
                  SizedBox(
                    height: 20,
                  ),
                  ActionButton(
                    onPressed: () async {
                      _latitudeController.text =
                          _latitudeController.text.trim();
                      _longitudeController.text =
                          _longitudeController.text.trim();

                      bool temp = await CenterData.updateLocationDonationCenter(
                          name: widget.center.name,
                          latitude: latitude,
                          longitude: longitude);

                      if (temp) {
                        Navigator.pop(context, 'Ok');
                      }
                      widget.reload();
                    },
                    text: "Update Location",
                    enabled: true,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DeleteCenter extends StatefulWidget {
  const DeleteCenter({
    Key key,
    @required GlobalKey<FormState> formKey,
    @required this.center,
  })  : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final CenterInformation center;

  @override
  _DeleteCenterState createState() => _DeleteCenterState();
}

class _DeleteCenterState extends State<DeleteCenter> {
  final TextEditingController _nameController = TextEditingController();

  Future<bool> checkIfValid() async {
    bool check = true;
    print(widget.center.name);
    DocumentSnapshot requestData =
        await RequestData.bloodRequestCollection.doc('requestView').get();
    Map requestList = requestData['allRequests'];

    requestList.forEach((center, value) {
      String centerName = center.split('_')[0];
      print(centerName);
      if (centerName == widget.center.name) {
        check = false;
      }
    });
    return check;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 7 / 10,
      height: 400,
      child: Column(
        children: [
          Text(
            'Before deleting ensure that you removed all the donation request from this center',
            style: GoogleFonts.montserrat(
              color: Colors.redAccent,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Enter the name of center to delete. This is done to make sure that you are deleting the one want to',
            style: GoogleFonts.montserrat(color: Colors.white),
          ),
          SizedBox(
            height: 10,
          ),
          Form(
            autovalidateMode: AutovalidateMode.always,
            key: widget._formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                  validator: (val) {
                    if (val != widget.center.name) {
                      return 'the name entered is not correct';
                    }
                    return null;
                  },
                  autocorrect: false,
                  autofocus: true,
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  textCapitalization: TextCapitalization.words,
                  textAlignVertical: TextAlignVertical.center,
                  cursorColor: accent,
                  style: GoogleFonts.montserrat(color: Colors.white),
                  decoration: InputDecoration(
                    border: null,
                    fillColor: secondary,
                    hintText: widget.center.name,
                    hintStyle: GoogleFonts.montserrat(
                      color: searchHelperColor,
                    ),
                    filled: true,
                    prefixIcon: Icon(
                      Icons.account_circle,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          Expanded(child: SizedBox()),
          Row(
            children: [
              Spacer(),
              ActionButton(
                onPressed: () {
                  Navigator.pop(context, 'Cancel');
                },
                text: "Cancel",
                enabled: true,
              ),
              ActionButton(
                onPressed: () async {
                  if (widget._formKey.currentState.validate() &&
                      await checkIfValid()) {
                    // print(await checkIfValid());
                    bool temp = await CenterData.deleteBloodDonationCenter(
                        name: widget.center.name);
                    Navigator.pop(context, 'Ok');
                    Navigator.pushReplacementNamed(context, "/auth");
                  }
                },
                text: "Delete",
                enabled: true,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class CenterInfoDisplay extends StatelessWidget {
  const CenterInfoDisplay({
    Key key,
    @required this.center,
  }) : super(key: key);

  final CenterInformation center;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 7 / 10,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                SelectableText(
                  'Name : ${center.name}',
                  style: GoogleFonts.montserrat(color: Colors.white),
                ),
                SizedBox(
                  height: 20,
                ),
                SelectableText(
                  'Email : ${center.email}',
                  style: GoogleFonts.jetBrainsMono(color: Colors.white),
                ),
                SizedBox(
                  height: 20,
                ),
                SelectableText(
                  'Center Name : ${center.address}',
                  style: GoogleFonts.montserrat(color: Colors.white),
                ),
                SizedBox(
                  height: 20,
                ),
                SelectableText(
                  'Contact Name : ${center.contactName}',
                  style: GoogleFonts.jetBrainsMono(color: Colors.white),
                ),
                SizedBox(
                  height: 20,
                ),
                SelectableText(
                  'Mobile Number : ${center.number}',
                  style: GoogleFonts.jetBrainsMono(color: Colors.white),
                ),
                SizedBox(
                  height: 20,
                ),
                SelectableText(
                  'Latitude : ${center.lat}',
                  style: GoogleFonts.jetBrainsMono(color: Colors.white),
                ),
                SizedBox(
                  height: 10,
                ),
                SelectableText(
                  'Longitude : ${center.long}',
                  style: GoogleFonts.jetBrainsMono(color: Colors.white),
                ),
                SizedBox(
                  height: 20,
                ),
                SelectableText(
                  'Document Id : ${center.name}',
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
