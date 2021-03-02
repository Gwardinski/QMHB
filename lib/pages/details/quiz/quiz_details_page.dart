import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/details/quiz/widgets/quiz_details_rounds_list.dart';
import 'package:qmhb/pages/details/widgets/details_list_empty.dart';
import 'package:qmhb/pages/details/widgets/details_header.dart';
import 'package:qmhb/pages/library/add_rounds_to_quiz_page.dart';
import 'package:qmhb/services/quiz_service.dart';
import 'package:qmhb/shared/widgets/error_message.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_header.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';
import 'package:qmhb/shared/widgets/quiz_list_item/quiz_list_item_action.dart';

class QuizDetailsPage extends StatelessWidget {
  const QuizDetailsPage({
    Key key,
    @required this.quizModel,
  }) : super(key: key);

  final QuizModel quizModel;

  @override
  Widget build(BuildContext context) {
    final token = Provider.of<UserDataStateModel>(context).token;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Quiz Details"),
        actions: <Widget>[
          QuizListItemAction(
            quizModel: quizModel,
          ),
        ],
      ),
      body: FutureBuilder(
        initialData: quizModel,
        future: Provider.of<QuizService>(context).getQuiz(
          id: quizModel.id,
          token: token,
        ),
        builder: (BuildContext context, AsyncSnapshot<QuizModel> snapshot) {
          if (!snapshot.hasData) {
            return Container(
              height: 128,
              child: LoadingSpinnerHourGlass(),
            );
          }
          if (snapshot.hasError) {
            return ErrorMessage(message: "An error occured loading this Quiz");
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                DetailsHeader(
                  type: "Quiz",
                  title: snapshot.data.title,
                  description: snapshot.data.description,
                  info1Title: "Rounds",
                  info2Title: "Points",
                  info3Title: "Created",
                  info1Value: snapshot.data.rounds.length.toString(),
                  info2Value: snapshot.data.totalPoints.toString(),
                  info3Value: DateFormat('d-MM-yy').format(snapshot.data.createdAt),
                  imageUrl: snapshot.data.imageUrl,
                ),
                Divider(),
                SummaryRowHeader(
                  headerTitle: "Rounds",
                  secondaryHeaderButtonText: "Add / Remove",
                  secondaryHeaderButtonFunction: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddRoundToQuizPage(
                          quizModel: snapshot.data,
                        ),
                      ),
                    );
                  },
                  primaryHeaderButtonText: "Reorder",
                  primaryHeaderButtonFunction: () async {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => ReorderQuestionsPage(
                    //       roundModel: roundModel,
                    //     ),
                    //   ),
                    // );
                  },
                ),
                snapshot.data.rounds.length > 0
                    ? QuizDetailsRoundsList(quizModel: snapshot.data)
                    : DetailsListEmpty(text: "This Quiz has no Rounds"),
              ],
            ),
          );
        },
      ),
    );
  }
}
