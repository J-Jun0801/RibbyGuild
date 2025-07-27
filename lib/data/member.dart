
import '../firebase/real_time_database.dart';

class MemberModel {
  final int index;
  final int jobNo;
  final String nickName;
  final String? pushToken;
  final String position;
  final int? power;
  final String? time;
  final bool? isAttend;

  MemberModel({
    required this.index,
    required this.jobNo,
    required this.nickName,
    required this.pushToken,
    required this.position,
    this.power,
    this.time,
    this.isAttend
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      index: json[keyIndex],
      jobNo: json[keyJobNo],
      nickName: json[keyNickName],
      pushToken: json[keyPushToken],
      position: json[keyPosition],
      power: json[keyPower],
      time: json[keyTime],
      isAttend: json[keyIsAttend]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      keyIndex: index,
      keyJobNo : jobNo,
      keyNickName: nickName,
      keyPushToken: pushToken,
      keyPosition: position,
      keyPower: power,
      keyTime: time,
      keyIsAttend: isAttend,
    };
  }

  MemberModel copyWith({
    int? index,
    int? jobNo,
    String? nickName,
    String? pushToken,
    String? position,
    int? power,
    String? time,
    bool? isAttend
  }) {
    return MemberModel(
      index: index ?? this.index,
      jobNo: jobNo ?? this.jobNo,
      nickName: nickName ?? this.nickName,
      pushToken: pushToken ?? this.pushToken,
      position: position ?? this.position,
      power: power ?? this.power,
      time: time ?? this.time,
      isAttend: isAttend ?? this.isAttend,
    );
  }
}