import 'package:flutter/material.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/shared/widgets/button_primary.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item.dart';

class RoundDetailsDialog extends StatelessWidget {
  final RoundModel round;
  final Future<RoundModel> future;

  RoundDetailsDialog({
    @required this.round,
    @required this.future,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Round Questions"),
      contentPadding: EdgeInsets.all(0),
      content: FutureBuilder(
        initialData: round,
        future: future,
        builder: (context, snapshot) {
          return Container(
            padding: EdgeInsets.only(top: 16),
            width: double.maxFinite,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data.questionModels.length,
                    itemBuilder: (context, index) {
                      return QuestionListItemInRoundDialog(
                        question: snapshot.data.questionModels[index],
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
