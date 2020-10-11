import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/models/user_model.dart';
import 'package:qmhb/screens/library/rounds/round_create_dialog.dart';
import 'package:qmhb/services/round_collection_service.dart';
import 'package:qmhb/shared/widgets/error_message.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';

// Dialog is used for building up: Question => Round => Quiz
class AddQuestionToRoundPageDialog extends StatelessWidget {
  final QuestionModel questionModel;

  AddQuestionToRoundPageDialog({
    @required this.questionModel,
  });

  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserDataStateModel>(context).user;
    return AlertDialog(
      contentPadding: EdgeInsets.all(0),
      content: Container(
        width: double.minPositive,
        height: 400,
        child: Column(
          children: [
            AddQuestionToNewRoundButton(
              initialQuestion: questionModel,
            ),
            Expanded(
              child: StreamBuilder(
                stream: RoundCollectionService().getRoundsCreatedByUser(
                  userId: user.uid,
                ),
                builder: (BuildContext context, AsyncSnapshot<List<RoundModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: LoadingSpinnerHourGlass(),
                    );
                  }
                  if (snapshot.hasError == true) {
                    return ErrorMessage(message: "An error occured loading your Questions");
                  }
                  return snapshot.data.length > 0
                      ? ListView.builder(
                          itemCount: snapshot.data.length ?? 0,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            return AddQuestionToRoundButton(
                              roundModel: snapshot.data[index],
                              questionModel: questionModel,
                            );
                          },
                        )
                      : Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddQuestionToNewRoundButton extends StatelessWidget {
  AddQuestionToNewRoundButton({
    this.initialQuestion,
  });

  final QuestionModel initialQuestion;

  openNewRoundForm(context) {
    Navigator.of(context).pop();
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return RoundCreateDialog(
          initialQuestion: initialQuestion,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        openNewRoundForm(context);
      },
      child: Container(
        height: 64,
        padding: EdgeInsets.all(16),
        child: Center(
          child: Row(
            children: [
              Icon(
                Icons.add_circle,
              ),
              Container(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  "New Round",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddQuestionToRoundButton extends StatefulWidget {
  const AddQuestionToRoundButton({
    Key key,
    @required this.roundModel,
    @required this.questionModel,
  }) : super(key: key);

  final RoundModel roundModel;
  final QuestionModel questionModel;

  @override
  _AddQuestionToRoundButtonState createState() => _AddQuestionToRoundButtonState();
}

class _AddQuestionToRoundButtonState extends State<AddQuestionToRoundButton> {
  bool _isLoading = false;
  RoundModel roundModel;
  QuestionModel questionModel;
  RoundCollectionService roundCollectionService;

  @override
  void initState() {
    super.initState();
    roundModel = widget.roundModel;
    questionModel = widget.questionModel;
    roundCollectionService = Provider.of<RoundCollectionService>(context, listen: false);
  }

  bool _containsQuestion() {
    return roundModel.questionIds.contains(questionModel.id);
  }

  _setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        _setLoading(true);
        if (!_containsQuestion()) {
          await roundCollectionService.addQuestionToRound(roundModel, questionModel);
        } else {
          await roundCollectionService.removeQuestionFromRound(roundModel, questionModel);
        }
        _setLoading(false);
      },
      child: Container(
        height: 64,
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Center(
          child: Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  roundModel.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                _isLoading
                    ? Container(height: 40, width: 40, child: LoadingSpinnerHourGlass())
                    : Icon(
                        _containsQuestion() ? Icons.remove_circle_outline : Icons.add_to_queue,
                        size: 24,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
