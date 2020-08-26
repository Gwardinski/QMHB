import 'package:flutter/material.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/screens/library/quizzes/add_round_to_quiz.dart';
import 'package:qmhb/screens/library/rounds/round_editor_page.dart';
import 'package:qmhb/shared/widgets/details/round_details_widget.dart';

class RoundDetailsPage extends StatelessWidget {
  final RoundModel roundModel;

  RoundDetailsPage({
    @required this.roundModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Round Details"),
        actions: <Widget>[
          FlatButton(
            child: Text('Add to Quiz'),
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AddRoundToQuizPage(
                    roundModel: roundModel,
                  );
                },
              );
            },
          ),
          FlatButton(
            child: Text('Edit'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => RoundEditorPage(
                    roundModel: roundModel,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: RoundDetailsWidget(
        roundModel: roundModel,
      ),
    );
  }
}
