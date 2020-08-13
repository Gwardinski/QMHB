import 'package:flutter/material.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item.dart';

class QuizListItemAction extends StatelessWidget {
  const QuizListItemAction({
    Key key,
    @required this.onTap,
  }) : super(key: key);

  final onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PopupMenuButton<QuestionOptions>(
        onSelected: (result) {
          onTap(result);
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<QuestionOptions>>[
          PopupMenuItem<QuestionOptions>(
            value: QuestionOptions.edit,
            child: Text("Edit"),
          ),
          PopupMenuItem<QuestionOptions>(
            value: QuestionOptions.delete,
            child: Text("Delete"),
          ),
          // PopupMenuItem<QuestionOptions>(
          //   value: QuestionOptions.save,
          //   child: Text("Save To Collection"),
          // ),
          // PopupMenuItem<QuestionOptions>(
          //   value: QuestionOptions.publish,
          //   child: Text("Publish"),
          // ),
        ],
      ),
    );
  }
}
