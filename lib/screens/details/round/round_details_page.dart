import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/screens/details/round/widgets/round_details_header_column.dart';
import 'package:qmhb/screens/details/round/widgets/round_details_header_row.dart';
import 'package:qmhb/screens/details/round/widgets/round_details_questions_list.dart';
import 'package:qmhb/screens/library/questions/add_question_to_round_page.dart';
import 'package:qmhb/services/round_collection_service.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_header.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';
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
          ),
        ],
      ),
      body: StreamBuilder(
        initialData: roundModel,
        stream: Provider.of<RoundCollectionService>(context).getRoundById(roundModel.id),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: 128,
              child: LoadingSpinnerHourGlass(),
            );
          }
          if (snapshot.hasError) {
            return Container(
              height: 128,
              width: 128,
              child: Text("err"),
            );
          }
          return ListView(
            children: [
              getIt<AppSize>().isLarge
                  ? RoundDetailsHeaderRow(roundModel: roundModel)
                  : RoundDetailsHeaderColumn(roundModel: roundModel),
              Divider(),
              SummaryRowHeader(
                headerTitle: "Questions",
                primaryHeaderButtonText: "Add Questions",
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
          );
        },
      ),
    );
  }
}
