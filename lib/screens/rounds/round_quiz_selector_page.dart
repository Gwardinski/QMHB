import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/models/user_model.dart';
import 'package:qmhb/screens/quizzes/quiz_add_page.dart';
import 'package:qmhb/screens/rounds/add_round_widgets/quiz_selector_widget.dart';
import 'package:qmhb/services/database.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_header.dart';

class RoundToQuizSelectorPage extends StatefulWidget {
  final String roundId;
  final double roundPoints;

  RoundToQuizSelectorPage({
    @required this.roundId,
    @required this.roundPoints,
  });

  @override
  _RoundToQuizSelectorPageState createState() {
    return _RoundToQuizSelectorPageState();
  }
}

class _RoundToQuizSelectorPageState extends State<RoundToQuizSelectorPage> {
  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserDataStateModel>(context).user;
    DatabaseService databaseService = Provider.of<DatabaseService>(context);
    return Scaffold(
      appBar: AppBar(
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
              headerButtonText: "New Quiz",
              headerButtonFunction: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => QuizAddPage(
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
                return QuizSelectorWidget(
                  quizzes: snapshot.data,
                  roundId: widget.roundId,
                  roundPoints: widget.roundPoints,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
