import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/details/quiz/quiz_details_dialog.dart';
import 'package:qmhb/pages/details/quiz/quiz_details_page.dart';
import 'package:qmhb/pages/library/widgets/add_item_into_item_button.dart';
import 'package:qmhb/services/navigation_service.dart';
import 'package:qmhb/services/quiz_service.dart';
import 'package:qmhb/shared/widgets/grid_item/grid_item.dart';
import 'package:qmhb/shared/widgets/quiz_list_item/quiz_list_item_action.dart';

class QuizGridItem extends StatelessWidget {
  final QuizModel quiz;
  final Widget action;

  QuizGridItem({
    Key key,
    this.quiz,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridItem(
      type: GridItemType.ROUND,
      title: quiz.title,
      description: quiz.description,
      imageUrl: quiz.imageUrl,
      points: quiz.totalPoints,
      number: quiz.rounds.length,
      action: action,
    );
  }
}

class QuizGridItemWithAction extends StatelessWidget {
  final QuizModel quiz;

  QuizGridItemWithAction({
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
      child: QuizGridItem(
        quiz: quiz,
        action: QuizListItemAction(
          quiz: quiz,
        ),
      ),
    );
  }
}

class QuizGridItemWithSelect extends StatelessWidget {
  final QuizModel quiz;
  final Function containsItem;
  final Function onTap;

  QuizGridItemWithSelect({
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
      child: QuizGridItem(
        quiz: quiz,
        action: AddItemIntoItemButton(
          contains: containsItem,
          onTap: onTap,
        ),
      ),
    );
  }
}
