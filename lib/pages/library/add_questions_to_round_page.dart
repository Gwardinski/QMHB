import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/details/widgets/details_header_banner_image.dart';
import 'package:qmhb/pages/library/questions/question_editor_page.dart';
import 'package:qmhb/services/question_service.dart';
import 'package:qmhb/services/refresh_service.dart';
import 'package:qmhb/services/round_service.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item.dart';
import 'package:qmhb/shared/widgets/toolbar.dart';

class AddQuestionsToRoundPage extends StatefulWidget {
  final RoundModel selectedRound;

  AddQuestionsToRoundPage({
    @required this.selectedRound,
  });

  @override
  _AddQuestionsToRoundPageState createState() => _AddQuestionsToRoundPageState();
}

class _AddQuestionsToRoundPageState extends State<AddQuestionsToRoundPage> {
  String _token;
  QuestionService _questionService;
  RoundService _roundService;
  RefreshService _refreshService;
  List<QuestionModel> _questions = [];
  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _token = Provider.of<UserDataStateModel>(context, listen: false).token;
    _questionService = Provider.of<QuestionService>(context, listen: false);
    _roundService = Provider.of<RoundService>(context, listen: false);
    _refreshService = Provider.of<RefreshService>(context, listen: false);
    _subscription?.cancel();
    _subscription = _refreshService.questionListener.listen((event) {
      _getQuestions();
    });
    _refreshService.questionRefresh();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }

  _getQuestions() async {
    final questions = await _questionService.getUserQuestions(token: _token);
    setState(() {
      _questions = questions;
    });
  }

  void _createNewQuestionInRound() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QuestionEditorPage(
          type: QuestionEditorType.ADD,
          roundModel: widget.selectedRound,
        ),
      ),
    );
  }

  bool _containsQuestion(QuestionModel question) {
    return widget.selectedRound.questions.contains(question.id);
  }

  Future<void> _updateRound(QuestionModel question) async {
    RoundModel updatedRound = widget.selectedRound;
    if (_containsQuestion(question)) {
      updatedRound.questions.remove(question.id);
    } else {
      updatedRound.questions.add(question.id);
    }
    await _roundService.editRound(
      round: updatedRound,
      token: _token,
    );
    _refreshService.roundAndQuestionRefresh();
  }

  // TODO - make Round collapse when scroll on list
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Questions to Round"),
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.add),
            label: Text('New'),
            onPressed: _createNewQuestionInRound,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            child: Stack(
              children: [
                DetailsHeaderBannerImage(
                  imageUrl: widget.selectedRound.imageUrl,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          widget.selectedRound.title,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Text(
                        "Select the Questions to add to this Round.",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Toolbar(
            noOfResults: _questions.length,
            onUpdateSearchString: (val) {
              print(val);
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _questions.length ?? 0,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return QuestionListItemWithSelect(
                  questionModel: _questions[index],
                  selectedRound: widget.selectedRound,
                  onTap: () {
                    _updateRound(_questions[index]);
                  },
                  containsQuestion: () {
                    return _containsQuestion(_questions[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
