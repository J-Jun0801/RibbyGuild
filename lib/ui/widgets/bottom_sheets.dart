import 'package:flutter/material.dart';
import 'package:libby_guild/res/colors.dart';
import 'package:libby_guild/res/text_themes.dart';
import 'package:libby_guild/ui/widgets/widgets.dart';

import '../../res/strings.dart';
import 'buttons.dart';

void showBottomSheet({required BuildContext context, bool? isDismissible, required List<Widget> children}) {
  final colorScheme = Theme.of(context).colorScheme;
  showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: isDismissible ?? true,
      context: context,
      backgroundColor: colorScheme.primaryWhite,
      shape: _shapeBottomSheet(topLeft: 12, topRight: 12),
      builder: (BuildContext context) {
        return basicBottomSheet(
            context: context,
            child: paddingColumn(padding: const EdgeInsets.fromLTRB(20, 28, 20, 28), children: children));
      });
}

void showKeyboardBottomSheet({
  required BuildContext context,
  required StatefulBuilder statefulBuilder,
  double topLeft = 0,
  double topRight = 0,
}) {
  final colorScheme = Theme.of(context).colorScheme;

  showModalBottomSheet(
      enableDrag: false,
      isScrollControlled: true,
      context: context,
      shape: _shapeBottomSheet(topRight: topRight, topLeft: topLeft),
      backgroundColor: colorScheme.primaryWhite,
      builder: (BuildContext context) {
        return statefulBuilder;
      });
  // (context) {
}

RoundedRectangleBorder _shapeBottomSheet(
    {double topLeft = 0, double topRight = 0, double bottomLeft = 0, double bottomRight = 0}) {
  return RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topLeft),
          topRight: Radius.circular(topRight),
          bottomLeft: Radius.circular(bottomLeft),
          bottomRight: Radius.circular(bottomRight)));
}

Padding basicBottomSheet({required BuildContext context, required Widget child}) {
  return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Wrap(children: [
        SizedBox(
          width: double.infinity,
          child: child,
        )
      ]));
}

void showOneButtonBottomSheet({
  required BuildContext context,
  String mainDesc = "",
  String subDesc = "",
  String buttonText = Strings.confirm,
  VoidCallback? onPressed,
  bool? isDismissible = true,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  final textTheme = Theme.of(context).textTheme;

  showBottomSheet(context: context, isDismissible: isDismissible, children: [
    if (mainDesc.isNotEmpty) Text(mainDesc, style: textTheme.subS1Bold.copyWith(color: colorScheme.primaryBlack)),
    if (subDesc.isNotEmpty)
      paddingText(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
          text: subDesc,
          alignment: Alignment.center,
          style: textTheme.bodyB1Regular.copyWith(color: colorScheme.primaryGray2)),
    widgetSpace(height: 28),
    primaryButton(
        context: context,
        buttonText: buttonText,
        onPressed: onPressed ??
            () {
              Navigator.of(context).pop();
            })
  ]);
}

void showTwoButtonBottomSheet({
  required BuildContext context,
  String mainDesc = "",
  String subDesc = "",
  String leftText = Strings.cancel,
  VoidCallback? onLeftPressed,
  String rightText = Strings.confirm,
  VoidCallback? onRightPressed,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  final textTheme = Theme.of(context).textTheme;

  showBottomSheet(context: context, children: [
    if (mainDesc.isNotEmpty) Text(mainDesc, style: textTheme.subS1Bold.copyWith(color: colorScheme.primaryBlack)),
    if (subDesc.isNotEmpty)
      paddingText(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
          alignment: Alignment.center,
          text: subDesc,
          style: textTheme.bodyB1Regular.copyWith(color: colorScheme.primaryGray2)),
    widgetSpace(height: 28),
    Row(children: [
      Flexible(
          flex: 1,
          child: gray6Button(
              context: context,
              buttonText: leftText,
              onPressed: onLeftPressed ??
                  () {
                    Navigator.of(context).pop();
                  })),
      widgetSpace(width: 8),
      Flexible(
          flex: 2,
          child: primaryButton(
              context: context,
              buttonText: rightText,
              onPressed: onRightPressed ??
                  () {
                    Navigator.of(context).pop();
                  }))
    ])
  ]);
}


void showWidgetOneBottomSheet({
  required BuildContext context,
  String mainDesc = "",
  required Widget widget,
  String buttonText = Strings.confirm,
  VoidCallback? onPressed,
  bool? isDismissible = true,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  final textTheme = Theme.of(context).textTheme;

  showBottomSheet(context: context, isDismissible: isDismissible, children: [
    if (mainDesc.isNotEmpty) Text(mainDesc, style: textTheme.subS1Bold.copyWith(color: colorScheme.primaryBlack)),
    widget,
    widgetSpace(height: 28),
    primaryButton(
        context: context,
        buttonText: buttonText,
        onPressed: onPressed ??
                () {
              Navigator.of(context).pop();
            })
  ]);
}

void showWidgetTwoBottomSheet({
  required BuildContext context,
  String mainDesc = "",
  required Widget widget,
  String leftText = Strings.cancel,
  VoidCallback? onLeftPressed,
  String rightText = Strings.confirm,
  VoidCallback? onRightPressed,
  bool? isDismissible = true,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  final textTheme = Theme.of(context).textTheme;

  showBottomSheet(context: context, isDismissible: isDismissible, children: [
    if (mainDesc.isNotEmpty) Text(mainDesc, style: textTheme.subS1Bold.copyWith(color: colorScheme.primaryBlack)),
    widget,
    widgetSpace(height: 28),
    Row(children: [
      Flexible(
          flex: 1,
          child: gray6Button(
              context: context,
              buttonText: leftText,
              onPressed: onLeftPressed ??
                      () {
                    Navigator.of(context).pop();
                  })),
      widgetSpace(width: 8),
      Flexible(
          flex: 2,
          child: primaryButton(
              context: context,
              buttonText: rightText,
              onPressed: onRightPressed ??
                      () {
                    Navigator.of(context).pop();
                  }))
    ])
  ]);
}
