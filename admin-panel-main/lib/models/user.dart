import 'package:flutter/material.dart';

class UserInformation {
  UserInformation(
      {@required this.firstName,
      @required this.lastName,
      @required this.bloodGrp,
      @required this.verified,
      @required this.email,
      @required this.number,
      @required this.dob,
      @required this.isAdmin,
      @required this.docId,
      @required this.eligible,
      this.avatar});
  String firstName;
  String lastName;
  String bloodGrp;
  bool verified;
  String email;
  String number;
  String avatar;
  DateTime dob;
  bool isAdmin;
  String docId;
  bool eligible;

  String getName() {
    return firstName + ' ' + lastName;
  }

  void authorize() {
    this.isAdmin = true;
  }

  void verify() {
    this.verified = true;
  }

  // void updateName(newName) {
  //   this.name = newName;
  // }

  void updateEmail(newEmail) {
    this.email = newEmail;
  }

  void updateBloodGroup(newBloodGrp) {
    this.bloodGrp = newBloodGrp;
  }

  void updatePhoneNumber(newPhoneNumber) {
    this.number = newPhoneNumber;
  }

  void updateAvatar(newAvatarURL) {
    this.avatar = newAvatarURL;
  }

  void updateDOB(newDOB) {
    this.dob = newDOB;
  }
}

class AdminUserInformation {
  AdminUserInformation(
      {@required this.firstName,
      @required this.lastName,
      @required this.verified,
      @required this.email,
      @required this.number,
      @required this.centerName,
      @required this.isAdmin,
      @required this.docId,
      @required this.authLevel,
      this.avatar});
  String firstName;
  String lastName;
  String bloodGrp;
  bool verified;
  String email;
  String number;
  String avatar;
  String centerName;
  bool isAdmin;
  String docId;
  int authLevel;

  String getName() {
    return firstName + ' ' + lastName;
  }

  void authorize() {
    this.isAdmin = true;
  }

  void verify() {
    this.verified = true;
  }

  // void updateName(newName) {
  //   this.name = newName;
  // }

  void updateEmail(newEmail) {
    this.email = newEmail;
  }

  void updateBloodGroup(newBloodGrp) {
    this.bloodGrp = newBloodGrp;
  }

  void updatePhoneNumber(newPhoneNumber) {
    this.number = newPhoneNumber;
  }

  void updateAvatar(newAvatarURL) {
    this.avatar = newAvatarURL;
  }

  void updateCenterName(newCenterName) {
    this.avatar = newCenterName;
  }
}
