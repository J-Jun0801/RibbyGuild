import 'dart:html';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:libby_guild/common/utils.dart';
import 'package:libby_guild/firebase/real_time_database.dart';
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
          final attendMembers = members.where((m) => m.isAttend!).toList();
          final anotherAttendMembers = members.where((m) => !m.isAttend!).toList();

          final eightPmMembers = attendMembers.where((m) => m.time == "오후 9:00").toList();
          final partyFixMembers = eightPmMembers.where((m) => m.isPartyFix == null || m.isPartyFix == true).toList();
          final partyNotFixMembers = eightPmMembers.where((m) => m.isPartyFix == false).toList();

          final pm9AfterMembers = attendMembers.where((m) => m.time != "오후 9:00").toList();
          final parties = createSmartParties(partyFixMembers, maxPartySize: boardModel.maxPartySize);

          return Scaffold(
            floatingActionButton: homeViewModel.isAdmin()
                ? SpeedDial(
                    icon: Icons.add,
                    activeIcon: Icons.close,
                    backgroundColor: Colors.indigoAccent,
                    children: [
                      SpeedDialChild(
                        child: const Icon(Icons.lock_clock_outlined),
                        label: '컨텐츠 마감',
                        onTap: () async {
                          final boardList = await getBoardList();
                          print(">>>>>>>>>>>>>>>>> ${widget.boardIndex}");
                          final board = boardList.where((element) => element.getIndex() == widget.boardIndex).first;
                          board.participants.values.forEachIndexed((index, element) {
                            final modifyMemberModel = element.copyWith(isPartyFix: true);
                            updateParticipants(board, modifyMemberModel);
                          });

                          final homeViewModel = context.read<HomeViewModel>();
                          homeViewModel.initialize();
                        },
                      ),
                    ],
                  )
                : null,
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(boardModel.title),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    // 이벤트 넣기
                    final homeViewModel = context.read<HomeViewModel>();
                    homeViewModel.initialize();
                  },
                ),
              ],
            ),
            body: paddingColumn(
              padding: const EdgeInsets.all(20),
              children: [
                Expanded(
                  child: ListView(
                      padding: EdgeInsets.zero, // 필요에 따라 조절
                      children: [
                        for (int i = 0; i < parties.length; i++) _drawParty(i, parties[i], boardModel.maxPartySize),
                        Column(
                          children: [
                            labelText(context: context, text: "21시 그외 인원"),
                            widgetSpace(height: 3),
                            paddingColumn(
                              padding: const EdgeInsets.only(left: 20),
                              children: [
                                for (var member in partyNotFixMembers) ...[
                                  Text(
                                    "${member.nickName} / ${JobUtil.getJobNameByJobNo(member.jobNo)} / ${withComma(member.power!)} / ${member.time}",
                                    style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  widgetSpace(height: 10)
                                ]
                              ],
                            ),
                            widgetSpace(height: 20),
                            labelText(context: context, text: "21시 이후 참여 하시는 분들"),
                            widgetSpace(height: 3),
                            paddingColumn(
                              padding: const EdgeInsets.only(left: 20),
                              children: [
                                for (var member in pm9AfterMembers) ...[
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
                        ),
                        Column(
                          children: [
                            labelText(context: context, text: "미참"),
                            widgetSpace(height: 3),
                            paddingColumn(
                              padding: const EdgeInsets.only(left: 20),
                              children: [
                                for (var member in anotherAttendMembers) ...[
                                  Text(
                                    "${member.nickName} / ${JobUtil.getJobNameByJobNo(member.jobNo)}",
                                    style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  widgetSpace(height: 10)
                                ]
                              ],
                            ),
                            widgetSpace(height: 20),
                          ],
                        )
                      ]),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _drawParty(int index, Party party, int maxPartySize) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        labelText(
            context: context,
            text:
                "${index + 1} 파티\n총 투력 : ${withComma(party.totalPower)}\n 평균 투력 : ${withComma((party.totalPower / maxPartySize).round())}"),
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
}
