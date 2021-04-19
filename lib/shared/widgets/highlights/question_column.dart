import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/pages/library/questions/questions_library_page.dart';
import 'package:qmhb/services/navigation_service.dart';
import 'package:qmhb/shared/widgets/highlights/summarys/summary_header.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item.dart';

class QuestionColumn extends StatelessWidget {
  final Future future;

  const QuestionColumn({
    Key key,
    @required this.future,
  }) : super(key: key);

  _navigate(context) {
    Provider.of<NavigationService>(context, listen: false).push(
      QuestionsLibraryPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SummaryRowHeader(
          headerTitle: 'Questions',
          headerTitleButtonFunction: () {
            _navigate(context);
          },
          primaryHeaderButtonText: 'See All',
          primaryHeaderButtonFunction: () {
            _navigate(context);
          },
        ),
        FutureBuilder<List<QuestionModel>>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingSpinnerHourGlass();
              }
              return Column(
                children: snapshot.data
                    .map((q) => QuestionListItemWithAction(
                          question: q,
                        ))
                    .toList(),
              );
            }),
      ],
    );
  }
}
