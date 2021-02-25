import 'package:flutter/material.dart';
import 'package:qmhb/get_it.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/pages/details/quiz/quiz_details_page.dart';
import 'package:qmhb/pages/play/play_quiz_page.dart';
import 'package:qmhb/shared/widgets/drag_feedback.dart';
import 'package:qmhb/shared/widgets/list_item/list_item_background_image.dart';
import 'package:qmhb/shared/widgets/list_item/list_item_details.dart';
import 'package:qmhb/shared/widgets/quiz_list_item/quiz_list_item_action.dart';

enum QuizOptions { save, edit, delete, details, addToQuiz, publish }

class QuizListItem extends StatefulWidget {
  final QuizModel quizModel;
  final bool canDrag;
  final bool play;

  QuizListItem({
    Key key,
    @required this.quizModel,
    this.canDrag = false,
    this.play = false,
  }) : super(key: key);

  @override
  _QuizListItemState createState() => _QuizListItemState();
}

class _QuizListItemState extends State<QuizListItem> {
  @override
  Widget build(BuildContext context) {
    final listItemStack = QuizListItemStack(
      quizModel: widget.quizModel,
      onTap: widget.play ? _playQuiz : _viewQuizDetails,
      play: widget.play,
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

  _playQuiz() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlayPage(
          quizModel: widget.quizModel,
          // type: SelectQuizToPlayPageType.LOCAL,
        ),
      ),
    );
  }
}

class QuizListItemStack extends StatelessWidget {
  const QuizListItemStack({
    Key key,
    @required this.quizModel,
    @required this.onTap,
    @required this.play,
  }) : super(key: key);

  final onTap;
  final QuizModel quizModel;
  final bool play;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
              play: play,
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
    @required this.play,
  }) : super(key: key);

  final QuizModel quizModel;
  final bool play;

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
            info2Value: quizModel.noOfRounds.toString(),
            info3Title: null,
            info3Value: null,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: getIt<AppSize>().lOnly16),
            child: play
                ? QuizPlayButton()
                : QuizListItemAction(
                    quizModel: quizModel,
                  ),
          ),
        ],
      ),
    );
  }
}

class QuizPlayButton extends StatelessWidget {
  const QuizPlayButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      child: Icon(Icons.play_arrow),
    );
  }
}
