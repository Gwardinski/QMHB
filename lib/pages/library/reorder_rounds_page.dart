import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/details/widgets/details_header_banner_image.dart';
import 'package:qmhb/services/refresh_service.dart';
import 'package:qmhb/services/quiz_service.dart';
import 'package:qmhb/shared/widgets/round_list_item/round_list_item.dart';

class ReorderRoundsPage extends StatefulWidget {
  final QuizModel quizModel;

  ReorderRoundsPage({this.quizModel});

  @override
  _ReorderRoundsPageState createState() => _ReorderRoundsPageState();
}

class _ReorderRoundsPageState extends State<ReorderRoundsPage> {
  QuizModel _quizModel;
  QuizService _quizService;
  RefreshService _refreshService;
  String _token;

  @override
  void initState() {
    _quizModel = widget.quizModel;
    _quizService = Provider.of<QuizService>(context, listen: false);
    _refreshService = Provider.of<RefreshService>(context, listen: false);
    _token = Provider.of<UserDataStateModel>(context, listen: false).token;
    super.initState();
  }

  Future<void> _onReorder(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final int q = _quizModel.rounds.removeAt(oldIndex);
    final RoundModel round = _quizModel.roundModels.removeAt(oldIndex);
    setState(() {
      _quizModel.rounds.insert(newIndex, q);
      _quizModel.roundModels.insert(newIndex, round);
    });
    _quizService.editQuiz(quiz: _quizModel, token: _token);
    _refreshService.quizRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Re-Order"),
      ),
      body: Column(
        children: [
          Container(
            height: 120,
            width: double.infinity,
            child: Stack(
              children: [
                DetailsHeaderBannerImage(
                  imageUrl: _quizModel.imageUrl,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          _quizModel.title,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Text(
                        "Drag and drop to re-order the rounds within this quiz.",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ReorderableListView(
              children: _quizModel.roundModels
                  .map(
                    (round) => RoundListItemWithReorder(
                      key: Key(round.id.toString()),
                      roundModel: round,
                    ),
                  )
                  .toList(),
              onReorder: _onReorder,
            ),
          ),
        ],
      ),
    );
  }
}
