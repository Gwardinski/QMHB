import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/models/user_model.dart';
import 'package:qmhb/screens/library/quizzes/quiz_selector/quiz_selector_item.dart';
import 'package:qmhb/screens/library/quizzes/quiz_add_modal.dart';
import 'package:qmhb/services/quiz_collection_service.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_header.dart';

class QuizSelectorPage extends StatefulWidget {
  final RoundModel round;

  QuizSelectorPage({
    @required this.round,
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
    QuizCollectionService quizCollectionService = Provider.of<QuizCollectionService>(context);
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
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return QuizAddModal(
                      initialRound: widget.round,
                    );
                  },
                );
              },
            ),
            Divider(),
            StreamBuilder(
              stream: quizCollectionService.getQuizzesByIds(user.quizIds),
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
                        roundId: widget.round.id,
                        roundPoints: widget.round.totalPoints,
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
