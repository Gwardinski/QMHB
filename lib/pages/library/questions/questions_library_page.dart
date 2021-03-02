import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/library/questions/question_editor_page.dart';
import 'package:qmhb/pages/library/rounds/rounds_library_sidebar.dart';
import 'package:qmhb/shared/widgets/highlights/create_first_question_button.dart';
import 'package:qmhb/services/question_service.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item.dart';
import 'package:qmhb/shared/widgets/toolbar.dart';

import '../../../get_it.dart';

class QuestionsLibraryPage extends StatefulWidget {
  @override
  _QuestionsLibraryPageState createState() => _QuestionsLibraryPageState();
}

class _QuestionsLibraryPageState extends State<QuestionsLibraryPage> {
  final canDrag = getIt<AppSize>().isLarge;
  String _token;
  QuestionService _questionService;
  List<QuestionModel> _questions = [];
  QuestionModel _selectedQuestion;

  @override
  void initState() {
    super.initState();
    _token = Provider.of<UserDataStateModel>(context, listen: false).token;
    _questionService = Provider.of<QuestionService>(context, listen: false);
    _getQuestions();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getQuestions() async {
    final questions = await _questionService.getUserQuestions(token: _token);
    setState(() {
      _questions = questions;
    });
  }

  void _createQuestion() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QuestionEditorPage(
          type: QuestionEditorType.ADD,
        ),
      ),
    );
  }

  void _setSelectedQuestion(QuestionModel question) {
    setState(() {
      _selectedQuestion = question;
    });
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
                  child: _questions.length > 0
                      ? ListView.builder(
                          itemCount: _questions.length ?? 0,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            QuestionModel questionModel = _questions[index];
                            return QuestionListItem(
                              questionModel: questionModel,
                              canDrag: canDrag,
                              onDragStarted: () => _setSelectedQuestion(_questions[index]),
                              onDragEnd: () => _setSelectedQuestion(null),
                            );
                          },
                        )
                      : CreateFirstQuestionButton(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
