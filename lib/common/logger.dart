import 'package:logger/logger.dart';

/// StatelessWidget 에서 const 화 하지 못해 전역 instance 로 가져 간다.
/// option 은 통일 한다.
final logger = Logger(printer: SimplePrinter(printTime: true));