import 'package:admin/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FormText extends StatefulWidget {
  FormText(
      {Key key,
      @required this.controller,
      @required this.validate,
      @required this.icon,
      this.obscureText,
      this.onChange,
      this.hintText})
      : super(key: key);

  final TextEditingController controller;
  final Function validate;
  String hintText = "";
  final IconData icon;
  bool obscureText = false;
  Function onChange = () {};

  @override
  _FormTextState createState() => _FormTextState();
}

class _FormTextState extends State<FormText> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.obscureText == null ? false : widget.obscureText,
      enableInteractiveSelection: true,
      validator: widget.validate,
      autocorrect: false,
      autofocus: true,
      controller: widget.controller,
      keyboardType: TextInputType.text,
      maxLines: 1,
      textCapitalization: TextCapitalization.words,
      textAlignVertical: TextAlignVertical.center,
      cursorColor: accent,
      style: GoogleFonts.montserrat(color: Colors.white),
      onChanged: widget.onChange,
      decoration: InputDecoration(
        hintText: widget.hintText,
        border: null,
        fillColor: secondary,
        hintStyle: GoogleFonts.montserrat(
          color: searchHelperColor,
        ),
        filled: true,
        prefixIcon: Icon(
          widget.icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
