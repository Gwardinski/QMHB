import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/library/rounds/rounds_library_sidebar.dart';
import 'package:qmhb/services/question_service.dart';
import 'package:qmhb/services/refresh_service.dart';
import 'package:qmhb/shared/widgets/error_message.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item.dart';
import 'package:qmhb/shared/widgets/toolbar.dart';

class QuestionPage extends StatefulWidget {
  final List<QuestionModel> initialData;
  final String searchString;
  final String selectedCategory;
  final String sortBy;

  QuestionPage({
    @required this.initialData,
    @required this.searchString,
    @required this.selectedCategory,
    @required this.sortBy,
  });

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  QuestionModel _selectedQuestion;

  void _setSelectedQuestion(QuestionModel question) => setState(() => _selectedQuestion = question);

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).size.width > 800.0;
    return Row(
      children: [
        isLandscape ? RoundsLibrarySidebar(selectedQuestion: _selectedQuestion) : Container(),
        StreamBuilder<bool>(
          stream: Provider.of<RefreshService>(context, listen: false).roundListener,
          builder: (context, streamSnapshot) {
            return FutureBuilder<List<QuestionModel>>(
              future: Provider.of<QuestionService>(context).getAllQuestions(
                limit: 30,
                selectedCategory: widget.selectedCategory,
                searchString: widget.searchString,
                sortBy: widget.sortBy,
                token: Provider.of<UserDataStateModel>(context).token,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return ErrorMessage(
                    message: "An error occured loading your Questions",
                  );
                }
                return Column(
                  children: [
                    Toolbar(
                      initialString: widget.searchString,
                      onUpdateSearchString: (s) => print(s),
                      onUpdateFilter: () {},
                      onUpdateSort: () {},
                      results: snapshot.data?.length?.toString() ?? 'loading',
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data?.length ?? 0,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return isLandscape
                              ? DraggableQuestionListItem(
                                  question: snapshot.data[index],
                                  onDragStarted: () => _setSelectedQuestion(snapshot.data[index]),
                                  onDragEnd: (val) => _setSelectedQuestion(null),
                                )
                              : QuestionListItemWithAction(
                                  question: snapshot.data[index],
                                );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}
