import 'package:flutter/material.dart';

/// class [TextWidget] is a custom [Text] widget.
/// It takes in a [label] which is the text to be shown.
class TextWidget extends StatelessWidget {
  const TextWidget(
      {Key? key,
      required this.label,
      this.fontSize = 20,
      this.color,
      this.fontWeight})
      : super(key: key);

  /// The text to be shown
  final String label;

  /// The font size of the text
  final double fontSize;

  /// The color of the text
  final Color? color;

  /// The font weight of the text
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      // textAlign: TextAlign.justify,
      style: TextStyle(
        color: color ?? Colors.white,
        fontSize: fontSize,
        fontWeight: fontWeight ?? FontWeight.w300,
      ),
    );
  }
}
