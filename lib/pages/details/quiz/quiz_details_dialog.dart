import 'package:flutter/material.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/shared/widgets/button_primary.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item.dart';

class QuizDetailsDialog extends StatelessWidget {
  final QuizModel quiz;
  final Future<QuizModel> future;

  QuizDetailsDialog({
    @required this.quiz,
    @required this.future,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Quiz Rounds"),
      contentPadding: EdgeInsets.all(0),
      content: FutureBuilder(
        initialData: quiz,
        future: future,
        builder: (context, snapshot) {
          return Container(
            padding: EdgeInsets.only(top: 16),
            width: double.maxFinite,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data.roundModels.length,
                    itemBuilder: (context, index) {
                      return RoundListItemShell(
                        round: snapshot.data.roundModels[index],
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      child: ButtonPrimary(
                        text: "Close",
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
