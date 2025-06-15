
import '../firebase/real_time_database.dart';

class MemberModel {
  final int index;
  final int jobNo;
  final String nickName;
  final String? pushToken;
  final String position;
  final int? power;

  MemberModel({
    required this.index,
    required this.jobNo,
    required this.nickName,
    required this.pushToken,
    required this.position,
    this.power,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      index: json[keyIndex],
      jobNo: json[keyJobNo],
      nickName: json[keyNickName],
      pushToken: json[keyPushToken],
      position: json[keyPosition],
      power: json[keyPower],
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
    };
  }

  MemberModel copyWith({
    int? index,
    int? jobNo,
    String? nickName,
    String? pushToken,
    String? position,
    int? power,
  }) {
    return MemberModel(
      index: index ?? this.index,
      jobNo: jobNo ?? this.jobNo,
      nickName: nickName ?? this.nickName,
      pushToken: pushToken ?? this.pushToken,
      position: position ?? this.position,
      power: power ?? this.power,
    );
  }
}