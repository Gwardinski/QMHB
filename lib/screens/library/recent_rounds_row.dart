import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/screens/library/rounds/round_collection_page.dart';
import 'package:qmhb/shared/widgets/highlights/highlight_row.dart';
import 'package:qmhb/shared/widgets/highlights/no_collection.dart';
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
          primaryHeaderButtonText: 'See All',
          primaryHeaderButtonFunction: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => RoundCollectionPage(),
              ),
            );
          },
        ),
        (rounds == null || rounds.length == 0)
            ? Row(
                children: [
                  Expanded(child: NoCollection(type: NoCollectionType.ROUND)),
                ],
              )
            : HighlightRow(
                rounds: rounds,
              ),
        SummaryRowFooter(),
      ],
    );
  }
}
