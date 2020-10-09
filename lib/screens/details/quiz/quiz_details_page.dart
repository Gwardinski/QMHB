import 'package:flutter/material.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/screens/details/quiz/widgets/quiz_details_header_column.dart';
import 'package:qmhb/screens/details/quiz/widgets/quiz_details_header_row.dart';
import 'package:qmhb/screens/details/quiz/widgets/quiz_details_rounds_list.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_header.dart';
import 'package:qmhb/shared/widgets/quiz_list_item/quiz_list_item_action.dart';

import '../../../get_it.dart';

class QuizDetailsPage extends StatefulWidget {
  const QuizDetailsPage({
    Key key,
    @required this.quizModel,
  }) : super(key: key);

  final QuizModel quizModel;

  @override
  _QuizDetailsPageState createState() => _QuizDetailsPageState();
}

class _QuizDetailsPageState extends State<QuizDetailsPage> {
  QuizModel quiz;

  @override
  void initState() {
    quiz = widget.quizModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Quiz Details"),
        actions: <Widget>[
          QuizListItemAction(
            quizModel: widget.quizModel,
            emitData: (newQuiz) {
              setState(() {
                quiz = newQuiz;
              });
            },
          )
        ],
      ),
      body: ListView(
        children: [
          getIt<AppSize>().isLarge
              ? QuizDetailsHeaderRow(quizModel: widget.quizModel)
              : QuizDetailsHeaderColumn(quizModel: widget.quizModel),
          Divider(),
          SummaryRowHeader(
            headerTitle: "Rounds",
          ),
          widget.quizModel.roundIds.length > 0
              ? QuizDetailsRoundsList(
                  quizModel: widget.quizModel,
                )
              : Center(
                  child: Text("The Quiz has no Rounds"),
                ),
        ],
      ),
    );
  }
}
