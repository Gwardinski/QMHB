import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/screens/library/rounds/round_editor_page.dart';
import 'package:qmhb/services/quiz_collection_service.dart';
import 'package:qmhb/services/round_collection_service.dart';
import 'package:qmhb/shared/widgets/error_message.dart';
import 'package:qmhb/shared/widgets/highlights/create_new_quiz_or_round.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item.dart';

// Page is used for building down: Quiz => Round => Question
class AddRoundToQuizPage extends StatefulWidget {
  const AddRoundToQuizPage({
    Key key,
    @required this.quizModel,
  }) : super(key: key);

  final QuizModel quizModel;

  @override
  _AddRoundToQuizPageState createState() => _AddRoundToQuizPageState();
}

class _AddRoundToQuizPageState extends State<AddRoundToQuizPage> {
  QuizModel _quizModel;

  @override
  void initState() {
    _quizModel = widget.quizModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDataStateModel>(context).user;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("Select Rounds"),
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.add),
              label: Text('New'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RoundEditorPage(
                      type: RoundEditorType.ADD,
                      quizModel: _quizModel,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: StreamBuilder<QuizModel>(
          initialData: _quizModel,
          stream: QuizCollectionService().getQuizById(_quizModel.id),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return ErrorMessage(message: "An error occured loading this Quiz");
            }
            return Column(
              children: [
                Expanded(
                  child: StreamBuilder<List<RoundModel>>(
                    stream: RoundCollectionService().getRoundsCreatedByUser(
                      userId: user.uid,
                    ),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: LoadingSpinnerHourGlass(),
                        );
                      }
                      if (snapshot.hasError == true) {
                        return ErrorMessage(message: "An error occured loading your Rounds");
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
                                RoundModel roundModel = snapshot.data[index];
                                return RoundListItem(
                                  canDrag: false,
                                  roundModel: roundModel,
                                  quizModel: widget.quizModel,
                                );
                              },
                            )
                          : Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CreateNewQuizOrRound(
                                    type: CreateNewQuizOrRoundType.ROUND,
                                  ),
                                ],
                              ),
                            );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
