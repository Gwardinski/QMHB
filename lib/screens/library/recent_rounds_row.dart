import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/screens/library/rounds/round_collection_page.dart';
import 'package:qmhb/services/round_collection_service.dart';
import 'package:qmhb/shared/widgets/highlights/highlight_row.dart';
import 'package:qmhb/shared/widgets/highlights/create_new_quiz_or_round.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_footer.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_header.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';

import '../../get_it.dart';

class RecentRoundsRow extends StatelessWidget {
  RecentRoundsRow({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        Container(
          margin: EdgeInsets.fromLTRB(
            0,
            getIt<AppSize>().lOnly8,
            0,
            getIt<AppSize>().rSpacingSm,
          ),
          child: StreamBuilder(
              stream: Provider.of<RoundCollectionService>(context).getRecentRoundStream(),
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
                return (snapshot.data.length == 0)
                    ? Row(
                        children: [
                          Expanded(
                            child: CreateNewQuizOrRound(
                              type: CreateNewQuizOrRoundType.QUIZ,
                            ),
                          ),
                        ],
                      )
                    : HighlightRow(
                        rounds: snapshot.data,
                      );
              }),
        ),
        SummaryRowFooter(),
      ],
    );
  }
}
