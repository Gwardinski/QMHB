import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/models/user_model.dart';
import 'package:qmhb/screens/library/questions/round_selector/round_selector_item.dart';
import 'package:qmhb/screens/library/rounds/round_editor_page.dart';
import 'package:qmhb/services/database.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_header.dart';

class RoundSelectorPage extends StatefulWidget {
  final String questionId;
  final double questionPoints;

  RoundSelectorPage({
    @required this.questionId,
    @required this.questionPoints,
  });

  @override
  _RoundSelectorPageState createState() {
    return _RoundSelectorPageState();
  }
}

class _RoundSelectorPageState extends State<RoundSelectorPage> {
  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserDataStateModel>(context).user;
    DatabaseService databaseService = Provider.of<DatabaseService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Add to Rounds"),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
            ),
            SummaryRowHeader(
              headerTitle: "Select Round",
              headerButtonText: "New Round",
              headerButtonFunction: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RoundEditorPage(
                      type: RoundEditorPageType.ADD,
                      initialQuestionId: widget.questionId,
                    ),
                  ),
                );
              },
            ),
            Divider(),
            FutureBuilder(
              future: databaseService.getRoundsByIds(user.roundIds),
              builder: (BuildContext context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                if (snapshot.hasError == true) {
                  return Center(
                    child: Text("Could not load content"),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      RoundModel roundModel = snapshot.data[index];
                      return RoundSelectorItem(
                        roundModel: roundModel,
                        questionId: widget.questionId,
                        questionPoints: widget.questionPoints,
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
