import 'package:flutter/material.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/shared/widgets/details/round_details_widget.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item_action.dart';

class RoundDetailsPage extends StatelessWidget {
  final RoundModel roundModel;

  RoundDetailsPage({
    @required this.roundModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Round Details"),
        actions: <Widget>[
          RoundListItemAction(
            roundModel: roundModel,
          ),
        ],
      ),
      body: RoundDetailsWidget(
        roundModel: roundModel,
      ),
    );
  }
}
