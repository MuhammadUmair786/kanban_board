import 'package:flutter/material.dart';

import '../constants/extras.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton(
      {super.key,
      required this.label,
      required this.onPressed,
      this.backgroundColor,
      this.width = 240,
      this.height = 40,
      this.icon,
      this.textColor});
  final String label;
  final Function() onPressed;
  final Color? backgroundColor;
  final double width;
  final double height;
  final Widget? icon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        fixedSize: Size(width, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      onPressed: onPressed,
      child: icon == null
          ? FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: TextStyle(color: textColor ?? Colors.white),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon!,
                const SizedBox(width: 5),
                Text(
                  label,
                  style: TextStyle(color: textColor ?? Colors.white),
                )
              ],
            ),
    );
  }
}

class CustomOutlineButton extends StatelessWidget {
  const CustomOutlineButton(
      {super.key,
      required this.label,
      required this.onPressed,
      this.borderColor,
      this.width = 240,
      this.height = 47,
      this.icon});
  final String label;
  final Function()? onPressed;
  final Color? borderColor;
  final double width;
  final Widget? icon;
  final double height;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        // backgroundColor: backgroundColor,
        fixedSize: Size(width, height),
        side: BorderSide(
          color: borderColor ?? const Color(0xFF000000),
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      onPressed: onPressed,
      child: icon == null
          ? FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: TextStyle(color: borderColor, fontSize: 16),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon!,
                const SizedBox(width: 5),
                Text(
                  label,
                  style: TextStyle(color: borderColor),
                )
              ],
            ),
    );
  }
}
