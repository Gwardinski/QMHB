import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/library/questions/question_editor_page.dart';
import 'package:qmhb/pages/library/rounds/rounds_library_sidebar.dart';
import 'package:qmhb/services/question_service.dart';
import 'package:qmhb/services/refresh_service.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item.dart';
import 'package:qmhb/shared/widgets/toolbar.dart';

import '../../../get_it.dart';

class QuestionsLibraryPage extends StatefulWidget {
  @override
  _QuestionsLibraryPageState createState() => _QuestionsLibraryPageState();
}

class _QuestionsLibraryPageState extends State<QuestionsLibraryPage> {
  final canDrag = getIt<AppSize>().isLarge;
  QuestionService _questionService;
  RefreshService _refreshService;
  QuestionModel _selectedQuestion;
  List<QuestionModel> _questions = [];
  StreamSubscription _subscription;

  void _setSelectedQuestion(QuestionModel question) => setState(() => _selectedQuestion = question);

  @override
  void initState() {
    super.initState();
    _questionService = Provider.of<QuestionService>(context, listen: false);
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
    final token = Provider.of<UserDataStateModel>(context, listen: false).token;
    final questions = await _questionService.getUserQuestions(token: token);
    setState(() {
      _questions = questions;
    });
  }

  void _createQuestion() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QuestionEditorPage(
          type: QuestionEditorType.ADD,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Your Questions"),
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.add),
            label: Text('New'),
            onPressed: _createQuestion,
          ),
        ],
      ),
      body: Row(
        children: [
          canDrag ? RoundsLibrarySidebar(selectedQuestion: _selectedQuestion) : Container(),
          Expanded(
            child: Column(
              children: [
                Toolbar(
                  onUpdateSearchString: (s) => print(s),
                  noOfResults: _questions.length,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _questions.length ?? 0,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return DraggableQuestionListItem(
                        questionModel: _questions[index],
                        onDragStarted: () => _setSelectedQuestion(_questions[index]),
                        onDragEnd: (val) => _setSelectedQuestion(null),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
