import 'package:flutter/material.dart';

class FittedText extends StatelessWidget {
  const FittedText(
    this.text, {
    super.key,
    this.style,
    this.boxFit = BoxFit.scaleDown,
    this.alignment,
    this.emptyText,
    this.textAlign,
  });

  final String text;
  final String? emptyText;
  final TextStyle? style;
  final BoxFit boxFit;
  final AlignmentGeometry? alignment;
  final TextAlign? textAlign;
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: boxFit,
      alignment: alignment ?? Alignment.center,
      child: Text(
        text.isEmpty ? (emptyText ?? 'no-value') : text,
        style: style,
        textAlign: textAlign,
      ),
    );
  }
}
