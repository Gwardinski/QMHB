import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/services/refresher_service.dart';
import 'package:qmhb/services/round_service.dart';

class RoundDeleteDialog extends StatelessWidget {
  final RoundModel roundModel;

  RoundDeleteDialog({@required this.roundModel});

  @override
  Widget build(BuildContext context) {
    var text = "Are you sure you wish to delete ${roundModel.title} ?";
    if (roundModel.questions.length > 0) {
      text +=
          "\n\nThis will not delete the ${roundModel.questions.length} questions this round contains.";
    }
    return AlertDialog(
      title: Text("Delete Round"),
      content: Text(text),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Delete'),
          onPressed: () async {
            final token = Provider.of<UserDataStateModel>(context, listen: false).token;
            await Provider.of<RoundService>(context, listen: false).deletetRound(
              round: roundModel,
              token: token,
            );
            Provider.of<RefresherService>(context, listen: false).quizAndRoundRefresh();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
