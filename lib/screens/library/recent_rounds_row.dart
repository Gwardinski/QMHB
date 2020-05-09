import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/screens/rounds/round_collection_page.dart';
import 'package:qmhb/shared/widgets/highlights/no_quiz_or_round_widget.dart';
import 'package:qmhb/shared/widgets/highlights/round_highlight_row.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_footer.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_header.dart';

class RecentRoundsRow extends StatelessWidget {
  RecentRoundsRow({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rounds = Provider.of<RecentActivityStateModel>(context).recentRounds;
    return Column(
      children: [
        SummaryRowHeader(
          headerTitle: 'Rounds',
          headerButtonText: 'See All',
          headerButtonFunction: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => RoundCollectionPage(),
              ),
            );
          },
        ),
        (rounds == null || rounds.length == 0)
            ? NoQuizOrRoundWidget(type: NoQuizOrRoundWidgetType.ROUND)
            : RoundHighlightRow(
                rounds: rounds,
              ),
        SummaryRowFooter(),
      ],
    );
  }
}
