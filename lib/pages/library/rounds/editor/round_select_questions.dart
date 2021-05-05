import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/library/questions/questions_library_page.dart';
import 'package:qmhb/pages/library/widgets/editor_header.dart';
import 'package:qmhb/services/question_service.dart';
import 'package:qmhb/services/refresh_service.dart';
import 'package:qmhb/shared/widgets/error_message.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item.dart';
import 'package:qmhb/shared/widgets/toolbar.dart';

class RoundSelectQuestions extends StatelessWidget {
  final RoundModel round;
  final Function onTap;
  final Function containsItem;

  RoundSelectQuestions({
    @required this.round,
    @required this.onTap,
    @required this.containsItem,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: Provider.of<RefreshService>(context, listen: false).questionListener,
      builder: (context, streamSnapshot) {
        return FutureBuilder<List<QuestionModel>>(
          future: Provider.of<QuestionService>(context).getUserQuestions(
            limit: 8,
            sortBy: 'lastUpdated',
            token: Provider.of<UserDataStateModel>(context).token,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return ErrorMessage(
                message: "An error occured loading your Questions",
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EditorHeader(
                  title: "Select your Questions",
                ),
                Toolbar(
                  onUpdateSearchString: (s) => print(s),
                  onUpdateFilter: () {},
                  onUpdateSort: () {},
                  results: snapshot.data?.length?.toString() ?? 'loading',
                  hintText: "Search Your Questions",
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: (snapshot.data?.length ?? 0) + 1,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return NewQuestionListItem();
                    }
                    return QuestionListItemWithSelect(
                      question: snapshot.data[index - 1],
                      onTap: () => onTap(snapshot.data[index - 1]),
                      containsItem: () => containsItem(snapshot.data[index - 1]),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class RoundSelectedQuestions extends StatelessWidget {
  final RoundModel round;
  final Function onTap;
  final Function containsItem;
  final Function onReorder;

  RoundSelectedQuestions({
    @required this.round,
    @required this.onTap,
    @required this.containsItem,
    @required this.onReorder,
  });

  reorder(int oldIndex, int newIndex) {
    var updatedRound = round;
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final int q = updatedRound.questions.removeAt(oldIndex);
    final QuestionModel question = updatedRound.questionModels.removeAt(oldIndex);
    updatedRound.questions.insert(newIndex, q);
    updatedRound.questionModels.insert(newIndex, question);
    onReorder(updatedRound);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EditorHeader(
          title: "Selected Questions",
        ),
        round.questionModels?.length == 0
            ? Container(
                height: 128,
                child: Center(
                  child: Text("You have not selected any Questions."),
                ),
              )
            : Container(
                height: round.questionModels.length > 2
                    ? (64 * round.questionModels.length).toDouble()
                    : 128,
                child: ReorderableListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  onReorder: reorder,
                  children: List.generate(
                    round.questionModels?.length,
                    (i) => QuestionListItemWithSelectAndReorder(
                      key: Key(round.questionModels[i].id.toString()),
                      question: round.questionModels[i],
                      onTap: () => onTap(round.questionModels[i]),
                      containsItem: () => containsItem(round.questionModels[i]),
                    ),
                  ),
                ),
              ),
        Padding(padding: EdgeInsets.only(bottom: 32)),
      ],
    );
  }
}
