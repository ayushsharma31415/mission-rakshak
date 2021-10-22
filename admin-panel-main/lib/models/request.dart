import 'package:flutter/cupertino.dart';

class Request {
  Request(
      {@required this.bloodType,
      @required this.centerName,
      @required this.urgency,
      @required this.dateTime});
  String bloodType;
  String centerName;
  int urgency;
  DateTime dateTime;
}
