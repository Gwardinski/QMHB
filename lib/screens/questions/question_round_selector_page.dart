import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/models/user_model.dart';
import 'package:qmhb/screens/questions/add_question_widgets/round_selector_widget.dart';
import 'package:qmhb/screens/rounds/round_add_page.dart';
import 'package:qmhb/services/database.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_header.dart';

class QuestionToRoundSelectorPage extends StatefulWidget {
  final String questionId;
  final double questionPoints;

  QuestionToRoundSelectorPage({
    @required this.questionId,
    @required this.questionPoints,
  });

  @override
  _QuestionToRoundSelectorPageState createState() {
    return _QuestionToRoundSelectorPageState();
  }
}

class _QuestionToRoundSelectorPageState extends State<QuestionToRoundSelectorPage> {
  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserDataStateModel>(context).user;
    DatabaseService databaseService = Provider.of<DatabaseService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Question to Round"),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
            ),
            SummaryRowHeader(
              headerTitle: "Select Rounds",
              headerButtonText: "New Round",
              headerButtonFunction: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RoundAddPage(
                      initialQuestionId: widget.questionId,
                    ),
                  ),
                );
              },
            ),
            Divider(),
            FutureBuilder(
              future: databaseService.getRoundsByIds(user.roundIds),
              builder: (BuildContext context, snapshot) {
                return RoundSelectorWidget(
                  rounds: snapshot.data,
                  questionId: widget.questionId,
                  questionPoints: widget.questionPoints,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
