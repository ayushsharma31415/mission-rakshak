import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Priority extends StatelessWidget {
  Priority({@required this.priority});
  int priority = 0;
  Map<int, Map<String, dynamic>> _priorityMap = <int, Map<String, dynamic>>{
    0: {
      "color": Color.fromRGBO(255, 100, 44, 1),
      "icon": Icons.notification_important,
      "text": "Urgent"
    }
  };
  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: CircleAvatar(
        backgroundColor: _priorityMap[this.priority]["color"].withOpacity(0),
        child: Icon(
          _priorityMap[this.priority]["icon"],
          color: _priorityMap[this.priority]["color"].withOpacity(0.6),
        ),
      ),
      backgroundColor: _priorityMap[this.priority]["color"].withOpacity(0.08),
      label: Text(_priorityMap[this.priority]["text"],
          style: GoogleFonts.montserrat(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: _priorityMap[this.priority]["color"].withOpacity(0.87),
          )),
    );
  }
}

class PrioChip extends StatelessWidget {
  PrioChip({@required this.priority});
  int priority;
  Map<int, Map<String, dynamic>> _priorityMap = <int, Map<String, dynamic>>{
    0: {
      "color": Colors.redAccent,
      "icon": Icons.notification_important,
      "text": "Emergency"
    },
    1: {
      "color": Color.fromRGBO(255, 100, 44, 1),
      "icon": Icons.notification_important,
      "text": "Urgent"
    }
  };
  @override
  Widget build(BuildContext context) {
    return priority != 2
        ? Container(
            height: 32,
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
            decoration: BoxDecoration(
                color: _priorityMap[this.priority]["color"].withOpacity(0.08),
                borderRadius: BorderRadius.all(Radius.circular(50.0))),
            child: Row(
              children: [
                Icon(_priorityMap[this.priority]["icon"],
                    color:
                        _priorityMap[this.priority]["color"].withOpacity(0.6)),
                SizedBox(
                  width: 5,
                ),
                Text(_priorityMap[this.priority]["text"],
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _priorityMap[this.priority]["color"]
                          .withOpacity(0.87),
                    )),
              ],
            ),
          )
        : SizedBox();
  }
}
