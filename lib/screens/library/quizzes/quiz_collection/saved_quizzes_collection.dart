import 'package:flutter/material.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/shared/widgets/quiz_list_item.dart';

class SavedQuizzesCollection extends StatelessWidget {
  SavedQuizzesCollection({
    Key key,
    @required this.savedQuizzes,
  }) : super(key: key);

  final savedQuizzes;

  @override
  Widget build(BuildContext context) {
    return savedQuizzes.length > 0
        ? ListView.builder(
            itemCount: savedQuizzes.length ?? 0,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              QuizModel quizModel = savedQuizzes[index];
              return QuizListItem(
                quizModel: quizModel,
              );
            },
          )
        : Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "You haven't saved any quizzes yet. \n Head to the Explore tab to start searching",
              textAlign: TextAlign.center,
            ),
          );
  }
}
