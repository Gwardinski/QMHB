import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/library/quizzes/quiz_editor_page.dart';
import 'package:qmhb/services/quiz_service.dart';
import 'package:qmhb/services/refresh_service.dart';
import 'package:qmhb/shared/widgets/quiz_list_item/quiz_list_item.dart';
import 'package:qmhb/shared/widgets/toolbar.dart';

import '../../../get_it.dart';

class QuizzesLibraryPage extends StatefulWidget {
  @override
  _QuizzesLibraryPageState createState() => _QuizzesLibraryPageState();
}

class _QuizzesLibraryPageState extends State<QuizzesLibraryPage> {
  final canDrag = getIt<AppSize>().isLarge;
  QuizService _quizService;
  RefreshService _refreshService;
  List<QuizModel> _quizzes = [];
  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _quizService = Provider.of<QuizService>(context, listen: false);
    _refreshService = Provider.of<RefreshService>(context, listen: false);
    _subscription?.cancel();
    _subscription = _refreshService.quizListener.listen((event) {
      _getQuizzes();
    });
    _refreshService.quizRefresh();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }

  _getQuizzes() async {
    final token = Provider.of<UserDataStateModel>(context, listen: false).token;
    final quizs = await _quizService.getUserQuizzes(token: token);
    setState(() {
      _quizzes = [];
      _quizzes = quizs;
    });
  }

  void _createRound() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QuizEditorPage(
          type: QuizEditorType.ADD,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Your Quizzes"),
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.add),
            label: Text('New'),
            onPressed: _createRound,
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Toolbar(
                  onUpdateSearchString: (s) => print(s),
                  noOfResults: _quizzes.length,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _quizzes.length ?? 0,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return QuizListItem(
                        quizModel: _quizzes[index],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
