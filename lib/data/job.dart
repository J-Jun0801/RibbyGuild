abstract class JobInfo {
  int get jobNo;
  String get koreanName;
}

enum Dealer implements JobInfo{
  greatSwordWarrior(11, "대검 전사"),
  swordsMan(12, "검술사"),
  archer(20, "궁수"),
  crossBowMan(21, "석궁 사수"),
  longBowMan(22, "장궁병"),
  mage(30, "마법사"),
  fireMage(32, "화염 술사"),
  electMage(33, "전격 술사"),
  dancer(51, "댄서"),
  minstrel(52, "악사"),
  rogue(60, "도적"),
  fighter(61, "격투가"),
  dualBlade(62, "듀얼 블레이드"),
  ;

  @override
  final int jobNo;
  @override
  final String koreanName;

  const Dealer(this.jobNo, this.koreanName);
}

enum Healer  implements JobInfo{
  healer(40, "힐러"),
  priest(41, "사제"),
  bard(50, "음유 시인"),
  ;

  @override
  final int jobNo;
  @override
  final String koreanName;

  const Healer(this.jobNo, this.koreanName);
}

enum Tanker  implements JobInfo{
  warrior(10, "전사"),
  iceMage(33, "빙결 술사"),
  monk(42, "수도사"),
  ;

  @override
  final int jobNo;
  @override
  final String koreanName;

  const Tanker(this.jobNo, this.koreanName);
}

class JobUtil {
  static String getJobGroupByJobNo(int jobNo) {
    if (Dealer.values.any((e) => e.jobNo == jobNo)) return 'Dealer';
    if (Healer.values.any((e) => e.jobNo == jobNo)) return 'Healer';
    if (Tanker.values.any((e) => e.jobNo == jobNo)) return 'Tanker';
    return 'Unknown';
  }

  static String getJobNameByJobNo(int jobNo) {
    final List<JobInfo> allJobs = [
      ...Dealer.values,
      ...Healer.values,
      ...Tanker.values,
    ];

    for (final job in allJobs) {
      if (job.jobNo == jobNo) {
        return job.koreanName;
      }
    }

    return "";
  }
}
