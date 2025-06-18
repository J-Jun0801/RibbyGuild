import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libby_guild/common/local_storage.dart';
import 'package:libby_guild/data/board.dart';
import 'package:libby_guild/data/member.dart';
import 'package:libby_guild/firebase/firebase_cloud_messing.dart';
import 'package:libby_guild/firebase/real_time_database.dart';
import 'package:libby_guild/res/colors.dart';
import 'package:libby_guild/res/constant_res.dart';
import 'package:libby_guild/res/text_themes.dart';
import 'package:libby_guild/main.dart';
import 'package:libby_guild/ui/page/detail_board_page.dart';
import 'package:libby_guild/ui/widgets/bottom_sheets.dart';
import 'package:libby_guild/ui/widgets/buttons.dart';
import 'package:libby_guild/ui/widgets/global_ui.dart';
import 'package:libby_guild/ui/widgets/text_field.dart';
import 'package:libby_guild/vm/models/auth.dart';

import '../../res/strings.dart';
import '../../vm/home_page.dart';
import '../widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _nickNameTextEditingController = TextEditingController();
  final _powerTextEditingController = TextEditingController();
  final List<String> labels = ["어비스", "레이드-글라스기브넨", "레이드-화이트서큐버스"];
  final List<String> attendLabels = ["참석", "미참석"];
  int selectedIndex = 0;
  int attendSelectedIndex = 0;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    context.read<HomeViewModel>().initialize();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeViewModel, AuthState>(
      listener: (context, state) {
        if (state.authStatus == AuthStatus.authNotMatch) {
          showSnackBar(context, Strings.descNotMatchLibbyGuild);
        }
      },
      child: BlocBuilder<HomeViewModel, AuthState>(
        builder: (context, state) {
          final homeViewModel = context.read<HomeViewModel>();
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text("${Strings.title}(${state.memberModel?.nickName ?? ""})"),
            ),
            floatingActionButton: homeViewModel.isAdmin()
                ? FloatingActionButton(
                    onPressed: () {
                      _makeBoard(context, state);
                    },
                    child: const Icon(Icons.add),
                  )
                : null,
            body:
                state.authStatus == AuthStatus.authed ? _showAuthed(state.boards, state.memberModel!) : _showNotAuth(),
          );
        },
      ),
    );
  }

  Widget _showNotAuth() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return paddingColumn(
      padding: const EdgeInsets.all(20),
      children: [
        widgetSpace(height: 30),
        Text(Strings.descLibbyGuild, style: textTheme.titleLarge),
        widgetSpace(height: 30),
        CommonTextField(
          hintText: Strings.hintNickName,
          textEditingController: _nickNameTextEditingController,
          valueChanged: (text) {
            setState(() {});
          },
        ),
        widgetSpace(height: 12),
        primaryButton(
            context: context,
            buttonText: Strings.confirm,
            isEnabled: _nickNameTextEditingController.text.isNotEmpty,
            onPressed: () {
              HomeViewModel homeViewModel = context.read<HomeViewModel>();
              homeViewModel.saveNickName(_nickNameTextEditingController.text);
            })
      ],
    );
  }

  Widget _showAuthed(List<BoardModel> boards, MemberModel memberModel) {
    return ListView.builder(
        itemCount: boards.length,
        itemBuilder: (context, index) {
          final board = boards[index];
          return _makeCard(board, memberModel);
        });
  }

  Widget _makeCard(BoardModel boardModel, MemberModel memberModel) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        showWidgetTwoBottomSheet(
          context: context,
          widget: _makePowerContent(),
          leftText: "파티보기",
          onLeftPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DetailBoardPage(boardModel.index)),
            );
          },
          rightText: "투표하기",
          onRightPressed: () async {
            if (attendSelectedIndex == 0) {
              final copyMemberModel = memberModel.copyWith(power: int.parse(_powerTextEditingController.text));
              await updateParticipants(boardModel, copyMemberModel);
            } else {
              await removeParticipants(boardModel, memberModel);
            }
            await context.read<HomeViewModel>().initialize();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DetailBoardPage(boardModel.index)),
            );
          },
        );
      },
      child: Container(
        width: double.infinity,
        height: 250,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  child: Image.asset('${ConstantRes.pathAssetsPng}${boardModel.type}.png', width: 300, height: 300),
                ),
                paddingColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  padding: const EdgeInsets.all(10),
                  children: [
                    Row(
                      children: [
                        labelText(context: context, text: BoardModel.convertTypeToDesc(boardModel.type)),
                        widgetSpace(width: 6),
                        if (boardModel.isDeadLine) ...[
                          labelText(context: context, text: "마감"),
                        ]
                      ],
                    ),
                    widgetSpace(height: 8),
                    Text(
                      boardModel.title,
                      style:
                          textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primaryColor),
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }

  Future<void> _makeBoard(
    BuildContext context,
    AuthState state,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      // 기본값
      firstDate: DateTime(2020),
      // 선택 가능한 최소 날짜
      lastDate: DateTime(2030),
      // 선택 가능한 최대 날짜
      locale: const Locale('ko', 'KR'), // 한국어 설정 (선택)
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;

        showWidgetOneBottomSheet(
            context: context,
            widget: _makeBoardContent(selectedDate!),
            onPressed: () async {
              final type = BoardModel.convertType(selectedIndex);
              final title = "${selectedDate!.month}월 ${selectedDate!.day}일 ${BoardModel.convertTypeToDesc(type)}";

              final insertBoardModel = BoardModel(
                index: state.boards.length + 1,
                type: type,
                title: title,
                maxPartySize: BoardModel.convertMaxPartySize(selectedIndex),
                isDeadLine: false,
                participants: {},
              );

              await addBoard(insertBoardModel);
              context.read<HomeViewModel>().initialize();
              // sendPushToMultipleUsers(pushTokens: await getMemberTokens(), title: title, body: "$title 등록되었습니다.");
            });
      });
    }
  }

  Widget _makeBoardContent(DateTime selectedDate) {
    return StatefulBuilder(builder: (context, bottomState) {
      return Column(
        children: [
          ToggleButtons(
            borderRadius: BorderRadius.circular(12),
            borderWidth: 2,
            borderColor: Colors.indigoAccent.shade200,
            selectedBorderColor: Colors.indigoAccent,
            fillColor: Colors.indigoAccent,
            color: Colors.black,
            selectedColor: Colors.white,
            isSelected: List.generate(3, (i) => i == selectedIndex),
            onPressed: (int index) {
              bottomState(() {
                selectedIndex = index;
              });
            },
            children: labels
                .map((label) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(label),
                    ))
                .toList(),
          ),
          widgetSpace(height: 10),
          Text("${selectedDate.month}월 ${selectedDate.day}일",style:Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),)
        ],
      );
    });
  }

  Widget _makePowerContent() {
    return StatefulBuilder(builder: (context, bottomState) {
      return Column(
        children: [
          Text(
            "전투력 정확하게 적어주세요. (근사치 허용 ex.29540 > 29000)\n균등하게 파티가 분배됩니다.",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
          ),
          ToggleButtons(
            borderRadius: BorderRadius.circular(12),
            borderWidth: 2,
            borderColor: Colors.indigoAccent.shade200,
            selectedBorderColor: Colors.indigoAccent,
            fillColor: Colors.indigoAccent,
            color: Colors.black,
            selectedColor: Colors.white,
            isSelected: List.generate(2, (i) => i == attendSelectedIndex),
            onPressed: (int index) {
              bottomState(() {
                attendSelectedIndex = index;
              });
            },
            children: attendLabels
                .map((label) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(label),
                    ))
                .toList(),
          ),
          widgetSpace(height: 10),
          Text(
            "전투력",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
          ),
          widgetSpace(height: 10),
          CommonTextField(
            textEditingController: _powerTextEditingController,
            hintText: "전투력을 정확하게 입력해주세요. (근사치는 허용됩니다)",
            textInputType: TextInputType.number,
            valueChanged: (value) {
              bottomState(() {});
            },
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          )
        ],
      );
    });
  }
}
