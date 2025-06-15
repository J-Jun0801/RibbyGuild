import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:libby_guild/res/colors.dart';

import '../../res/constant_res.dart';

Padding paddingStatefulBuilder({EdgeInsets padding = EdgeInsets.zero, required StatefulBuilder statefulBuilder}) {
  return Padding(padding: padding, child: statefulBuilder);
}

Padding paddingColumn(
    {EdgeInsets padding = EdgeInsets.zero,
    CrossAxisAlignment? crossAxisAlignment,
    MainAxisAlignment? mainAxisAlignment,
    required List<Widget> children}) {
  return Padding(
      padding: padding,
      child: Column(
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
        children: children,
      ));
}

Padding centerColumn({EdgeInsets padding = EdgeInsets.zero, required List<Widget> children}) {
  return Padding(
      padding: padding,
      child: Center(
          child: Column(
        children: children,
      )));
}

Padding paddingRow({EdgeInsets padding = EdgeInsets.zero, required List<Widget> children}) {
  return Padding(
      padding: padding,
      child: Row(
        children: children,
      ));
}

SizedBox widgetSpace({double width = 0, double height = 0}) {
  return SizedBox(width: width, height: height);
}

Padding paddingText(
    {EdgeInsets padding = EdgeInsets.zero,
    AlignmentGeometry alignment = AlignmentDirectional.centerStart,
    required String text,
    required TextStyle style,
    Function? onPressed}) {
  return Padding(
      padding: padding,
      child: GestureDetector(
          onTap: () {
            onPressed?.call();
          },
          child: Align(alignment: alignment, child: Text(text, style: style))));
}

Container line1dpGrayGray2({required BuildContext context}) {
  final colorScheme = Theme.of(context).colorScheme;
  return Container(width: double.infinity, height: 1, color: colorScheme.grayGray2);
}

IgnorePointer shadowContainer(
    {required Widget child, required Color colorBoxShadow, required bool enabled, Function()? onPressed}) {
  const blurRadius = 1.0;
  const spreadRadius = -1.0;
  final realShadowColor = colorBoxShadow.withOpacity(.01);
  return IgnorePointer(
      ignoring: enabled,
      child: GestureDetector(
          onTap: () {
            onPressed?.call();
          },
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: realShadowColor,
                  blurRadius: blurRadius,
                  spreadRadius: spreadRadius,
                  offset: const Offset(0, 0.1)),
              BoxShadow(
                  color: realShadowColor,
                  blurRadius: blurRadius,
                  spreadRadius: spreadRadius,
                  offset: const Offset(0, -0.1)),
              BoxShadow(
                  color: realShadowColor,
                  blurRadius: blurRadius,
                  spreadRadius: spreadRadius,
                  offset: const Offset(0.1, 0)),
              BoxShadow(
                  color: realShadowColor,
                  blurRadius: blurRadius,
                  spreadRadius: spreadRadius,
                  offset: const Offset(-0.1, 0))
            ], borderRadius: BorderRadius.circular(8)),
            child: child,
          )));
}

Widget labelText({required BuildContext context, required String text}) {
  final colorScheme = Theme.of(context).colorScheme;
  final textTheme = Theme.of(context).textTheme;
  return Card(
    color: colorScheme.secondarySkyBlue,
    child: paddingText(
      padding: const EdgeInsets.all(8),
      style: textTheme.labelLarge!,
      text: text,
    ),
  );
}
