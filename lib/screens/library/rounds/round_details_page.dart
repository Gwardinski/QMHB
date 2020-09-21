import 'package:flutter/material.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/shared/widgets/details/round_details_widget.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item_action.dart';

class RoundDetailsPage extends StatefulWidget {
  final RoundModel roundModel;

  RoundDetailsPage({
    @required this.roundModel,
  });

  @override
  _RoundDetailsPageState createState() => _RoundDetailsPageState();
}

class _RoundDetailsPageState extends State<RoundDetailsPage> {
  RoundModel round;

  @override
  void initState() {
    round = widget.roundModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Round Details"),
        actions: <Widget>[
          RoundListItemAction(
            roundModel: widget.roundModel,
            emitData: (newQuiz) {
              setState(() {
                round = newQuiz;
              });
            },
          ),
        ],
      ),
      body: RoundDetailsWidget(
        roundModel: widget.roundModel,
      ),
    );
  }
}
