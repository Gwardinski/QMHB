import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/pages/details/widgets/details_header_banner_image.dart';
import 'package:qmhb/services/refresh_service.dart';
import 'package:qmhb/services/round_service.dart';
import 'package:qmhb/shared/widgets/question_list_item/question_list_item.dart';

class ReorderQuestionsPage extends StatefulWidget {
  final RoundModel roundModel;

  ReorderQuestionsPage({this.roundModel});

  @override
  _ReorderQuestionsPageState createState() => _ReorderQuestionsPageState();
}

class _ReorderQuestionsPageState extends State<ReorderQuestionsPage> {
  RoundModel _roundModel;
  RoundService _roundService;
  RefreshService _refreshService;
  String _token;

  @override
  void initState() {
    _roundModel = widget.roundModel;
    _roundService = Provider.of<RoundService>(context, listen: false);
    _refreshService = Provider.of<RefreshService>(context, listen: false);
    _token = Provider.of<UserDataStateModel>(context, listen: false).token;
    super.initState();
  }

  Future<void> _onReorder(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final int q = _roundModel.questions.removeAt(oldIndex);
    final QuestionModel question = _roundModel.questionModels.removeAt(oldIndex);
    setState(() {
      _roundModel.questions.insert(newIndex, q);
      _roundModel.questionModels.insert(newIndex, question);
    });
    _roundService.editRound(round: _roundModel, token: _token);
    _refreshService.roundRefresh();
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
                  imageUrl: _roundModel.imageUrl,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          _roundModel.title,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Text(
                        "Drag and drop to re-order the questions within this round.",
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
              children: _roundModel.questionModels
                  .map(
                    (question) => QuestionListItemWithReorder(
                      key: Key(question.id.toString()),
                      questionModel: question,
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