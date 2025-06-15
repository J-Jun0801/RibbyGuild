import 'package:flutter/material.dart';
import 'package:libby_guild/res/colors.dart';
import 'package:libby_guild/res/text_themes.dart';

void showSnackBar(BuildContext context, String content) {
  final colorScheme = Theme.of(context).colorScheme;
  final textTheme = Theme.of(context).textTheme;

  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      elevation: 6.0,
      backgroundColor: colorScheme.opacity70BlueToast,
      behavior: SnackBarBehavior.floating,
      content: Row(children: [
        Text(
          content,
          style: textTheme.bodyB2Medium.copyWith(color: colorScheme.primaryWhite),
        )
      ])));
}