import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/screens/library/widgets/question_editor.dart';
import 'package:qmhb/services/question_collection_service.dart';
import 'package:qmhb/services/user_collection_service.dart';

enum QuestionEditorType {
  ADD,
  EDIT,
}

class QuestionEditorPage extends StatefulWidget {
  final QuestionEditorType type;
  final QuestionModel questionModel;

  QuestionEditorPage({
    @required this.type,
    this.questionModel,
  });

  @override
  _QuestionEditorPageState createState() => _QuestionEditorPageState();
}

class _QuestionEditorPageState extends State<QuestionEditorPage> {
  bool _isLoading = false;
  String _error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.type == QuestionEditorType.ADD ? "Create Question" : "Edit Question",
        ),
        actions: widget.type == QuestionEditorType.EDIT
            ? [
                FlatButton.icon(
                  icon: Icon(Icons.delete),
                  label: Text('Delete'),
                  onPressed: () {
                    // _asyncConfirmDialog();
                  },
                ),
              ]
            : [],
      ),
      body: QuestionEditor(
        questionModel: widget.questionModel,
        onSubmit: (QuestionModel questionModel) {
          _onSubmit(questionModel);
        },
      ),
    );
  }

  _onSubmit(QuestionModel questionModel) {
    widget.type == QuestionEditorType.ADD
        ? _createQuestion(questionModel)
        : _editQuestion(questionModel);
  }

  _createQuestion(QuestionModel questionModel) async {
    _updateIsLoading(true);
    final questionService = Provider.of<QuestionCollectionService>(context);
    final userService = Provider.of<UserCollectionService>(context);
    final userModel = Provider.of<UserDataStateModel>(context).user;
    try {
      String newDocId = await questionService.addQuestionToFirebaseCollection(
        questionModel,
        userModel.uid,
      );
      userModel.questionIds.add(newDocId);
      await userService.updateUserDataOnFirebase(userModel);
      Navigator.of(context).pop();
    } catch (e) {
      _updateError('Failed to add Question');
    } finally {
      _updateIsLoading(false);
    }
  }

  _editQuestion(QuestionModel questionModel) async {
    _updateIsLoading(true);
    final questionService = Provider.of<QuestionCollectionService>(context);
    final userService = Provider.of<UserCollectionService>(context);
    final userModel = Provider.of<UserDataStateModel>(context).user;
    try {
      await questionService.editQuestionOnFirebaseCollection(
        questionModel,
      );
      await userService.updateUserTimeStamp(userModel.uid);
      Navigator.of(context).pop();
    } catch (e) {
      _updateError('Failed to edit Question');
    } finally {
      _updateIsLoading(false);
    }
  }

  _updateError(String val) {
    setState(() {
      _error = val;
    });
  }

  _updateIsLoading(bool val) {
    setState(() {
      _isLoading = val;
    });
  }
}
