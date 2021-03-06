import 'package:flutter/material.dart';
import 'package:qmhb/get_it.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/pages/details/quiz/quiz_details_page.dart';
import 'package:qmhb/shared/widgets/list_item/list_item_background_image.dart';
import 'package:qmhb/shared/widgets/list_item/list_item_details.dart';
import 'package:qmhb/shared/widgets/quiz_list_item/quiz_list_item_action.dart';

enum QuizOptions { save, edit, delete, details, addToQuiz, publish }

class QuizListItem extends StatelessWidget {
  final QuizModel quizModel;

  QuizListItem({
    Key key,
    @required this.quizModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => QuizDetailsPage(
              quizModel: quizModel,
            ),
          ),
        );
      },
      child: Container(
        height: 112,
        child: Stack(
          children: [
            ItemBackgroundImage(imageUrl: quizModel.imageUrl),
            Container(
              height: 112,
              width: double.infinity,
              margin: EdgeInsets.only(left: 200),
              color: Theme.of(context).canvasColor,
            ),
            Container(
              height: 112,
              margin: EdgeInsets.fromLTRB(16, 8, 0, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ListItemDetails(
                    title: quizModel.title,
                    description: quizModel.description,
                    info1Title: "Points: ",
                    info1Value: quizModel.totalPoints.toString(),
                    info2Title: "Rounds: ",
                    info2Value: quizModel.rounds.length.toString(),
                    info3Title: null,
                    info3Value: null,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: getIt<AppSize>().lOnly16),
                    child: QuizListItemAction(
                      quizModel: quizModel,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
