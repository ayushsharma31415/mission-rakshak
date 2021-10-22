import 'package:flutter/cupertino.dart';

class DonationLog {
  DonationLog({
    @required this.centerName,
    @required this.timestamp,
    @required this.bloodType,
    @required this.userName,
    @required this.userID,
  });
  final DateTime timestamp;
  final String userID;
  final String bloodType;
  final String userName;
  final String centerName;
}
