import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';

class QuestionListItemFavourite extends StatelessWidget {
  const QuestionListItemFavourite({
    Key key,
    @required this.question,
    @required this.disable,
  }) : super(key: key);

  final QuestionModel question;
  final bool disable;

  @override
  Widget build(BuildContext context) {
    UserDataStateModel userDataStateModel = Provider.of<UserDataStateModel>(context);
    bool isOwned = userDataStateModel.user.id == question.uid;
    bool isFavourited = userDataStateModel.user.savedQuestions.contains(question.id);
    return isOwned
        ? Container()
        : Container(
            height: 64,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 48,
                height: 48,
                child: FlatButton(
                  onPressed: () {
                    userDataStateModel.toggleFavouriteQuestion(question.id);
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Icon(
                            isFavourited == true ? Icons.favorite : Icons.favorite_outline,
                            size: 24,
                            color: disable == false ? Theme.of(context).accentColor : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  _saveQuestion() {
    print("Save Question");
  }
}
