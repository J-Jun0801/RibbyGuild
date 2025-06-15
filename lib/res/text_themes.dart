import 'package:flutter/material.dart';

const String _fontFamily = "noto_sans_kr";

///사용법
///'''dart
///Theme.of(context).textTheme.titleH2Bold
///
///Theme.of(context).textTheme.titleH2Bold.copyWith(color: Theme.of(context).colorScheme.primaryMainColor);
///'''
extension AppTextThemes on TextTheme {
  TextStyle get titleH1Bold => const TextStyle(
        fontSize: 32,
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.normal,
      );

  TextStyle get titleH2Black => const TextStyle(
        fontSize: 24,
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w900,
        fontStyle: FontStyle.normal,
      );

  TextStyle get titleH2Bold => const TextStyle(
        fontSize: 24,
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.normal,
      );

  TextStyle get titleH2Medium => const TextStyle(
        fontSize: 24,
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
      );

  TextStyle get titleH2Regular => const TextStyle(
        fontSize: 24,
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
      );

  TextStyle get titleH3Bold => const TextStyle(
        fontSize: 20,
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.normal,
      );

  TextStyle get titleH3Medium => const TextStyle(
        fontSize: 20,
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
      );

  TextStyle get titleH3Regular => const TextStyle(
        fontSize: 20,
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
      );

  TextStyle get subS1Bold => const TextStyle(
        fontSize: 18,
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.normal,
      );

  TextStyle get subS1Medium => const TextStyle(
        fontSize: 18,
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
      );

  TextStyle get subS1Regular => const TextStyle(
        fontSize: 18,
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
      );

  TextStyle get bodyB1Bold => const TextStyle(
        fontSize: 16,
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.normal,
      );

  TextStyle get bodyB1Medium => const TextStyle(
        fontSize: 16,
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
      );

  TextStyle get bodyB1Regular => const TextStyle(
        fontSize: 16,
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
      );

  TextStyle get bodyB2Bold => const TextStyle(
        fontSize: 14,
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.normal,
      );

  TextStyle get bodyB2Medium => const TextStyle(
        fontSize: 14,
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
      );

  TextStyle get bodyB2Regular => const TextStyle(
        fontSize: 14,
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
      );

  TextStyle get captionC1Bold => const TextStyle(
        fontSize: 12,
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.normal,
      );

  TextStyle get captionC1Medium => const TextStyle(
        fontSize: 12,
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
      );

  TextStyle get captionC1Regular => const TextStyle(
        fontSize: 12,
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
      );

  TextStyle get captionC2Bold => const TextStyle(
        fontSize: 10,
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.normal,
      );

  TextStyle get captionC2Medium => const TextStyle(
        fontSize: 10,
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
      );
}
