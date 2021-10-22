import 'package:admin/Database/CenterDatabase.dart';
import 'package:admin/components/form_text.dart';
import 'package:admin/styles/colors.dart';
import 'package:admin/styles/text.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class AddCenter extends StatefulWidget {
  AddCenter(this.centerData);
  final Map centerData;
  @override
  _AddCenterState createState() => _AddCenterState();
}

class _AddCenterState extends State<AddCenter> {
  ScrollController _scrollController;
  TextEditingController _emailController;
  TextEditingController _addressController;
  TextEditingController _mobileNumberController;
  TextEditingController _contactNameController;
  TextEditingController _centerNameController;
  TextEditingController _latitudeController;
  TextEditingController _longitudeController;

  final _formKey10 = GlobalKey<FormState>();

  double latitude;
  double longitude;

  List centerList = [];
  Map centerMap;

  Future<Position> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      // setState(() {
      //   _isBusy = false;
      // });
      return value;
    });
    return position;
  }

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
    super.initState();
    _scrollController = ScrollController();

    _emailController = TextEditingController();
    _addressController = TextEditingController();
    _addressController = TextEditingController();
    _mobileNumberController = TextEditingController();
    _centerNameController = TextEditingController();
    _latitudeController = TextEditingController();
    _longitudeController = TextEditingController();
    _contactNameController = TextEditingController();

    _contactNameController.text = '';

    centerMap = widget.centerData['center_location'];
    centerMap.forEach((key, value) {
      centerList.add(key);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();

    _emailController.dispose();
    _mobileNumberController.dispose();
    _centerNameController.dispose();
    _addressController.dispose();
    _longitudeController.dispose();
    _latitudeController.dispose();
    _contactNameController.dispose();

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
                key: _formKey10,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  controller: _scrollController,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    FormText(
                        obscureText: false,
                        hintText: 'Center Name',
                        controller: _centerNameController,
                        validate: (value) {
                          if (value.isEmpty) {
                            return "center name cant be empty";
                          } else if (value.length > 50) {
                            return 'center name length should be lower than 50';
                          } else if (centerList.contains(value)) {
                            return 'A center with same name already exists';
                          } else
                            return null;
                        },
                        icon: Icons.apartment),
                    SizedBox(height: 20),
                    FormText(
                        obscureText: false,
                        hintText: 'Address',
                        controller: _addressController,
                        validate: (value) {
                          if (value.isEmpty) {
                            return "Address can\t be empty";
                          } else if (value.length > 200) {
                            return 'Address length should be lower than 200';
                          } else
                            return null;
                        },
                        icon: Icons.home),
                    SizedBox(height: 20),
                    FormText(
                        obscureText: false,
                        hintText: 'Email',
                        controller: _emailController,
                        validate: (value) {
                          if (value.isEmpty) {
                            return "Email cannot be empty";
                          } else
                            return null;
                        },
                        icon: Icons.email),
                    SizedBox(height: 20),
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
                    SizedBox(height: 20),
                    FormText(
                        obscureText: false,
                        hintText: 'Mobile Number',
                        controller: _mobileNumberController,
                        validate: (value) {
                          if (value.length < 8) {
                            return 'Need a valid mobile number';
                          }
                          if (value.length > 10) {
                            return "Mobile Number cant be greater than 10";
                          } else
                            return null;
                        },
                        icon: Icons.phone),
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
                    // GestureDetector(
                    //   onTap: () async {
                    //     LocationPermission permission =
                    //         await Geolocator.checkPermission();
                    //     if (permission == LocationPermission.denied) {
                    //       permission = await Geolocator.requestPermission();
                    //       if (permission == LocationPermission.denied) {
                    //         showDialog<String>(
                    //             context: context,
                    //             builder: (BuildContext context) => AlertDialog(
                    //                   title: const Text(
                    //                       'You have denied permission'),
                    //                   content: const Text(
                    //                       'Please allow permission so we can get your location'),
                    //                   actions: <Widget>[
                    //                     TextButton(
                    //                       onPressed: () {
                    //                         Navigator.pop(context, 'Cancel');
                    //                       },
                    //                       child: const Text('Cancel'),
                    //                     ),
                    //                     TextButton(
                    //                       onPressed: () {
                    //                         Navigator.pop(context, 'Ok');
                    //                       },
                    //                       child: const Text('Ok'),
                    //                     ),
                    //                   ],
                    //                 ));
                    //       }
                    //     }
                    //
                    //     if (permission == LocationPermission.deniedForever) {
                    //       // Permissions are denied forever, handle appropriately.
                    //       showDialog<String>(
                    //           context: context,
                    //           builder: (BuildContext context) => AlertDialog(
                    //                 title: const Text(
                    //                     'You have denied permission forever'),
                    //                 content: const Text(
                    //                     'To get location you will have to allow permission from settings'),
                    //                 actions: <Widget>[
                    //                   TextButton(
                    //                     onPressed: () {
                    //                       Navigator.pop(context, 'Cancel');
                    //                     },
                    //                     child: const Text('Cancel'),
                    //                   ),
                    //                   TextButton(
                    //                     onPressed: () {
                    //                       Navigator.pop(context, 'Ok');
                    //                     },
                    //                     child: const Text('Ok'),
                    //                   ),
                    //                 ],
                    //               ));
                    //     } else {
                    //       Position position = await getLocation();
                    //       if (position == null) {
                    //       } else {
                    //         latitude = position.latitude;
                    //         longitude = position.longitude;
                    //         _latitudeController.text = latitude.toString();
                    //         _longitudeController.text = longitude.toString();
                    //         print(latitude);
                    //         print(longitude);
                    //       }
                    //     }
                    //   },
                    //   child: Container(
                    //     height: 45,
                    //     width: 50,
                    //     decoration: BoxDecoration(
                    //         color: accent,
                    //         borderRadius:
                    //             BorderRadius.all(Radius.circular(50))),
                    //     child: Center(
                    //       child: Text(
                    //         'Use Current location',
                    //         style: GoogleFonts.montserrat(
                    //             color: Colors.white,
                    //             fontSize: 16,
                    //             fontWeight: FontWeight.bold),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        _centerNameController.text =
                            _centerNameController.text.trim();
                        _centerNameController.text =
                            _centerNameController.text.toLowerCase();

                        _contactNameController.text =
                            _contactNameController.text.trim();
                        _contactNameController.text =
                            _contactNameController.text.toLowerCase();

                        _addressController.text =
                            _addressController.text.trim();

                        _mobileNumberController.text =
                            _mobileNumberController.text.trim();

                        _emailController.text = _emailController.text.trim();
                        _emailController.text =
                            _emailController.text.toLowerCase();

                        if (_formKey10.currentState.validate()) {
                          await CenterData.createBloodDonationCenter(
                            name: _centerNameController.text,
                            emailId: _emailController.text,
                            mobileNumber: _mobileNumberController.text,
                            address: _addressController.text,
                            latitude: latitude,
                            longitude: longitude,
                            contactName: _contactNameController.text,
                          );
                          Navigator.pushReplacementNamed(context, "/auth");
                        }
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
                            'Create Center',
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
                            'Dismiss',
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
            "Add Center",
            style: pageTitleStyle,
          ),
        ),
      ],
    );
  }
}
