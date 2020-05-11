import 'package:flutter/material.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/screens/library/rounds/quiz_selector/quiz_selector_page.dart';
import 'package:qmhb/screens/library/rounds/round_editor_page.dart';
import 'package:qmhb/shared/widgets/details/round_details_widget.dart';

class RoundDetailsPage extends StatefulWidget {
  final RoundModel roundModel;

  RoundDetailsPage({
    @required this.roundModel,
  });

  @override
  _RoundDetailsPageState createState() => _RoundDetailsPageState();
}

class _RoundDetailsPageState extends State<RoundDetailsPage> {
  RoundModel roundModel;

  @override
  void initState() {
    super.initState();
    roundModel = widget.roundModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Round Details"),
        actions: <Widget>[
          FlatButton(
            child: Text('Add to Quiz'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => QuizSelectorPage(
                    roundId: roundModel.uid,
                    roundPoints: roundModel.totalPoints,
                  ),
                ),
              );
            },
          ),
          FlatButton(
            child: Text('Edit'),
            onPressed: () async {
              final round = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => RoundEditorPage(
                    type: RoundEditorPageType.EDIT,
                    roundModel: roundModel,
                  ),
                ),
              );
              setState(() {
                roundModel = round;
              });
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
