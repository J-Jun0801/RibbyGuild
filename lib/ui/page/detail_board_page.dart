import 'dart:math';

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
          final homeViewModel = context.read<HomeViewModel>();
          final boardModel = homeViewModel.state.boards.where((element) => element.index == widget.boardIndex).first;
          final parties =
              createSmartParties(boardModel.participants.values.toList(), maxPartySize: boardModel.maxPartySize);
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(boardModel.title),
            ),
            body: paddingColumn(
              padding: const EdgeInsets.all(20),
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      if (boardModel.type == "raid1") ...[
                        labelText(context: context, text: "총 인원 : ${boardModel.participants.length}명 "),
                        for (final member in boardModel.participants.values.toList()) ...[
                          Text(
                            "${member.nickName} / ${JobUtil.getJobNameByJobNo(member.jobNo)} / ${withComma(member.power!)}",
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                          ),
                          widgetSpace(height: 10)
                        ]
                      ] else ...[
                        for (int i = 0; i < parties.length; i++) _drawParty(i, parties[i])
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
        labelText(context: context, text: "${index + 1} 파티 (총 투력 : ${withComma(party.totalPower)})"),
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
    // 전투력 높은 순으로 정렬
    members = List.from(members)..sort((a, b) => (b.power ?? 0).compareTo(a.power ?? 0));

    // 직업별로 나누기
    final healers = members.where((m) => JobUtil.getJobGroupByJobNo(m.jobNo) == 'Healer').toList();
    final tankers = members.where((m) => JobUtil.getJobGroupByJobNo(m.jobNo) == 'Tanker').toList();
    final dealers = members.where((m) => JobUtil.getJobGroupByJobNo(m.jobNo) == 'Dealer').toList();

    final totalMemberCount = members.length;
    final int totalPartyCount = (totalMemberCount / maxPartySize).ceil(); // ex. 9명 -> 3파티
    final List<Party> parties = List.generate(totalPartyCount, (_) => Party());

    // 1. 힐러 배정 (파티 순서대로)
    int partyIndex = 0;
    for (final healer in healers) {
      while (parties[partyIndex % totalPartyCount].members.length >= maxPartySize) {
        partyIndex++;
      }
      parties[partyIndex % totalPartyCount].members.add(healer);
      partyIndex++;
    }

    // 2. 탱커 배정
    partyIndex = 0;
    for (final tanker in tankers) {
      while (parties[partyIndex % totalPartyCount].members.length >= maxPartySize) {
        partyIndex++;
      }
      parties[partyIndex % totalPartyCount].members.add(tanker);
      partyIndex++;
    }

    // 3. 딜러는 앞에서부터 가득 채우기 방식
    partyIndex = 0;
    for (final dealer in dealers) {
      // 파티 인원 maxPartySize 넘으면 다음 파티로
      while (partyIndex < totalPartyCount && parties[partyIndex].members.length >= maxPartySize) {
        partyIndex++;
      }

      if (partyIndex < totalPartyCount) {
        parties[partyIndex].members.add(dealer);
      }
    }

    return parties;
  }

  // 유틸: 리스트 쪼개기
  List<List<T>> _chunkList<T>(List<T> list, int size) {
    List<List<T>> chunks = [];
    for (int i = 0; i < list.length; i += size) {
      chunks.add(list.sublist(i, min(i + size, list.length)));
    }
    return chunks;
  }
}
