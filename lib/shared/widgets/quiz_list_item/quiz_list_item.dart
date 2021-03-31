import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/details/quiz/quiz_details_dialog.dart';
import 'package:qmhb/pages/details/quiz/quiz_details_page.dart';
import 'package:qmhb/pages/library/widgets/add_item_into_item_button.dart';
import 'package:qmhb/services/navigation_service.dart';
import 'package:qmhb/services/quiz_service.dart';
import 'package:qmhb/shared/widgets/list_item/list_item_background_image.dart';
import 'package:qmhb/shared/widgets/list_item/list_item_details.dart';
import 'package:qmhb/shared/widgets/quiz_list_item/quiz_list_item_action.dart';

class QuizListItemShell extends StatelessWidget {
  final QuizModel quiz;
  final Widget action;

  QuizListItemShell({
    Key key,
    @required this.quiz,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112,
      child: Stack(
        children: [
          ItemBackgroundImage(imageUrl: quiz.imageUrl),
          ListItemDetails(
            title: quiz.title,
            description: quiz.description,
            info1Title: "Points: ",
            info1Value: quiz.totalPoints.toString(),
            info2Title: "Questions: ",
            info2Value: quiz.rounds.length.toString(),
            info3Title: null,
            info3Value: null,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: action != null
                ? action
                : Container(
                    width: 64,
                  ),
          ),
        ],
      ),
    );
  }
}

class QuizListItemWithAction extends StatelessWidget {
  final QuizModel quiz;

  QuizListItemWithAction({
    Key key,
    @required this.quiz,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<NavigationService>(context, listen: false).push(
          QuizDetailsPage(
            initialValue: quiz,
          ),
        );
      },
      child: QuizListItemShell(
        quiz: quiz,
        action: QuizListItemAction(
          quiz: quiz,
        ),
      ),
    );
  }
}

class QuizListItemWithSelect extends StatelessWidget {
  final QuizModel quiz;
  final Function containsItem;
  final Function onTap;

  QuizListItemWithSelect({
    Key key,
    @required this.quiz,
    @required this.containsItem,
    @required this.onTap,
  }) : super(key: key);

  void _showNestedItems(context) {
    QuizService service = Provider.of<QuizService>(context, listen: false);
    String token = Provider.of<UserDataStateModel>(context, listen: false).token;
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return QuizDetailsDialog(
          quiz: quiz,
          future: service.getQuiz(
            id: quiz.id,
            token: token,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showNestedItems(context),
      child: QuizListItemShell(
        quiz: quiz,
        action: AddItemIntoItemButton(
          contains: containsItem,
          onTap: onTap,
        ),
      ),
    );
  }
}
