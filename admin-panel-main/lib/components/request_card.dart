import 'package:admin/Database/RequextDatabase.dart';
import 'package:admin/components/priority.dart';
import 'package:admin/models/request.dart';
import 'package:admin/pages/login.dart';
import 'package:admin/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'donation_log_tile.dart';

class RequestTile extends StatelessWidget {
  RequestTile({this.request});
  Request request;

  String getTopic(String bloodType) {
    String topic;
    topic = bloodType.substring(0, bloodType.length - 1);

    if (bloodType[bloodType.length - 1] == '+') {
      topic = topic + '_p';
    }
    if (bloodType[bloodType.length - 1] == '-') {
      topic = topic + '_n';
    }
    return topic;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: secondary,
      ),
      child: Row(
        children: [
          // Icon(
          //   Icons.inv,
          //   color: accent,
          //   size: 30,
          // ),
          SizedBox(
            width: 10,
          ),
          BloodGroup(
            bloodGrp: this.request.bloodType,
          ),
          SizedBox(
            width: 10,
          ),
          SelectableText(this.request.centerName,
              style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          SizedBox(
            width: 10,
          ),

          PrioChip(priority: request.urgency),

          SizedBox(
            width: 10,
          ),

          SelectableText(getTopic(request.bloodType),
              style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 15)),

          // request.urgency == 0
          //     ? PrioChip(
          //         priority: 0,
          //       )
          //     : SizedBox(),
          Expanded(
            child: SizedBox(),
          ),
          Text(
            this.request.dateTime.day.toString() +
                ' - ' +
                this.request.dateTime.hour.toString() +
                ':' +
                this.request.dateTime.minute.toString(),
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.montserrat(fontSize: 20, color: Colors.white),
            maxLines: 1,
          ),
          SizedBox(
            width: 30,
          ),
          GestureDetector(
            child: Icon(
              Icons.delete,
              color: accent,
            ),
            onTap: () {
              showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        backgroundColor: primary,
                        title: Text(
                          'Confirm Deletion',
                          style: GoogleFonts.montserrat(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        content: DeleteRequest(
                          request: request,
                        ),
                        actions: <Widget>[
                          ActionButton(
                            onPressed: () {
                              Navigator.pop(context, 'Cancel');
                            },
                            enabled: true,
                            text: 'Cancel',
                          ),
                          ActionButton(
                            onPressed: () async {
                              bool temp =
                                  await RequestData.deleteBloodDonationRequest(
                                      name: request.centerName,
                                      bloodType: request.bloodType);
                              Navigator.pop(context, 'Ok');
                            },
                            text: 'Delete',
                            enabled: true,
                          ),
                        ],
                      ));
            },
          ),
          SizedBox(
            width: 30,
          )
        ],
      ),
    );
  }
}

class DeleteRequest extends StatefulWidget {
  const DeleteRequest({
    Key key,
    @required this.request,
  }) : super(key: key);

  final Request request;

  @override
  _DeleteRequestState createState() => _DeleteRequestState();
}

class _DeleteRequestState extends State<DeleteRequest> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        width: 300,
        height: 400,
        child: Column(
          children: [
            Text(
              'Are you sure you want to delete this request?',
              style: GoogleFonts.montserrat(color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                SelectableText(
                  'Center Name : ${widget.request.centerName}',
                  style: GoogleFonts.montserrat(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                SelectableText(
                  'Blood Type : ${widget.request.bloodType}',
                  style: GoogleFonts.montserrat(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                SelectableText(
                  widget.request.dateTime.day.toString() +
                      ' - ' +
                      widget.request.dateTime.hour.toString() +
                      ':' +
                      widget.request.dateTime.minute.toString(),
                  style:
                      GoogleFonts.montserrat(fontSize: 20, color: Colors.white),
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
