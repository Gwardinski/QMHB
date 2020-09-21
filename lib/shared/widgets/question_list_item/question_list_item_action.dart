import 'package:flutter/material.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item.dart';

class QuestionListItemAction extends StatelessWidget {
  const QuestionListItemAction({
    Key key,
    @required this.onTap,
  }) : super(key: key);

  final onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Material(
        color: Colors.transparent,
        child: PopupMenuButton<QuestionOptions>(
          padding: EdgeInsets.zero,
          tooltip: "Question Actions",
          onSelected: (result) {
            onTap(result);
          },
          child: Container(
            width: 64,
            height: 64,
            child: Icon(Icons.more_vert),
          ),
          itemBuilder: (BuildContext context) => <PopupMenuEntry<QuestionOptions>>[
            PopupMenuItem<QuestionOptions>(
              value: QuestionOptions.addToRound,
              child: Text("Add to Round"),
            ),
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
      ),
    );
  }
}
