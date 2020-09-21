import 'package:flutter/material.dart';
import 'package:qmhb/get_it.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/screens/library/quizzes/quiz_details_page.dart';
import 'package:qmhb/shared/widgets/quiz_list_item/quiz_list_item_action.dart';
import 'package:qmhb/shared/widgets/quiz_list_item/quiz_list_item_details.dart';

enum QuizOptions { save, edit, delete, details, addToQuiz, publish }

class QuizListItem extends StatefulWidget {
  final QuizModel quizModel;

  QuizListItem({
    Key key,
    @required this.quizModel,
  }) : super(key: key);

  @override
  _QuizListItemState createState() => _QuizListItemState();
}

class _QuizListItemState extends State<QuizListItem> {
  @override
  Widget build(BuildContext context) {
    return Draggable<QuizModel>(
      dragAnchor: DragAnchor.pointer,
      data: widget.quizModel,
      feedback: Material(
        child: Container(
          padding: EdgeInsets.all(16),
          height: 64,
          width: 256,
          color: Colors.grey,
          child: Center(
            child: Text(
              widget.quizModel.title,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
      child: InkWell(
        onTap: _viewQuizDetails,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getIt<AppSize>().rSpacingSm),
              ),
              QuizListItemDetails(
                quizModel: widget.quizModel,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getIt<AppSize>().lOnly16),
                child: QuizListItemAction(
                  quizModel: widget.quizModel,
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
