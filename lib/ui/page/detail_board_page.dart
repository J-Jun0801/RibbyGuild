import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libby_guild/common/utils.dart';
import 'package:libby_guild/ui/widgets/widgets.dart';

import '../../data/board.dart';
import '../../data/job.dart';
import '../../data/member.dart';
import '../../data/party.dart';
import '../../vm/home_page.dart';
import '../../vm/models/auth.dart';

class DetailBoardPage extends StatefulWidget {
  const DetailBoardPage(this.boardIndex, {super.key});

  final int boardIndex;

  @override
  State<DetailBoardPage> createState() => _DetailBoardPageState();
}

class _DetailBoardPageState extends State<DetailBoardPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeViewModel, AuthState>(
      listener: (context, state) {},
      child: BlocBuilder<HomeViewModel, AuthState>(
        builder: (context, state) {
          final textTheme = Theme.of(context).textTheme;

          final homeViewModel = context.read<HomeViewModel>();
          final boardModel = homeViewModel.state.boards.where((element) => element.index == widget.boardIndex).first;

          final members = boardModel.participants.values.toList();
          final eightPmMembers = members.where((m) => m.time == "오후 8:00").toList();
          final otherMembers = members.where((m) => m.time != "오후 8:00").toList();
          final parties =
              createSmartParties(eightPmMembers, maxPartySize: boardModel.maxPartySize);

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(boardModel.title),
            ),
            body: paddingColumn(
              padding: const EdgeInsets.all(20),
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero, // 필요에 따라 조절
                    children: [
                      if (boardModel.type == "raid1") ...[
                        labelText(context: context, text: "총 인원 : ${boardModel.participants.length}명"),
                        for (final member in boardModel.participants.values.toList()) ...[
                          Text(
                            "${member.nickName} / ${JobUtil.getJobNameByJobNo(member.jobNo)} / ${withComma(member.power!)}",
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                          ),
                          widgetSpace(height: 10)
                        ]
                      ] else ...[

                        for (int i = 0; i < parties.length; i++) _drawParty(i, parties[i]),
                        Column(
                          children: [
                            labelText(context: context, text: "그 외"),
                            widgetSpace(height: 3),
                            paddingColumn(
                              padding: const EdgeInsets.only(left: 20),
                              children: [
                                for (var member in otherMembers) ...[
                                  Text(
                                    "${member.nickName} / ${JobUtil.getJobNameByJobNo(member.jobNo)} / ${withComma(member.power!)} / ${member.time}",
                                    style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  widgetSpace(height: 10)
                                ]
                              ],
                            ),
                            widgetSpace(height: 20),
                          ],
                        )
                      ]
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _drawParty(int index, Party party) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        labelText(context: context, text: "${index + 1} 파티\n총 투력 : ${withComma(party.totalPower)}\n 평균 투력 : ${withComma((party.totalPower/4).round())}"),
        widgetSpace(height: 3),
        paddingColumn(
          padding: const EdgeInsets.only(left: 20),
          children: [
            for (var member in party.members) ...[
              Text(
                "${member.nickName} / ${JobUtil.getJobNameByJobNo(member.jobNo)} / ${withComma(member.power!)}",
                style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
              widgetSpace(height: 10)
            ]
          ],
        ),
        widgetSpace(height: 20),
      ],
    );
  }

  List<Party> createSmartParties(List<MemberModel> members, {int maxPartySize = 4}) {
    members = List.from(members)..sort((a, b) => (b.power ?? 0).compareTo(a.power ?? 0));
    final totalPartyCount = (members.length / maxPartySize).ceil();
    final List<Party> parties = List.generate(totalPartyCount, (_) => Party());

    final healers = members.where((m) => JobUtil.getJobGroupByJobNo(m.jobNo) == 'Healer').toList();
    final tankers = members.where((m) => JobUtil.getJobGroupByJobNo(m.jobNo) == 'Tanker').toList();
    final dealers = members.where((m) => JobUtil.getJobGroupByJobNo(m.jobNo) == 'Dealer').toList();

    void addToLowestPowerParty(MemberModel member) {
      // 인원 꽉 찬 파티는 제외하고 전투력 낮은 파티 찾기
      final availableParties = parties.where((p) => p.canAdd(member, maxPartySize)).toList();
      if (availableParties.isEmpty) return; // 전부 full이면 그냥 무시

      final targetParty = availableParties.reduce((a, b) => a.totalPower < b.totalPower ? a : b);
      targetParty.members.add(member);
    }

    // 힐러 먼저 배치
    for (final healer in healers) {
      addToLowestPowerParty(healer);
    }

    // 탱커 배치
    for (final tanker in tankers) {
      addToLowestPowerParty(tanker);
    }

    // 딜러 2명씩 배치
    int dealerCountPerParty = 2;
    for (int i = 0; i < dealerCountPerParty; i++) {
      final currentDealers = List<MemberModel>.from(dealers);
      for (final dealer in currentDealers) {
        addToLowestPowerParty(dealer);
        dealers.remove(dealer);
        if (dealers.isEmpty) break;
      }
    }

    // 남은 애들 (딜러/힐러/탱커)
    final remainingMembers = [
      ...dealers,
    ];

    for (final member in remainingMembers) {
      addToLowestPowerParty(member);
    }

    return parties;
  }



// List<Party> createSmartParties(List<MemberModel> members, {int maxPartySize = 4}) {
  //   // 전투력 높은 순으로 정렬
  //   members = List.from(members)..sort((a, b) => (b.power ?? 0).compareTo(a.power ?? 0));
  //
  //   final totalPartyCount = (members.length / maxPartySize).ceil();
  //   final List<Party> parties = List.generate(totalPartyCount, (_) => Party());
  //
  //   int partyIndex = 0;
  //
  //   // snake 방향
  //   bool forward = true;
  //
  //   // 직업별 나누기
  //   final healers = members.where((m) => JobUtil.getJobGroupByJobNo(m.jobNo) == 'Healer').toList();
  //   final tankers = members.where((m) => JobUtil.getJobGroupByJobNo(m.jobNo) == 'Tanker').toList();
  //   final dealers = members.where((m) => JobUtil.getJobGroupByJobNo(m.jobNo) == 'Dealer').toList();
  //
  //   // 각 파티 최소 힐1
  //   for (var i = 0; i < totalPartyCount; i++) {
  //     if (healers.isNotEmpty) {
  //       parties[i].members.add(healers.removeAt(0));
  //     }
  //   }
  //
  //   // 각 파티 최소 탱1 (없으면 힐러로)
  //   for (var i = 0; i < totalPartyCount; i++) {
  //     if (tankers.isNotEmpty) {
  //       parties[i].members.add(tankers.removeAt(0));
  //     } else if (healers.isNotEmpty) {
  //       parties[i].members.add(healers.removeAt(0));
  //     }
  //   }
  //
  //   // 각 파티 최소 딜러 2명
  //   for (var j = 0; j < 2; j++) {
  //     for (var i = 0; i < totalPartyCount; i++) {
  //       if (dealers.isNotEmpty) {
  //         parties[i].members.add(dealers.removeAt(0));
  //       }
  //     }
  //   }
  //
  //   // 남은 인원 (힐/탱/딜 전부) 다시 전투력 높은 순으로 snake로 배분
  //   final remainingMembers = [
  //     ...healers,
  //     ...tankers,
  //     ...dealers,
  //   ];
  //
  //   while (remainingMembers.isNotEmpty) {
  //     final member = remainingMembers.removeAt(0);
  //
  //     while (!parties[partyIndex].canAdd(member, maxPartySize)) {
  //       partyIndex += (forward ? 1 : -1);
  //
  //       if (partyIndex >= totalPartyCount) {
  //         partyIndex = totalPartyCount - 1;
  //         forward = false;
  //       } else if (partyIndex < 0) {
  //         partyIndex = 0;
  //         forward = true;
  //       }
  //     }
  //
  //     parties[partyIndex].members.add(member);
  //   }
  //
  //   return parties;
  // }


}
