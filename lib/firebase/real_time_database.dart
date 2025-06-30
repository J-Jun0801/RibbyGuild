import 'package:firebase_database/firebase_database.dart';
import 'package:libby_guild/data/member.dart';

import '../data/board.dart';

final dbRef = FirebaseDatabase.instance.ref();
const _keyMember = "member";
const _keyBoard = "board";

const keyIndex = "index";
const keyJobNo = "jobNo";
const keyNickName = "nickName";
const keyPushToken = "pushToken";
const keyPosition = "position";
const keyPower = "power";
const keyTime = "time";

const keyType = "type";
const keyTitle = "title";
const keyMaxPartySize = "maxPartySize";
const keyIsDeadLine = "isDeadLine";
const keyParticipants = "participants";

Future<void> get() async {
  final snapshot = await dbRef.child('').get();

  if (snapshot.exists) {
    print('읽은 데이터: ${snapshot.value}');
  } else {
    print('데이터가 존재하지 않습니다.');
  }
}

Future<MemberModel?> findUserByNickname(String nickname) async {
  final ref = FirebaseDatabase.instance.ref(_keyMember);
  final snapshot = await ref.get();

  if (snapshot.exists) {
    final Map<String, dynamic> members =
    Map<String, dynamic>.from(snapshot.value as Map);

    for (final entry in members.entries) {
      final userData = Map<String, dynamic>.from(entry.value);
      if (userData[keyNickName] == nickname) {
        return MemberModel.fromJson(userData);
      }
    }
  }

  return null; // 못 찾은 경우
}


Future<List<String>> getMemberTokens() async {
  final ref = FirebaseDatabase.instance.ref(_keyMember);
  final snapshot = await ref.get();

  final Map<String, dynamic> members = Map<String, dynamic>.from(snapshot.value as Map);
  List<String> tokensWithNicknames = [];

  for (final entry in members.entries) {
    final userData = Map<String, dynamic>.from(entry.value);
    final token = userData[keyPushToken];

    if (token != null && token.toString().isNotEmpty) {
      tokensWithNicknames.add(token);
    }
  }

  return tokensWithNicknames; // 못 찾은 경우
}

Future<void> updateSingleUser(int index, String? pushToken) async {
  final ref = FirebaseDatabase.instance.ref("member/user$index");

  await ref.update({
    keyPushToken: pushToken,
  });
}


Future<List<BoardModel>> getBoardList() async {
  final ref = FirebaseDatabase.instance.ref(_keyBoard);
  final snapshot = await ref.get();

  if (snapshot.exists) {
    final Map<String, dynamic> boards = Map<String, dynamic>.from(snapshot.value as Map);
    final List<BoardModel> boardList = [];

    for (final entry in boards.entries) {
      final boardData = Map<String, dynamic>.from(entry.value);
      final boardModel = BoardModel.fromJson(boardData);
      boardList.add(boardModel);
    }

    return boardList.reversed.toList();
  } else {
    return [];
  }
}

Future<void> addBoard(BoardModel board) async {
  final ref = FirebaseDatabase.instance.ref("board/board${board.index}");
  await ref.set(board.toJson());
}

Future<void> updateParticipants(BoardModel board, MemberModel memberModel) async {
  final ref = FirebaseDatabase.instance.ref("board/board${board.index}/participants/");
  await ref.update({
    "user${memberModel.index}": memberModel.toJson(),
  });
}

Future<void> removeParticipants(BoardModel board, MemberModel memberModel) async {
  final ref = FirebaseDatabase.instance.ref("board/board${board.index}/participants/");
  await ref.child("user${memberModel.index}").remove();
}