import 'package:flutter/material.dart';
import 'package:qmhb/shared/widgets/quiz_list_item/quiz_list_item.dart';

class QuizListItemAction extends StatelessWidget {
  const QuizListItemAction({
    Key key,
    @required this.onTap,
  }) : super(key: key);

  final onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PopupMenuButton<QuizOptions>(
        onSelected: (result) {
          onTap(result);
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<QuizOptions>>[
          PopupMenuItem<QuizOptions>(
            value: QuizOptions.edit,
            child: Text("Edit"),
          ),
          PopupMenuItem<QuizOptions>(
            value: QuizOptions.delete,
            child: Text("Delete"),
          ),
          // PopupMenuItem<QuizOptions>(
          //   value: QuizOptions.save,
          //   child: Text("Save To Collection"),
          // ),
          // PopupMenuItem<QuizOptions>(
          //   value: QuizOptions.publish,
          //   child: Text("Publish"),
          // ),
        ],
      ),
    );
  }
}
