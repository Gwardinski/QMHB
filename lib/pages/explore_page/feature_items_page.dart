import 'package:flutter/material.dart';
import 'package:qmhb/models/featured_quizzes_model.dart';
import 'package:qmhb/models/featured_rounds_model.dart';
import 'package:qmhb/shared/widgets/highlights/quiz_row.dart';
import 'package:qmhb/shared/widgets/highlights/round_row.dart';

class FeaturedItemsPage extends StatelessWidget {
  final Function(FeaturedQuizzes) onNavigateToQuizzes;
  final Function(FeaturedRounds) onNavigateToRounds;

  const FeaturedItemsPage({
    Key key,
    @required this.onNavigateToQuizzes,
    @required this.onNavigateToRounds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          FeaturedQuizRow(
            featNo: "1",
            onNavigate: onNavigateToQuizzes,
          ),
          FeaturedRoundRow(
            featNo: "1",
            onNavigate: onNavigateToRounds,
          ),
        ],
      ),
    );
  }
}
