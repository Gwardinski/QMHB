import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/services/navigation_service.dart';
import 'package:qmhb/services/refresh_service.dart';
import 'package:qmhb/services/round_service.dart';

class RoundDeleteDialog extends StatelessWidget {
  final RoundModel round;

  RoundDeleteDialog({@required this.round});

  @override
  Widget build(BuildContext context) {
    var text = "Are you sure you wish to delete ${round.title} ?";
    if (round.questions.length > 0) {
      text +=
          "\n\nThis will not delete the ${round.questions.length} questions this round contains.";
    }
    return AlertDialog(
      title: Text("Delete Round"),
      content: Text(text),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Provider.of<NavigationService>(context, listen: false).pop();
          },
        ),
        TextButton(
          child: Text('Delete'),
          onPressed: () async {
            final token = Provider.of<UserDataStateModel>(context, listen: false).token;
            await Provider.of<RoundService>(context, listen: false).deletetRound(
              round: round,
              token: token,
            );
            Provider.of<RefreshService>(context, listen: false).quizAndRoundRefresh();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
