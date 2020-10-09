import 'package:flutter/material.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/screens/details/round/widgets/round_details_header_column.dart';
import 'package:qmhb/screens/details/round/widgets/round_details_header_row.dart';
import 'package:qmhb/screens/details/round/widgets/round_details_questions_list.dart';
import 'package:qmhb/screens/library/questions/add_question_to_round_page.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_header.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item_action.dart';

import '../../../get_it.dart';

class RoundDetailsPage extends StatefulWidget {
  const RoundDetailsPage({
    Key key,
    @required this.roundModel,
  }) : super(key: key);

  final RoundModel roundModel;

  @override
  _RoundDetailsWidgetState createState() => _RoundDetailsWidgetState();
}

class _RoundDetailsWidgetState extends State<RoundDetailsPage> {
  RoundModel roundModel;

  @override
  void initState() {
    roundModel = widget.roundModel;
    super.initState();
  }

  _addQuestionsToRound() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddQuestionToRoundPage(
          roundModel: roundModel,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Round Details"),
        actions: <Widget>[
          RoundListItemAction(
            roundModel: widget.roundModel,
            emitData: (newQuiz) {
              setState(() {
                roundModel = newQuiz;
              });
            },
          ),
        ],
      ),
      // add future builder to round model. listen for updates
      body: ListView(
        children: [
          getIt<AppSize>().isLarge
              ? RoundDetailsHeaderRow(roundModel: roundModel)
              : RoundDetailsHeaderColumn(roundModel: roundModel),
          Divider(),
          SummaryRowHeader(
            headerTitle: "Questions",
            primaryHeaderButtonText: "Add Question",
            primaryHeaderButtonFunction: () async {
              _addQuestionsToRound();
            },
          ),
          roundModel.questionIds.length > 0
              ? RoundDetailsQuestionsList(roundModel: roundModel)
              : Center(
                  child: Text("This Round has no Questions"),
                ),
        ],
      ),
    );
  }
}
