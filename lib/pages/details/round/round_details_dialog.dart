import 'package:flutter/material.dart';
import 'package:qmhb/models/round_model.dart';
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
      contentPadding: EdgeInsets.all(0),
      content: FutureBuilder(
        initialData: round,
        future: future,
        builder: (context, snapshot) {
          return Container(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: snapshot.data.questionModels.length,
              itemBuilder: (context, index) {
                return QuestionListItemInRoundDialog(
                  question: snapshot.data.questionModels[index],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
