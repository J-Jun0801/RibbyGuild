import 'package:flutter/material.dart';
import 'package:libby_guild/res/colors.dart';
import 'package:libby_guild/res/text_themes.dart';

IgnorePointer primaryButton({
  required BuildContext context,
  required String buttonText,
  double? width,
  double? height,
  VoidCallback? onPressed,
  bool isEnabled = true,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  final textTheme = Theme.of(context).textTheme;

  return IgnorePointer(
      ignoring: !isEnabled,
      child: SizedBox(
          width: width ?? double.infinity,
          height: height ?? 48,
          child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: isEnabled ? Theme.of(context).colorScheme.primary : colorScheme.grayGray5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: Text(buttonText, style: textTheme.bodyB1Medium.copyWith(color: colorScheme.primaryWhite)))));
}

IgnorePointer gray6Button({
  required BuildContext context,
  required String buttonText,
  VoidCallback? onPressed,
  bool isEnabled = true,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  final textTheme = Theme.of(context).textTheme;

  return IgnorePointer(
      ignoring: !isEnabled,
      child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: isEnabled ? colorScheme.grayGray6 : colorScheme.grayGray5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: Text(buttonText,
                  style: textTheme.bodyB1Medium.copyWith(
                    color: colorScheme.primaryWhite,
                  )))));
}
