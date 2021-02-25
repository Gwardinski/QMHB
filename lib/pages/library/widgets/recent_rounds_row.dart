import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/library/rounds/rounds_library_page.dart';
import 'package:qmhb/services/round_service.dart';
import 'package:qmhb/shared/widgets/error_message.dart';
import 'package:qmhb/shared/widgets/highlights/highlight_row.dart';
import 'package:qmhb/shared/widgets/highlights/create_new_quiz_or_round.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_footer.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_header.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';

import '../../../get_it.dart';

class RecentRoundsRow extends StatelessWidget {
  RecentRoundsRow({
    Key key,
  }) : super(key: key);

  navigate(context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RoundCollectionPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final token = Provider.of<UserDataStateModel>(context).token;
    return Column(
      children: [
        SummaryRowHeader(
          headerTitle: 'Rounds',
          headerTitleButtonFunction: () {
            navigate(context);
          },
          primaryHeaderButtonText: 'See All',
          primaryHeaderButtonFunction: () {
            navigate(context);
          },
        ),
        Container(
          margin: EdgeInsets.fromLTRB(
            0,
            getIt<AppSize>().lOnly8,
            0,
            getIt<AppSize>().rSpacingSm,
          ),
          child: FutureBuilder(
              future: Provider.of<RoundService>(context).getUserRounds(
                limit: 8,
                orderBy: 'TIME',
                token: token,
              ),
              builder: (BuildContext context, AsyncSnapshot<List<RoundModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: 128,
                    child: LoadingSpinnerHourGlass(),
                  );
                }
                if (snapshot.hasError) {
                  return ErrorMessage(message: "An error occured loading your Rounds");
                }
                return (snapshot.data.length == 0)
                    ? Row(
                        children: [
                          Expanded(
                            child: CreateNewQuizOrRound(
                              type: CreateNewQuizOrRoundType.ROUND,
                            ),
                          ),
                        ],
                      )
                    : HighlightRow(
                        rounds: snapshot.data.reversed.toList(),
                      );
              }),
        ),
        SummaryRowFooter(),
      ],
    );
  }
}
