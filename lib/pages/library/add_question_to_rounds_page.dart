import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/details/widgets/details_header_banner_image.dart';
import 'package:qmhb/pages/details/widgets/details_header_banner_text.dart';
import 'package:qmhb/pages/library/rounds/round_create_dialog.dart';
import 'package:qmhb/services/refresh_service.dart';
import 'package:qmhb/services/round_service.dart';
import 'package:qmhb/shared/widgets/app_bar_button.dart';
import 'package:qmhb/shared/widgets/grid_item/grid_item.dart';
import 'package:qmhb/shared/widgets/round_grid_item/round_grid_item.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item.dart';
import 'package:qmhb/shared/widgets/toolbar.dart';

class AddQuestionToRoundsPage extends StatefulWidget {
  final QuestionModel selectedQuestion;

  AddQuestionToRoundsPage({
    @required this.selectedQuestion,
  });

  @override
  _AddQuestionToRoundsPageState createState() => _AddQuestionToRoundsPageState();
}

class _AddQuestionToRoundsPageState extends State<AddQuestionToRoundsPage> {
  String _token;
  RoundService _roundService;
  RefreshService _refreshService;

  @override
  void initState() {
    super.initState();
    _token = Provider.of<UserDataStateModel>(context, listen: false).token;
    _roundService = Provider.of<RoundService>(context, listen: false);
    _refreshService = Provider.of<RefreshService>(context, listen: false);
  }

  void _createNewRoundwithQuestion() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return RoundCreateDialog(
          initialQuestion: widget.selectedQuestion,
        );
      },
    );
  }

  bool _containsQuestion(round) {
    return round.questions.contains(widget.selectedQuestion.id);
  }

  Future<void> _updateRound(round) async {
    if (_containsQuestion(round)) {
      round.questions.remove(widget.selectedQuestion.id);
    } else {
      round.questions.add(widget.selectedQuestion.id);
    }
    await _roundService.editRound(
      round: round,
      token: _token,
    );
    _refreshService.roundAndQuestionRefresh();
  }

  // TODO - make header text collapse when scroll on list
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).size.width > 800.0;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        title: Text(isLandscape ? "Add Question to Rounds" : "Add to..."),
        actions: [
          isLandscape
              ? Container()
              : AppBarButton(
                  title: "New",
                  leftIcon: Icons.add,
                  onTap: _createNewRoundwithQuestion,
                ),
        ],
      ),
      body: Stack(
        children: [
          DetailsHeaderBannerImage(
            imageUrl: widget.selectedQuestion.imageUrl,
          ),
          Column(
            children: [
              DetailsHeaderBannerText(
                line1: '"${widget.selectedQuestion.question}"',
                line2: "Select the Rounds that this Question should be added to.",
                line3: "Changes will be saved automatically.",
              ),
              Expanded(
                child: StreamBuilder<bool>(
                  stream: _refreshService.roundListener,
                  builder: (context, s) {
                    return FutureBuilder<List<RoundModel>>(
                      future: _roundService.getUserRounds(
                        token: Provider.of<UserDataStateModel>(context).token,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("An error occured loading your Rounds"),
                          );
                        }
                        return Column(
                          children: [
                            Toolbar(
                              onUpdateSearchString: (val) => print(val),
                              onUpdateFilter: () {},
                              onUpdateSort: () {},
                              results: snapshot.data?.length?.toString() ?? 'loading',
                            ),
                            Expanded(
                              child: isLandscape
                                  ? GridView.builder(
                                      itemCount: (snapshot.data?.length ?? 0) + 1,
                                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 160,
                                        childAspectRatio: 1,
                                        crossAxisSpacing: 16,
                                        mainAxisSpacing: 16,
                                      ),
                                      padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                                      itemBuilder: (BuildContext context, int index) {
                                        if (index == 0) {
                                          return GridItemNew(
                                            title: "Add to New Round",
                                            description: "",
                                            onTap: _createNewRoundwithQuestion,
                                          );
                                        }
                                        return RoundGridItemWithSelect(
                                          round: snapshot.data[index - 1],
                                          onTap: () => _updateRound(snapshot.data[index - 1]),
                                          containsItem: () =>
                                              _containsQuestion(snapshot.data[index - 1]),
                                        );
                                      },
                                    )
                                  : ListView.builder(
                                      itemCount: snapshot.data.length ?? 0,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (BuildContext context, int index) {
                                        return RoundListItemWithSelect(
                                          round: snapshot.data[index],
                                          onTap: () => _updateRound(snapshot.data[index]),
                                          containsItem: () =>
                                              _containsQuestion(snapshot.data[index]),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
