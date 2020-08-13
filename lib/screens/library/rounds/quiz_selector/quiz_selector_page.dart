import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/models/user_model.dart';
import 'package:qmhb/screens/library/quizzes/quiz_editor_page.dart';
import 'package:qmhb/screens/library/rounds/quiz_selector/quiz_selector_item.dart';
import 'package:qmhb/screens/library/widgets/quiz_editor.dart';
import 'package:qmhb/services/database.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_header.dart';

class QuizSelectorPage extends StatefulWidget {
  final String roundId;
  final double roundPoints;

  QuizSelectorPage({
    @required this.roundId,
    @required this.roundPoints,
  });

  @override
  _QuizSelectorPageState createState() {
    return _QuizSelectorPageState();
  }
}

class _QuizSelectorPageState extends State<QuizSelectorPage> {
  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserDataStateModel>(context).user;
    DatabaseService databaseService = Provider.of<DatabaseService>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Add Round to Quiz"),
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
              headerTitle: "Select Quizzes",
              primaryHeaderButtonText: "New Quiz",
              primaryHeaderButtonFunction: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => QuizEditorPage(
                      type: QuizEditorType.ADD,
                      initialRoundId: widget.roundId,
                    ),
                  ),
                );
              },
            ),
            Divider(),
            FutureBuilder(
              future: databaseService.getQuizzesByIds(user.quizIds),
              builder: (BuildContext context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                if (snapshot.hasError == true) {
                  return Center(
                    child: Text("Could not load content"),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      QuizModel quizModel = snapshot.data[index];
                      return QuizSelectorItem(
                        quizModel: quizModel,
                        roundId: widget.roundId,
                        roundPoints: widget.roundPoints,
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
