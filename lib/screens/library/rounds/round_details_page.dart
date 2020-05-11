import 'package:flutter/material.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/screens/library/rounds/round_edit_page.dart';
import 'package:qmhb/screens/library/rounds/round_quiz_selector_page.dart';
import 'package:qmhb/screens/library/rounds/widgets/round_details_widget.dart';

class RoundDetailsPage extends StatelessWidget {
  final RoundModel roundModel;

  RoundDetailsPage({
    @required this.roundModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Round"),
        actions: <Widget>[
          FlatButton(
            child: Text('Add to'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => RoundToQuizSelectorPage(
                    roundId: roundModel.uid,
                    roundPoints: roundModel.totalPoints,
                  ),
                ),
              );
            },
          ),
          FlatButton.icon(
            icon: Icon(Icons.edit),
            label: Text('Edit'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => RoundEditPage(roundModel: roundModel),
                ),
              );
            },
          ),
        ],
      ),
      body: RoundDetailsWidget(
        roundModel: roundModel,
      ),
    );
  }
}
