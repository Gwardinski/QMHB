import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/details/widgets/details_list_empty.dart';
import 'package:qmhb/pages/details/widgets/details_header.dart';
import 'package:qmhb/services/refresh_service.dart';
import 'package:qmhb/services/round_service.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_header.dart';
import 'package:qmhb/shared/widgets/page_wrapper.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item_action.dart';

class RoundDetailsPage extends StatefulWidget {
  const RoundDetailsPage({
    Key key,
    @required this.initialValue,
  }) : super(key: key);

  final RoundModel initialValue;

  @override
  _RoundDetailsPageState createState() => _RoundDetailsPageState();
}

class _RoundDetailsPageState extends State<RoundDetailsPage> {
  RoundService _roundService;
  RefreshService _refreshService;
  RoundModel _round;
  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _round = widget.initialValue;
    _roundService = Provider.of<RoundService>(context, listen: false);
    _refreshService = Provider.of<RefreshService>(context, listen: false);
    _subscription?.cancel();
    _subscription = _refreshService.roundListener.listen((event) {
      _getRound();
    });
    _refreshService.roundRefresh();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }

  _getRound() async {
    final token = Provider.of<UserDataStateModel>(context, listen: false).token;
    final round = await _roundService.getRound(
      token: token,
      id: _round.id,
    );
    setState(() {
      _round = round;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Round Details"),
        actions: [
          RoundListItemAction(
            round: _round,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DetailsHeader(
              type: "Round",
              title: _round.title,
              description: _round.description,
              info1Title: "Questions",
              info2Title: "Points",
              info3Title: "Created",
              info1Value: _round.questions.length.toString(),
              info2Value: _round.totalPoints.toString(),
              info3Value: DateFormat('d-MM-yy').format(_round.createdAt),
              imageUrl: _round.imageUrl,
            ),
            Divider(),
            SummaryRowHeader(
              headerTitle: "Questions",
            ),
            PageWrapper(
              child: _round.questions.length > 0
                  ? ListView.separated(
                      separatorBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 8),
                        );
                      },
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _round.questionModels?.length ?? 0,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        QuestionModel question = _round.questionModels[index];
                        return QuestionListItemWithAction(
                          question: question,
                        );
                      },
                    )
                  : DetailsListEmpty(text: "This Round has no Questions"),
            )
          ],
        ),
      ),
    );
  }
}
