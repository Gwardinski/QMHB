import 'package:flutter/material.dart';
import 'package:qmhb/models/featured_questions_model.dart';
import 'package:qmhb/models/featured_quizzes_model.dart';
import 'package:qmhb/models/featured_rounds_model.dart';
import 'package:qmhb/shared/widgets/highlights/question_column.dart';
import 'package:qmhb/shared/widgets/highlights/quiz_row.dart';
import 'package:qmhb/shared/widgets/highlights/round_row.dart';

class FeaturedItemsPage extends StatelessWidget {
  final Function(FeaturedQuizzes) onNavigateToQuizzes;
  final Function(FeaturedRounds) onNavigateToRounds;
  final Function(FeaturedQuestions) onNavigateToQuestions;

  const FeaturedItemsPage({
    @required this.onNavigateToQuizzes,
    @required this.onNavigateToRounds,
    @required this.onNavigateToQuestions,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          FeaturedQuizRow(
            featNo: "1",
            onNavigate: onNavigateToQuizzes,
          ),
          FeaturedQuizRow(
            featNo: "2",
            onNavigate: onNavigateToQuizzes,
          ),
          FeaturedRoundRow(
            featNo: "1",
            onNavigate: onNavigateToRounds,
          ),
          FeaturedRoundRow(
            featNo: "2",
            onNavigate: onNavigateToRounds,
          ),
          FeaturedRoundRow(
            featNo: "3",
            onNavigate: onNavigateToRounds,
          ),
          FeaturedRoundRow(
            featNo: "4",
            onNavigate: onNavigateToRounds,
          ),
          FeaturedQuestionsColumn(
            featNo: "1",
            onNavigate: onNavigateToQuestions,
          ),
        ],
      ),
    );
  }
}
