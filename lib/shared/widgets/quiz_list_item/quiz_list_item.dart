import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/get_it.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/screens/library/quizzes/quiz_details_page.dart';
import 'package:qmhb/screens/library/quizzes/quiz_editor_page.dart';
import 'package:qmhb/services/quiz_collection_service.dart';
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
                  onTap: onMenuSelect,
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

  onMenuSelect(QuizOptions result) {
    if (result == QuizOptions.edit) {
      return _editQuiz();
    }
    if (result == QuizOptions.delete) {
      return _deleteQuiz();
    }
    if (result == QuizOptions.save) {
      return _saveQuiz();
    }
    if (result == QuizOptions.publish) {
      return _publishQuiz();
    }
  }

  _editQuiz() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QuizEditorPage(
          quizModel: widget.quizModel,
        ),
      ),
    );
  }

  _deleteQuiz() {
    var text = "Are you sure you wish to delete ${widget.quizModel.title} ?";
    if (widget.quizModel.questionIds.length > 0) {
      text +=
          "\n\nThis will not delete the ${widget.quizModel.questionIds.length} questions this quiz contains.";
    }
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text("Delete Quiz"),
        content: Text(text),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Delete'),
            onPressed: () async {
              Navigator.of(context).pop();
              await Provider.of<QuizCollectionService>(context)
                  .deleteQuizOnFirebaseCollection(widget.quizModel.id);
            },
          ),
        ],
      ),
    );
  }

  _saveQuiz() {
    print("Save Quiz");
  }

  _publishQuiz() {
    print("Publish Quiz");
  }
}
