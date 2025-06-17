import 'package:flutter/material.dart';

///사용법
///'''dart
///Theme.of(context).colorScheme.primaryMainColor;
///'''
extension AppColors on ColorScheme {
  ///Primary colours
  ///서비스의 브랜드 컬러를 기반으로 한 앱 서비스의 메인 컬러입니다. Grey, Black은 Title 과 Sub Text에 사용되는 주 컬러입니다.

  get primarySubMain => const Color(0xffFF4B13);

  get primaryColor => Colors.indigoAccent;

  get primaryGray1 => const Color(0xff6f767b);

  get primaryGray2 => const Color(0xff939BA1);

  get primaryGray3 => const Color(0xffA7B0B5);

  get primaryGray4 => const Color(0xffC3CAD0);

  get primaryBlack => const Color(0xff231F20);

  get primaryBlueBlack => const Color(0xff343842);

  get primaryCardBlue => const Color(0xff1E2A39);

  get primaryWhite => const Color(0xffffffff);

  ///Secondary colours
  ///기능, 강조 등의 목적으로 보조적으로 사용하는 컬러입니다.
  get secondaryRed => const Color(0xffF24147);

  get secondaryOrange => const Color(0xffFDAC34);

  get secondaryLightGreen => const Color(0xff3AD38F);

  get secondarySkyBlue => const Color(0xff81B1ED);

  ///Shade of Grays
  ///회색조 컬러를 정의합니다. 앱 페이지에 적용하는 Background 및, Border, Line 컬러에 적용합니다.
  get grayGray1 => const Color(0xffDCE0E2);

  get grayGray2 => const Color(0xffEAEFF1);

  get grayGray3 => const Color(0xffF3F6F8);

  get grayGray4 => const Color(0xffF8F9FA);

  get grayGray5 => const Color(0xffCED4DA);

  get grayGray6 => const Color(0xff868E96);

  get grayGray8 => const Color(0xfff5f5f5);

  ///Opacity
  ///Opacity 적용 예시입니다.
  ///
  /// 100% - FF
  /// 90% - E6
  /// 80% - CC
  /// 70% - B3
  /// 60% - 99
  /// 50% - 80
  /// 40% - 66
  /// 30% - 4D
  /// 20% - 33
  /// 15% - 1E
  /// 10% - 1A
  /// 5% - 0D
  get opacity50Black => const Color(0x80000000);

  get opacity30Black => const Color(0x4D000000);

  get opacity15Black => const Color(0x1E000000);

  get opacity8Black => const Color(0x14000000);

  get opacity8White => const Color(0x14ffffff);

  get opacity70BlueToast => const Color(0xB33F505F);

  get opacity5Orange => const Color(0x0DFF4B13);

  get opacity10SecondaryOrange => const Color(0x1AFDAC34);

  get opacity30SecondaryOrange => const Color(0x4DFDAC34);

  get opacity5SecondaryOrange => const Color(0x0DFDAC34);

  get opacity85White => const Color(0xD9FFFFFF);

  get opacity10SecondaryLightGreen => const Color(0x1A3AD38F);

  get opacity10SecondaryRed => const Color(0x1AF24147);

  get opacity10PrimaryCarsuriColor => const Color(0x1A0064E1);

  get opacity10PrimaryGray2 => const Color(0x1A939BA1);

  get opacity50GrayGray2 => const Color(0x80EAEFF1);
}
