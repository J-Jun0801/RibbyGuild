import 'package:libby_guild/data/member.dart';

import '../firebase/real_time_database.dart';

class BoardModel {
  final int index;
  final String type;
  final String title;
  final int maxPartySize;
  final bool isDeadLine;
  final Map<String, MemberModel> participants;

  BoardModel({
    required this.index,
    required this.type,
    required this.title,
    required this.maxPartySize,
    required this.isDeadLine,
    required this.participants,
  });

  factory BoardModel.fromJson(Map<String, dynamic> json) {final raw = json[keyParticipants];
  final Map<String, MemberModel> parsedParticipants = {};

  if (raw is Map) {
    raw.forEach((key, value) {
      if (value is Map) {
        parsedParticipants[key] = MemberModel.fromJson(Map<String, dynamic>.from(value));
      }
    });
  }

    return BoardModel(
      index: json[keyIndex],
      type: json[keyType],
      title: json[keyTitle],
      maxPartySize: json[keyMaxPartySize],
      isDeadLine: json[keyIsDeadLine],
      participants: parsedParticipants,
    );
  }

  Map<String, dynamic> toJson() {
    final participantJson = participants.map((key, value) => MapEntry(key, value.toJson()));

    return {
      'index': index,
      'type': type,
      'title': title,
      'maxPartySize': maxPartySize,
      'isDeadLine': isDeadLine,
      'participant': participantJson,
    };
  }

  static String convertTypeToDesc(String type) {
    if (type == "abyss") {
      return "어비스";
    } else if (type == "raid1") {
      return "레이드 - 글라스기브넨";
    } else if (type == "raid2") {
      return "레이드 - 화이트서큐버스";
    } else {
      return "";
    }
  }

  static String convertType(int index) {
    if (index == 0) {
      return "abyss";
    } else if (index == 1) {
      return "raid1";
    } else if (index == 2) {
      return "raid2";
    } else {
      return "";
    }
  }

  static int convertMaxPartySize(int index) {
    if (index == 0) {
      return 4;
    } else if (index == 1) {
      return 8;
    } else if (index == 2) {
      return 4;
    } else {
      return 4;
    }
  }


}
