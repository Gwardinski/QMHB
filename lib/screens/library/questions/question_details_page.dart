import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/screens/library/questions/question_edit_page.dart';
import 'package:qmhb/screens/library/questions/question_round_selector_page.dart';
import 'package:qmhb/shared/widgets/question_details_widget.dart';

class QuestionDetailsPage extends StatelessWidget {
  final QuestionModel questionModel;

  QuestionDetailsPage({
    @required this.questionModel,
  });

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDataStateModel>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: Text("Question"),
        actions: <Widget>[
          FlatButton(
            child: Text('Add to'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => QuestionToRoundSelectorPage(
                    questionId: questionModel.uid,
                    questionPoints: questionModel.points,
                  ),
                ),
              );
            },
          ),
          user.uid == questionModel.userId
              ? FlatButton.icon(
                  icon: Icon(Icons.edit),
                  label: Text('Edit'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => QuestionEditPage(questionModel: questionModel),
                      ),
                    );
                  },
                )
              : Container()
        ],
      ),
      body: QuestionDetailsWidget(
        questionModel: questionModel,
      ),
    );
  }
}
