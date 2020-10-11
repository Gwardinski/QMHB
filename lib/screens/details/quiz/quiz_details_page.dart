import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/screens/details/quiz/widgets/quiz_details_header_column.dart';
import 'package:qmhb/screens/details/quiz/widgets/quiz_details_header_row.dart';
import 'package:qmhb/screens/details/quiz/widgets/quiz_details_rounds_list.dart';
import 'package:qmhb/screens/library/rounds/add_round_to_quiz_page.dart';
import 'package:qmhb/services/quiz_collection_service.dart';
import 'package:qmhb/shared/widgets/error_message.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_header.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';
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
  QuizModel quizModel;

  @override
  void initState() {
    quizModel = widget.quizModel;
    super.initState();
  }

  _addRoundsToQuiz() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddRoundToQuizPage(
          quizModel: quizModel,
        ),
      ),
    );
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
          )
        ],
      ),
      body: StreamBuilder(
        initialData: quizModel,
        stream: Provider.of<QuizCollectionService>(context).getQuizById(quizModel.id),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: 160,
              child: LoadingSpinnerHourGlass(),
            );
          }
          if (snapshot.hasError) {
            return ErrorMessage(message: "An error occured loading this Quiz");
          }
          return ListView(
            children: [
              getIt<AppSize>().isLarge
                  ? QuizDetailsHeaderRow(quizModel: quizModel)
                  : QuizDetailsHeaderColumn(quizModel: quizModel),
              Divider(),
              SummaryRowHeader(
                headerTitle: "Rounds",
                secondaryHeaderButtonText: "Add Rounds",
                secondaryHeaderButtonFunction: () async {
                  _addRoundsToQuiz();
                },
                primaryHeaderButtonText: "Reorder",
                primaryHeaderButtonFunction: () {},
              ),
              quizModel.roundIds.length > 0
                  ? QuizDetailsRoundsList(quizModel: quizModel)
                  : Center(
                      child: Text("This Quiz has no Rounds"),
                    ),
            ],
          );
        },
      ),
    );
  }
}
