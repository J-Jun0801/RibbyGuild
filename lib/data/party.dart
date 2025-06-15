import 'job.dart';
import 'member.dart';

class Party {
  List<MemberModel> members = [];

  int get totalPower => members.fold(0, (sum, m) => sum + (m.power ?? 0));

  bool get hasHealer => members.any((m) => JobUtil.getJobGroupByJobNo(m.jobNo) == 'Healer');
  bool get hasTanker => members.any((m) => JobUtil.getJobGroupByJobNo(m.jobNo) == 'Tanker');

  bool canAdd(MemberModel member, int maxSize) {
    return members.length < maxSize;
  }
}
