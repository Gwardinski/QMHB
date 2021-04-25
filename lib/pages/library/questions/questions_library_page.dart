import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/library/questions/editor/question_editor_page.dart';
import 'package:qmhb/pages/library/rounds/rounds_library_sidebar.dart';
import 'package:qmhb/services/navigation_service.dart';
import 'package:qmhb/services/question_service.dart';
import 'package:qmhb/services/refresh_service.dart';
import 'package:qmhb/shared/widgets/app_bar_button.dart';
import 'package:qmhb/shared/widgets/error_message.dart';
import 'package:qmhb/shared/widgets/page_wrapper.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item.dart';
import 'package:qmhb/shared/widgets/toolbar.dart';

import '../../../get_it.dart';

class QuestionsLibraryPage extends StatefulWidget {
  @override
  _QuestionsLibraryPageState createState() => _QuestionsLibraryPageState();
}

class _QuestionsLibraryPageState extends State<QuestionsLibraryPage> {
  final canDrag = getIt<AppSize>().isLarge;
  QuestionModel _selectedQuestion;

  void _setSelectedQuestion(QuestionModel question) => setState(() => _selectedQuestion = question);

  void _createQuestion() async {
    final questionService = Provider.of<QuestionService>(context, listen: false);
    final refreshService = Provider.of<RefreshService>(context, listen: false);
    final token = Provider.of<UserDataStateModel>(context, listen: false).token;
    Provider.of<NavigationService>(context, listen: false).push(
      QuestionEditorPage(
        questionService: questionService,
        refreshService: refreshService,
        token: token,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.of(context).size.width > 800.0;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        title: Text("Your Questions"),
        actions: [
          isLandscape
              ? Container()
              : AppBarButton(
                  title: "New",
                  leftIcon: Icons.add,
                  onTap: _createQuestion,
                ),
        ],
      ),
      body: PageWrapper(
        child: Row(
          children: [
            isLandscape ? RoundsLibrarySidebar(selectedQuestion: _selectedQuestion) : Container(),
            Expanded(
              child: StreamBuilder<bool>(
                stream: Provider.of<RefreshService>(context, listen: false).roundListener,
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
                        children: [
                          Toolbar(
                            onUpdateSearchString: (s) => print(s),
                            onUpdateFilter: () {},
                            onUpdateSort: () {},
                            results: snapshot.data?.length?.toString() ?? 'loading',
                          ),
                          Expanded(
                            child: isLandscape
                                ? ListView.builder(
                                    itemCount: (snapshot.data?.length ?? 0) + 1,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (BuildContext context, int index) {
                                      if (index == 0) {
                                        return NewQuestionListItem();
                                      }
                                      return DraggableQuestionListItem(
                                        question: snapshot.data[index - 1],
                                        onDragStarted: () => _setSelectedQuestion(
                                          snapshot.data[index - 1],
                                        ),
                                        onDragEnd: (val) => _setSelectedQuestion(null),
                                      );
                                    },
                                  )
                                : ListView.builder(
                                    itemCount: snapshot.data?.length ?? 0,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (BuildContext context, int index) {
                                      return QuestionListItemWithAction(
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
            ),
          ],
        ),
      ),
    );
  }
}

class NewQuestionListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final questionService = Provider.of<QuestionService>(context);
    final refreshService = Provider.of<RefreshService>(context);
    final token = Provider.of<UserDataStateModel>(context).token;
    return InkWell(
      onTap: () {
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return QuestionEditorPage(
              questionService: questionService,
              refreshService: refreshService,
              token: token,
            );
          },
        );
      },
      child: Container(
        height: 64,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Icon(Icons.add, size: 32),
            ),
            Text(
              "Create New Question",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
