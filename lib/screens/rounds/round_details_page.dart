import 'package:flutter/material.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/screens/rounds/round_details_widget.dart';

class RoundDetailsPage extends StatelessWidget {
  final RoundModel roundModel;

  RoundDetailsPage({
    @required this.roundModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(roundModel.title),
      ),
      body: RoundDetailsWidget(
        roundModel: roundModel,
      ),
    );
  }
}
