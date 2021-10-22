import 'package:flutter/cupertino.dart';

class CenterInformation {
  CenterInformation({
    @required this.name,
    @required this.address,
    @required this.lat,
    @required this.long,
    @required this.email,
    @required this.number,
    @required this.contactName,
  });
  String name;
  String address;
  double lat;
  double long;
  String email;
  String number;
  String contactName;

  void updateName(String newName) {
    this.name = newName;
  }

  void updateAddress(String newAddress) {
    this.address = newAddress;
  }

  void updateNumber(String newNumber) {
    this.number = newNumber;
  }

  void updateEmail(String email) {
    this.email = email;
  }

  void updateLocation(double newLat, double newLong) {
    this.lat = newLat;
    this.long = newLong;
  }
}
