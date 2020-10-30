import 'package:flutter/material.dart';
import 'package:qmhb/get_it.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/screens/details/quiz/quiz_details_page.dart';
import 'package:qmhb/shared/widgets/drag_feedback.dart';
import 'package:qmhb/shared/widgets/list_item/list_item_background_image.dart';
import 'package:qmhb/shared/widgets/list_item/list_item_details.dart';
import 'package:qmhb/shared/widgets/quiz_list_item/quiz_list_item_action.dart';

enum QuizOptions { save, edit, delete, details, addToQuiz, publish }

class QuizListItem extends StatefulWidget {
  final QuizModel quizModel;
  final bool canDrag;

  QuizListItem({
    Key key,
    @required this.quizModel,
    this.canDrag = false,
  }) : super(key: key);

  @override
  _QuizListItemState createState() => _QuizListItemState();
}

class _QuizListItemState extends State<QuizListItem> {
  @override
  Widget build(BuildContext context) {
    final listItemStack = QuizListItemStack(
      quizModel: widget.quizModel,
      viewQuizDetails: _viewQuizDetails,
    );
    return widget.canDrag
        ? Draggable<QuizModel>(
            dragAnchor: DragAnchor.pointer,
            data: widget.quizModel,
            feedback: DragFeedback(
              title: widget.quizModel.title,
            ),
            child: listItemStack,
          )
        : listItemStack;
  }

  _viewQuizDetails() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QuizDetailsPage(
          quizModel: widget.quizModel,
        ),
      ),
    );
  }
}

class QuizListItemStack extends StatelessWidget {
  const QuizListItemStack({
    Key key,
    @required this.quizModel,
    @required this.viewQuizDetails,
  }) : super(key: key);

  final viewQuizDetails;
  final QuizModel quizModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        viewQuizDetails();
      },
      child: Container(
        height: 112,
        child: Stack(
          children: [
            ItemBackgroundImage(imageUrl: quizModel.imageURL),
            Container(
              height: 112,
              width: double.infinity,
              margin: EdgeInsets.only(left: 200),
              color: Theme.of(context).canvasColor,
            ),
            QuizListItemContent(
              quizModel: quizModel,
            ),
          ],
        ),
      ),
    );
  }
}

class QuizListItemContent extends StatelessWidget {
  const QuizListItemContent({
    Key key,
    @required this.quizModel,
  }) : super(key: key);

  final QuizModel quizModel;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            info2Value: quizModel.roundIds.length.toString(),
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
    );
  }
}
