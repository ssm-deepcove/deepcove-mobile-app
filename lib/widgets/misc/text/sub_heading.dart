import 'package:discover_deep_cove/util/screen.dart';
import 'package:flutter/material.dart';

class SubHeading extends StatelessWidget {
  final String text;
  final TextAlign align;

  ///Returns a custom [Text] widget for accessing headline theme
  ///and has an optional alignment property.
  SubHeading(this.text, {this.align = TextAlign.center});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.fade,
      style: TextStyle(
        fontSize: Screen.width(context) <= 350 ? 20 : 25,
        color: Colors.white,
      ),
      textAlign: align,
    );
  }
}