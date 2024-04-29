import 'package:flutter/material.dart';

class buttonWidget extends StatelessWidget {
  buttonWidget(
      {super.key, required this.label,
      required this.colour,
      required this.onPressed,
      required this.textstyle,
      required RoundedRectangleBorder shape,
      required EdgeInsets padding});
  String label;
  Color colour;
  TextStyle textstyle;
  VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            label,
            style: textstyle,
          ),
        ),
      ),
    );
  }
}
