import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/services/refresh_service.dart';
import 'package:qmhb/services/user_service.dart';
import 'package:qmhb/shared/widgets/list_item/list_item_favourite.dart';

class QuestionListItemFavourite extends StatelessWidget {
  const QuestionListItemFavourite({
    Key key,
    @required this.question,
    @required this.isDisabled,
  }) : super(key: key);

  final QuestionModel question;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    UserService userService = Provider.of<UserService>(context);
    RefreshService refreshService = Provider.of<RefreshService>(context);
    UserDataStateModel userDataStateModel = Provider.of<UserDataStateModel>(context);
    bool isOwned = userDataStateModel.user.id == question.uid;
    bool isFavourited = userDataStateModel.user.savedQuestions.contains(question.id);
    return isOwned
        ? Container()
        : ListItemFavourite(
            isFavourited: isFavourited,
            isDisabled: isDisabled,
            onTap: () async {
              userDataStateModel.toggleFavouriteQuestion(question.id);
              try {
                await userService.toggleFavouriteQuestion(
                  id: question.id,
                  token: userDataStateModel.token,
                );
              } catch (e) {
                print(e);
              }
              refreshService.questionRefresh();
            },
          );
  }
}
