import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/screens/library/questions/question_editor_page.dart';
import 'package:qmhb/screens/library/widgets/create_first_question_button.dart';
import 'package:qmhb/services/question_collection_service.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item.dart';
import 'package:qmhb/shared/widgets/toolbar.dart';

// Page is used for building down: Quiz => Round => Question
class AddQuestionToRoundPage extends StatefulWidget {
  const AddQuestionToRoundPage({
    Key key,
    @required this.roundModel,
  }) : super(key: key);

  final RoundModel roundModel;

  @override
  _AddQuestionToRoundPageState createState() => _AddQuestionToRoundPageState();
}

class _AddQuestionToRoundPageState extends State<AddQuestionToRoundPage> {
  RoundModel _roundModel;

  @override
  void initState() {
    _roundModel = widget.roundModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDataStateModel>(context).user;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Select Questions"),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.add_circle),
            label: Text('New'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => QuestionEditorPage(
                    type: QuestionEditorType.ADD,
                    roundModel: _roundModel,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Toolbar(),
          Expanded(
            child: StreamBuilder(
              stream: QuestionCollectionService().getQuestionsCreatedByUser(
                userId: user.uid,
              ),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: LoadingSpinnerHourGlass(),
                  );
                }
                if (snapshot.hasError == true) {
                  return Center(
                    child: Text("Could not load your questions"),
                  );
                }
                return snapshot.data.length > 0
                    ? ListView.separated(
                        separatorBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 8),
                          );
                        },
                        itemCount: snapshot.data.length ?? 0,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          QuestionModel questionModel = snapshot.data[index];
                          return QuestionListItem(
                            questionModel: questionModel,
                            roundModel: widget.roundModel,
                            canDrag: false,
                          );
                        },
                      )
                    : Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CreateFirstQuestionButton(),
                          ],
                        ),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
