import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/shared/widgets/highlights/round_highlight_row.dart';

class RecentRoundsRow extends StatelessWidget {
  final String headerTitle;
  final String headerButtonText;
  final Function headerButtonFunction;

  const RecentRoundsRow({
    Key key,
    @required this.headerTitle,
    @required this.headerButtonText,
    @required this.headerButtonFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rounds = Provider.of<UserDataStateModel>(context).recentRounds;
    return RoundHighlightRow(
      headerTitle: headerTitle,
      headerButtonText: headerButtonText,
      headerButtonFunction: headerButtonFunction,
      rounds: rounds,
    );
  }
}
