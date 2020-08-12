import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/get_it.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/services/quiz_colection_service.dart';
import 'package:qmhb/services/user_collection_service.dart';
import 'package:qmhb/shared/functions/validation.dart';
import 'package:qmhb/shared/widgets/button_primary.dart';
import 'package:qmhb/shared/widgets/form/form_error.dart';
import 'package:qmhb/shared/widgets/form/form_input.dart';

enum QuizEditorPageType {
  ADD,
  EDIT,
}

class QuizEditorPage extends StatefulWidget {
  final QuizEditorPageType type;
  final String initialRoundId;
  final QuizModel quizModel;

  QuizEditorPage({
    @required this.type,
    this.initialRoundId,
    this.quizModel,
  });
  @override
  _QuizEditorPageState createState() => _QuizEditorPageState();
}

class _QuizEditorPageState extends State<QuizEditorPage> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String _error = '';
  String _title = '';
  String _description = '';
  List<RoundModel> _rounds;
  List<QuestionModel> _questions;

  @override
  void initState() {
    super.initState();
    if (widget.quizModel != null) {
      _title = widget.quizModel.title;
      _description = widget.quizModel.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.type == QuizEditorPageType.ADD ? "Create Quiz" : "Edit Quiz"),
      ),
      body: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.width > 800 ? 64 : 8),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: 800),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(getIt<AppSize>().rSpacingMd),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        FormInput(
                          initialValue: _title,
                          validate: validateForm,
                          labelText: "Title",
                          onChanged: (val) {
                            setState(() {
                              _title = val;
                            });
                          },
                        ),
                        FormInput(
                          initialValue: _description,
                          validate: validateForm,
                          keyboardType: TextInputType.multiline,
                          labelText: "Description",
                          onChanged: (val) {
                            setState(() {
                              _description = val;
                            });
                          },
                        ),
                        Row(
                          children: [
                            Text("Rounds"),
                            ButtonPrimary(text: "Create Round", onPressed: null),
                          ],
                        ),
                        ButtonPrimary(
                          text: "Submit",
                          isLoading: _isLoading,
                          onPressed:
                              widget.type == QuizEditorPageType.ADD ? _createQuiz : _editQuiz,
                        ),
                        FormError(error: _error),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

  _createQuiz() async {
    if (_formKey.currentState.validate()) {
      _updateIsLoading(true);
      final quizService = Provider.of<QuizCollectionService>(context);
      final userService = Provider.of<UserCollectionService>(context);
      final userModel = Provider.of<UserDataStateModel>(context).user;
      List<String> roundIds = List<String>();
      if (widget.initialRoundId != null) {
        roundIds.add(widget.initialRoundId);
      }
      QuizModel quizModel = QuizModel(
        title: _title,
        description: _description,
        roundIds: roundIds,
        isPublished: false,
      );
      try {
        String newDocId = await quizService.addQuizToFirebaseCollection(
          quizModel,
          userModel.uid,
        );
        userModel.quizIds.add(newDocId);
        await userService.updateUserDataOnFirebase(userModel);
        Navigator.of(context).pop();
      } catch (e) {
        _updateError('Failed to add Quiz');
      } finally {
        _updateIsLoading(false);
      }
    }
  }

  _editQuiz() async {
    if (_formKey.currentState.validate()) {
      _updateIsLoading(true);
      final quizService = Provider.of<QuizCollectionService>(context);
      final userService = Provider.of<UserCollectionService>(context);
      final userModel = Provider.of<UserDataStateModel>(context).user;
      QuizModel quizModel = widget.quizModel;
      quizModel.title = _title;
      quizModel.description = _description;
      try {
        await quizService.editQuizOnFirebaseCollection(
          quizModel,
        );
        await userService.updateUserTimeStamp(userModel.uid);
        Navigator.of(context).pop();
      } catch (e) {
        print(e);
        _updateError('Failed to edit Quiz');
      } finally {
        _updateIsLoading(false);
      }
    }
  }
}
