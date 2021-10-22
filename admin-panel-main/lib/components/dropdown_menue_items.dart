import 'package:admin/components/user_tile.dart';
import 'package:admin/pages/users.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum userTypes { verified, unverified, admin }
List<DropdownMenuItem> userTypeList = [
  DropdownMenuItem(
      value: Filters.verified,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            VStatus(isVerified: true),
            SizedBox(
              width: 10,
            ),
            Text(
              "Verified Users",
              style: GoogleFonts.montserrat(color: Colors.white),
            )
          ],
        ),
      )),
  DropdownMenuItem(
    value: Filters.unverified,
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        children: [
          VStatus(isVerified: false),
          SizedBox(
            width: 10,
          ),
          Text(
            "Unverified Users",
            style: GoogleFonts.montserrat(color: Colors.white),
          )
        ],
      ),
    ),
  ),
  DropdownMenuItem(
    value: Filters.admin,
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          AdmIcon(),
          SizedBox(
            width: 10,
          ),
          Text(
            "Admin Users",
            style: GoogleFonts.montserrat(color: Colors.white),
          )
        ],
      ),
    ),
  ),
  // DropdownMenuItem(
  //     value: Filters.numberOfDonations,
  //     child: Padding(
  //       padding: const EdgeInsets.all(5.0),
  //       child: Row(
  //         children: [
  //           Icon(
  //             Icons.access_time,
  //             color: Colors.white,
  //           ),
  //           // VStatus(isVerified: true),
  //           SizedBox(
  //             width: 10,
  //           ),
  //           Text(
  //             "Most Donations",
  //             style: GoogleFonts.montserrat(color: Colors.white),
  //           )
  //         ],
  //       ),
  //     )),
];

List<DropdownMenuItem> searchBarTypeList = [
  DropdownMenuItem(
      value: 'firstName',
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          "First Name",
          style: GoogleFonts.montserrat(color: Colors.white),
        ),
      )),
  DropdownMenuItem(
      value: 'lastName',
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          "Last Name",
          style: GoogleFonts.montserrat(color: Colors.white),
        ),
      )),
  DropdownMenuItem(
      value: 'userId',
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          "User Id",
          style: GoogleFonts.montserrat(color: Colors.white),
        ),
      )),
];

List<String> bloodGroups = [
  'O+',
  'O-',
  'A+',
  'A-',
  'AB+',
  'AB-',
  'B+',
  'B-',
];

List<DropdownMenuItem> bloodTypeList = bloodGroups.map((e) {
  return DropdownMenuItem(
    value: e,
    child: Text(
      e,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
    ),
  );
}).toList();

List<DropdownMenuItem<int>> urgencyList = [
  DropdownMenuItem(
      value: 2,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          "Normal",
          style: GoogleFonts.montserrat(color: Colors.white),
        ),
      )),
  DropdownMenuItem(
      value: 1,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          "Urgent",
          style: GoogleFonts.montserrat(color: Colors.white),
        ),
      )),
  DropdownMenuItem(
      value: 0,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(
          "Emergency",
          style: GoogleFonts.montserrat(color: Colors.white),
        ),
      )),
];
