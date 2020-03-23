import 'package:flutter/material.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/screens/rounds/round_details_widget.dart';
import 'package:qmhb/screens/rounds/round_edit_page.dart';

class RoundDetailsPage extends StatelessWidget {
  final RoundModel roundModel;

  RoundDetailsPage({
    @required this.roundModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Round Details"),
        actions: <Widget>[
          FlatButton(
            child: Text('Edit Round'),
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
