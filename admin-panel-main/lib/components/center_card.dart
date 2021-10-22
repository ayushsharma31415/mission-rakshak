import 'package:admin/components/center_widgets.dart';
import 'package:admin/pages/login.dart';
import 'package:admin/styles/colors.dart';
import 'package:admin/styles/text.dart';
import 'package:flutter/material.dart';
import 'package:admin/models/center.dart';
import 'package:google_fonts/google_fonts.dart';

class CenterTile extends StatefulWidget {
  CenterTile({
    @required this.center,
    @required this.reload,
  });

  final CenterInformation center;
  final Function reload;

  @override
  _CenterTileState createState() => _CenterTileState();
}

class _CenterTileState extends State<CenterTile> {
  final _formKey4 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: EdgeInsets.symmetric(vertical: 2.5, horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: secondary,
      ),
      child: Row(
        children: [
          Icon(
            Icons.room,
            color: accent,
            size: 30,
          ),
          Container(
            width: MediaQuery.of(context).size.width - 250,
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                SelectableText(this.widget.center.name,
                    style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
                SizedBox(
                  width: 10,
                ),
                SelectableText(this.widget.center.email,
                    style: userEmailandNumberStyle),
                SizedBox(
                  width: 30,
                ),
                SelectableText(
                  this.widget.center.number,
                  maxLines: 1,
                  style: userEmailandNumberStyle,
                ),
                SizedBox(
                  width: 30,
                ),
                Flexible(
                  child: Text(
                    this.widget.center.address,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: GoogleFonts.montserrat(
                        fontSize: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          // Expanded(child: SizedBox()),

          Container(
            color: secondary,
            height: 50,
            child: Row(
              children: [
                GestureDetector(
                  child: Icon(
                    Icons.edit,
                    color: verifiedColor,
                  ),
                  onTap: () {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              actions: [
                                ActionButton(
                                    text: "Cancel",
                                    onPressed: () {
                                      Navigator.pop(context, 'Cancel');
                                    },
                                    enabled: true)
                              ],
                              title: Text(
                                'Edit Center Info',
                                style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: primary,
                              content: EditCenterInfo(
                                reload: widget.reload,
                                formKey: _formKey4,
                                center: widget.center,
                              ),
                            ));
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  child: Icon(
                    Icons.delete,
                    color: unverifiedColor,
                  ),
                  onTap: () {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              backgroundColor: primary,
                              title: Text('Confim Deletion',
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              content: DeleteCenter(
                                  formKey: _formKey4, center: widget.center),
                              actions: <Widget>[],
                            ));
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  child: Icon(
                    Icons.open_in_new,
                    color: bloodGrpColor,
                  ),
                  onTap: () {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              backgroundColor: primary,
                              title: Text('Center Information',
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              content: CenterInfoDisplay(center: widget.center),
                              actions: <Widget>[
                                ActionButton(
                                  onPressed: () async {
                                    Navigator.pop(context, 'Ok');
                                  },
                                  text: "Dimiss",
                                  enabled: true,
                                ),
                              ],
                            ));
                  },
                ),
                SizedBox(
                  width: 10,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
