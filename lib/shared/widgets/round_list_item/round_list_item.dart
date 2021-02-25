import 'package:flutter/material.dart';
import 'package:qmhb/get_it.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/pages/details/round/round_details_page.dart';
import 'package:qmhb/shared/widgets/drag_feedback.dart';
import 'package:qmhb/shared/widgets/list_item/list_item_background_image.dart';
import 'package:qmhb/shared/widgets/list_item/list_item_details.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item_action.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item_add_to_quiz.dart';

enum RoundOptions { save, edit, delete, details, addToQuiz, publish }

class RoundListItem extends StatefulWidget {
  final RoundModel roundModel;
  final QuizModel quizModel;
  final bool canDrag;

  RoundListItem({
    Key key,
    @required this.roundModel,
    this.canDrag = false,
    this.quizModel,
  }) : super(key: key);

  @override
  _RoundListItemState createState() => _RoundListItemState();
}

class _RoundListItemState extends State<RoundListItem> {
  @override
  Widget build(BuildContext context) {
    final listItemStack = RoundListItemStack(
      roundModel: widget.roundModel,
      viewRoundDetails: _viewRoundDetails,
      quizModel: widget.quizModel,
    );
    return widget.canDrag
        ? Draggable<RoundModel>(
            dragAnchor: DragAnchor.pointer,
            data: widget.roundModel,
            feedback: DragFeedback(
              title: widget.roundModel.title,
            ),
            child: listItemStack,
          )
        : listItemStack;
  }

  _viewRoundDetails() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RoundDetailsPage(
          roundModel: widget.roundModel,
        ),
      ),
    );
  }
}

class RoundListItemStack extends StatelessWidget {
  const RoundListItemStack({
    Key key,
    @required this.roundModel,
    @required this.viewRoundDetails,
    this.quizModel,
  }) : super(key: key);

  final RoundModel roundModel;
  final viewRoundDetails;
  final QuizModel quizModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        viewRoundDetails();
      },
      child: Container(
        height: 112,
        child: Stack(
          children: [
            ItemBackgroundImage(imageUrl: roundModel.imageURL),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: 112,
                width: 64,
                color: Theme.of(context).canvasColor,
              ),
            ),
            RoundListItemContent(
              roundModel: roundModel,
              quizModel: quizModel,
            ),
          ],
        ),
      ),
    );
  }
}

class RoundListItemContent extends StatelessWidget {
  const RoundListItemContent({
    Key key,
    @required this.roundModel,
    @required this.quizModel,
  }) : super(key: key);

  final RoundModel roundModel;
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
            title: roundModel.title,
            description: roundModel.description,
            info1Title: "Points: ",
            info1Value: roundModel.totalPoints.toString(),
            info2Title: "Questions: ",
            info2Value: roundModel.noOfQuestions.toString(),
            info3Title: null,
            info3Value: null,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: getIt<AppSize>().lOnly16),
            child: quizModel != null
                ? RoundListItemActionAddToQuiz(
                    quizModel: quizModel,
                    roundModel: roundModel,
                  )
                : RoundListItemAction(
                    roundModel: roundModel,
                  ),
          ),
        ],
      ),
    );
  }
}
