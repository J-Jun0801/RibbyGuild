import 'package:equatable/equatable.dart';
import 'package:libby_guild/data/board.dart';
import 'package:libby_guild/data/member.dart';

enum AuthStatus { initial, authed, authFail, authNotMatch }

class AuthState extends Equatable {
  final MemberModel? memberModel;
  final List<BoardModel> boards;
  final AuthStatus authStatus;

  const AuthState({
    this.memberModel,
    required this.boards,
    required this.authStatus,
  });

  @override
  List<Object?> get props => [memberModel, boards, authStatus];

  AuthState copyWith({
    MemberModel? memberModel,
    List<BoardModel>? boards,
    AuthStatus? authStatus,
  }) {
    return AuthState(
        memberModel: memberModel ?? this.memberModel,
        boards: boards ?? this.boards,
        authStatus: authStatus ?? this.authStatus);
  }
}
