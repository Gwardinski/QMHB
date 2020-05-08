import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/screens/rounds/round_collection_page.dart';
import 'package:qmhb/shared/widgets/highlights/round_highlight_row.dart';

class RecentRoundsRow extends StatelessWidget {
  RecentRoundsRow({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rounds = Provider.of<RecentActivityStateModel>(context).recentRounds;
    return RoundHighlightRow(
      headerTitle: "Rounds",
      headerButtonText: "See All",
      rounds: rounds,
      headerButtonFunction: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RoundCollectionPage(),
          ),
        );
      },
    );
  }
}
