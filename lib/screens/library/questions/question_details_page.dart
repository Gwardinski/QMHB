import 'package:flutter/material.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/screens/library/questions/question_editor_page.dart';
import 'package:qmhb/screens/library/questions/round_selector/round_selector_page.dart';
import 'package:qmhb/shared/widgets/details/question_details_widget.dart';

class QuestionDetailsPage extends StatefulWidget {
  final QuestionModel questionModel;

  QuestionDetailsPage({
    @required this.questionModel,
  });

  @override
  _QuestionDetailsPageState createState() => _QuestionDetailsPageState();
}

class _QuestionDetailsPageState extends State<QuestionDetailsPage> {
  QuestionModel questionModel;

  @override
  void initState() {
    super.initState();
    questionModel = widget.questionModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Question"),
        actions: <Widget>[
          FlatButton(
            child: Text('Add to'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => RoundSelectorPage(
                    questionId: questionModel.uid,
                    questionPoints: questionModel.points,
                  ),
                ),
              );
            },
          ),
          FlatButton(
            child: Text('Edit'),
            onPressed: () async {
              final question = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => QuestionEditorPage(
                    type: QuestionEditorType.EDIT,
                    questionModel: questionModel,
                  ),
                ),
              );
              setState(() {
                questionModel = question;
              });
            },
          ),
        ],
      ),
      body: QuestionDetailsWidget(
        questionModel: questionModel,
      ),
    );
  }
}
