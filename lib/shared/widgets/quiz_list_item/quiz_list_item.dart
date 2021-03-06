import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/details/quiz/quiz_details_dialog.dart';
import 'package:qmhb/pages/details/quiz/quiz_details_page.dart';
import 'package:qmhb/pages/library/widgets/add_item_into_item_button.dart';
import 'package:qmhb/services/navigation_service.dart';
import 'package:qmhb/services/quiz_service.dart';
import 'package:qmhb/shared/widgets/list_item/list_item.dart';
import 'package:qmhb/shared/widgets/quiz_list_item/quiz_list_item_action.dart';

class QuizListItem extends StatelessWidget {
  final QuizModel quiz;
  final Widget action;

  QuizListItem({
    Key key,
    this.quiz,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListItem(
      title: quiz.title,
      description: quiz.description,
      imageUrl: quiz.imageUrl,
      points: quiz.totalPoints,
      number: quiz.rounds.length,
      infoTitle1: " Rounds",
      infoTitle2: " Pts",
      action: action,
    );
  }
}

class QuizListItemWithAction extends StatelessWidget {
  final QuizModel quiz;

  QuizListItemWithAction({
    Key key,
    @required this.quiz,
  }) : super(key: key);

  void _navigateToDetails(context) {
    Provider.of<NavigationService>(context, listen: false).push(
      QuizDetailsPage(
        initialValue: quiz,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _navigateToDetails(context),
      child: QuizListItem(
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
      child: QuizListItem(
        quiz: quiz,
        action: AddItemIntoItemButton(
          contains: containsItem,
          onTap: onTap,
        ),
      ),
    );
  }
}
