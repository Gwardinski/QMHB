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
        title: Text(isLandscape ? "Add Question to Rounds" : "Add to..."),
        actions: [
          AppBarButton(
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
                line3:
                    "Changes will be saved automatically.\nAny Rounds you have published will not appear here. Published Rounds cannot be edited.",
              ),
              StreamBuilder<bool>(
                stream: _refreshService.roundListener,
                builder: (context, s) {
                  return FutureBuilder<List<RoundModel>>(
                    future: _roundService.getUserRounds(
                      token: Provider.of<UserDataStateModel>(context, listen: false).token,
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
                            onUpdateSearchString: (val) {
                              print(val);
                            },
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: snapshot.data.length ?? 0,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index) {
                                return RoundListItemWithSelect(
                                  round: snapshot.data[index],
                                  onTap: () => _updateRound(snapshot.data[index]),
                                  containsItem: () => _containsQuestion(snapshot.data[index]),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
