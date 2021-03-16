import 'package:flutter/material.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item.dart';

class ReOrderQuestionsPage extends StatefulWidget {
  final RoundModel roundModel;

  ReOrderQuestionsPage({this.roundModel});

  @override
  _ReOrderQuestionsPageState createState() => _ReOrderQuestionsPageState();
}

class _ReOrderQuestionsPageState extends State<ReOrderQuestionsPage> {
  RoundModel roundModel;

  @override
  void initState() {
    roundModel = widget.roundModel;
    super.initState();
  }

  Future<void> _onReorder(int start, int current) async {
    if (start < current) {
      QuestionModel startItem = roundModel.questionModels[start];
      int end = current - 1;
      int i = 0;
      int local = start;
      do {
        roundModel.questionModels[local] = roundModel.questionModels[++local];
        i++;
      } while (i < end - start);
      roundModel.questionModels[end] = startItem;
    } else if (start > current) {
      QuestionModel startItem = roundModel.questionModels[start];
      for (int i = start; i > current; i--) {
        roundModel.questionModels[i] = roundModel.questionModels[i - 1];
      }
      roundModel.questionModels[current] = startItem;
    }
    // TODO also update .questions list
    // TODO put request
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Re-Order"),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              "Drag and drop to re-order the questions within this round.",
            ),
          ),
          Expanded(
            child: ReorderableListView(
              children: roundModel.questionModels
                  .map(
                    (question) => QuestionListItemWithReorder(
                      key: Key(question.id.toString()),
                      questionModel: question,
                    ),
                  )
                  .toList(),
              onReorder: _onReorder,
            ),
          ),
        ],
      ),
    );
  }
}
