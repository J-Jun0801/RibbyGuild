import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libby_guild/common/local_storage.dart';
import 'package:libby_guild/firebase/firebase_cloud_messing.dart';
import 'package:libby_guild/firebase/real_time_database.dart';
import 'package:libby_guild/main.dart';
import 'package:libby_guild/vm/models/auth.dart';

import '../common/logger.dart';
import '../data/member.dart';

class HomeViewModel extends Cubit<AuthState> {
  HomeViewModel() : super(const AuthState(boards: [], authStatus: AuthStatus.initial)) {
    logger.d('Constructed $this');
  }

  Future<void> initialize() async {
    final nickName = localStorage.getString(keyId);
    if (nickName == null) {
      emit(state.copyWith(authStatus: AuthStatus.authFail));
    } else {
      findUserByNickname(nickName).then((value) async {
        if (value == null) {
          emit(state.copyWith(authStatus: AuthStatus.authFail));
        } else {
          final list = await getBoardList();
          emit(state.copyWith(memberModel: value, boards: list, authStatus: AuthStatus.authed));
        }
      });
    }
  }

  bool isAdmin() {
    if (state.memberModel?.position == "admin") {
      return true;
    } else {
      return false;
    }
  }

  void saveNickName(String nickName) {
    findUserByNickname(nickName).then((memberModel) {
      if (memberModel == null) {
        emit(state.copyWith(authStatus: AuthStatus.authNotMatch));
      } else {
        localStorage.setString(keyId, memberModel.nickName);
        _updateUserPushTokenByIndex(memberModel);
      }
    });
  }

  Future<void> _updateUserPushTokenByIndex(MemberModel memberModel) async {
    getFirebaseToken().then((value) async {
      await updateSingleUser(memberModel.index, value);
      final list = await getBoardList();
      emit(state.copyWith(memberModel: memberModel, boards: list, authStatus: AuthStatus.authed));
    });
  }
}
