import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/pages/details/round/widgets/round_details_questions_list.dart';
import 'package:qmhb/pages/details/widgets/details_list_empty.dart';
import 'package:qmhb/pages/details/widgets/details_header.dart';
import 'package:qmhb/pages/library/questions/add_question_to_round_page.dart';
import 'package:qmhb/services/round_service.dart';
import 'package:qmhb/shared/widgets/error_message.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_header.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item_action.dart';

class RoundDetailsPage extends StatelessWidget {
  const RoundDetailsPage({
    Key key,
    @required this.roundModel,
  }) : super(key: key);

  final RoundModel roundModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Round Details"),
        actions: <Widget>[
          RoundListItemAction(
            roundModel: roundModel,
          ),
        ],
      ),
      body: FutureBuilder(
        initialData: roundModel,
        future: Provider.of<RoundService>(context).getRound(roundModel.id),
        builder: (BuildContext context, AsyncSnapshot<RoundModel> snapshot) {
          if (!snapshot.hasData) {
            return Container(
              height: 128,
              child: LoadingSpinnerHourGlass(),
            );
          }
          if (snapshot.hasError) {
            return ErrorMessage(message: "An error occured loading this Round");
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                DetailsHeader(
                  type: "Round",
                  title: snapshot.data.title,
                  description: snapshot.data.description,
                  info1Title: "Questions",
                  info2Title: "Points",
                  info3Title: "Created",
                  info1Value: snapshot.data.noOfQuestions.toString(),
                  info2Value: snapshot.data.totalPoints.toString(),
                  info3Value: DateFormat('d-MM-yy').format(snapshot.data.createdAt),
                  imageURL: snapshot.data.imageURL,
                ),
                Divider(),
                SummaryRowHeader(
                  headerTitle: "Questions",
                  secondaryHeaderButtonText: "Add / Remove",
                  secondaryHeaderButtonFunction: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddQuestionToRoundPage(
                          roundModel: snapshot.data,
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
                snapshot.data.noOfQuestions > 0
                    ? RoundDetailsQuestionsList(roundModel: snapshot.data)
                    : DetailsListEmpty(text: "This Round has no Questions"),
              ],
            ),
          );
        },
      ),
    );
  }
}
