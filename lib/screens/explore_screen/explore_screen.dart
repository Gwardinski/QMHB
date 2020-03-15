import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/authentication_state_model.dart';
import 'package:qmhb/models/user_model.dart';
import 'package:qmhb/screens/quizzes/quizzes_page.dart';
import 'package:qmhb/shared/widgets/summarys/question_row.dart';
import 'package:qmhb/shared/widgets/summarys/quiz_row.dart';
import 'package:qmhb/shared/widgets/summarys/round_row.dart';
import 'package:qmhb/shared/widgets/summarys/summary_header.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<AuthenticationStateModel>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: Text('Explore'),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 8)),
                QuizRow(),
                RoundRow(),
                QuestionRow(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
