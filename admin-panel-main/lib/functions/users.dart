import 'package:admin/styles/colors.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void addUserFab(BuildContext context) {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  AwesomeDialog(
    context: context,
    width: 600,
    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    dialogBackgroundColor: secondary,
    title: "Add User",
    dialogType: DialogType.NO_HEADER,
    body: Column(
      children: [
        TextField(
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
            hintText: "Enter Name",
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
        TextField(
          autocorrect: false,
          autofocus: true,
          controller: _emailController,
          keyboardType: TextInputType.text,
          maxLines: 1,
          textCapitalization: TextCapitalization.words,
          textAlignVertical: TextAlignVertical.center,
          cursorColor: accent,
          style: GoogleFonts.montserrat(color: Colors.white),
          decoration: InputDecoration(
            border: null,
            fillColor: secondary,
            hintText: "Enter Email",
            hintStyle: GoogleFonts.montserrat(
              color: searchHelperColor,
            ),
            filled: true,
            prefixIcon: Icon(
              Icons.email,
              color: Colors.white,
            ),
          ),
        ),
        TextField(
          autocorrect: false,
          autofocus: true,
          controller: _phoneController,
          keyboardType: TextInputType.text,
          maxLines: 1,
          textCapitalization: TextCapitalization.words,
          textAlignVertical: TextAlignVertical.center,
          cursorColor: accent,
          style: GoogleFonts.montserrat(color: Colors.white),
          decoration: InputDecoration(
            border: null,
            fillColor: secondary,
            hintText: "Enter Phone Number",
            hintStyle: GoogleFonts.montserrat(
              color: searchHelperColor,
            ),
            filled: true,
            prefixIcon: Icon(
              Icons.phone,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
    btnOkOnPress: () {
      print('OK');
    },
    btnCancelOnPress: () {
      print('Cancel');
    },
    btnCancel: Container(
      height: 50,
      decoration: BoxDecoration(
          color: accent, borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: Center(
        child: Text(
          'Dismiss',
          style: GoogleFonts.montserrat(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    ),
    btnOk: Container(
      height: 50,
      decoration: BoxDecoration(
          color: verifiedColor,
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: Center(
        child: Text(
          'Confirm',
          style: GoogleFonts.montserrat(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    ),
    animType: AnimType.TOPSLIDE,
  ).show();
}