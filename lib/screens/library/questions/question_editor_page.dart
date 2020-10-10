import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/services/question_collection_service.dart';
import 'package:qmhb/services/round_collection_service.dart';
import 'package:qmhb/services/user_collection_service.dart';
import 'package:qmhb/shared/functions/image_capture.dart';
import 'package:qmhb/shared/functions/validation.dart';
import 'package:qmhb/shared/widgets/button_primary.dart';
import 'package:qmhb/shared/widgets/form/category_selector.dart';
import 'package:qmhb/shared/widgets/form/form_error.dart';
import 'package:qmhb/shared/widgets/form/form_input.dart';
import 'package:qmhb/shared/widgets/form/image_selector.dart';

import '../../../get_it.dart';

enum QuestionEditorType {
  ADD,
  EDIT,
}

class QuestionEditorPage extends StatefulWidget {
  final QuestionEditorType type;
  final QuestionModel questionModel;
  final RoundModel roundModel;

  QuestionEditorPage({
    @required this.type,
    this.questionModel,
    this.roundModel,
  });
  @override
  _QuestionEditorState createState() => _QuestionEditorState();
}

class _QuestionEditorState extends State<QuestionEditorPage> {
  final _formKey = GlobalKey<FormState>();
  QuestionModel _question;
  bool _isLoading = false;
  String _error = "";
  File _newImage;

  @override
  void initState() {
    super.initState();
    if (widget.questionModel != null) {
      _question = widget.questionModel;
    } else {
      _question = QuestionModel.newQuestion();
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

  _onSubmit() async {
    if (_formKey.currentState.validate()) {
      widget.type == QuestionEditorType.ADD ? _createQuestion() : _editQuestion();
    }
  }

  _createQuestion() async {
    final questionService = Provider.of<QuestionCollectionService>(context);
    final userService = Provider.of<UserCollectionService>(context);
    final userModel = Provider.of<UserDataStateModel>(context).user;
    try {
      _updateIsLoading(true);
      _updateError('');
      String newDocId = await questionService.addQuestionToFirebaseCollection(
        _question,
        userModel.uid,
      );
      userModel.questionIds.add(newDocId);
      await userService.updateUserDataOnFirebase(userModel);
      if (widget.roundModel != null) {
        final roundService = Provider.of<RoundCollectionService>(context);
        final newRound = widget.roundModel;
        newRound.questionIds.add(newDocId);
        await roundService.editRoundOnFirebaseCollection(newRound);
      }
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
      _updateError('Failed to edit Question');
    } finally {
      _updateIsLoading(false);
    }
  }

  _editQuestion() async {
    final questionService = Provider.of<QuestionCollectionService>(context);
    final userService = Provider.of<UserCollectionService>(context);
    final userModel = Provider.of<UserDataStateModel>(context).user;
    try {
      _updateIsLoading(true);
      _updateError('');
      await questionService.editQuestionOnFirebaseCollection(
        _question,
      );
      await userService.updateUserDataOnFirebase(userModel);
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
      _updateError('Failed to edit Question');
    } finally {
      _updateIsLoading(false);
    }
  }

  _selectImage() async {
    final newImage = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ImageCapture(
          fileImage: _newImage,
          networkImage: _question.imageURL,
        ),
      ),
    );
    setState(() {
      _newImage = newImage;
    });
  }

  _removeImage() {
    setState(() {
      _newImage = null;
      _question.imageURL = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.type == QuestionEditorType.ADD ? "Create Question" : "Edit Question",
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 600),
            padding: EdgeInsets.fromLTRB(
              16,
              getIt<AppSize>().isLarge ? 128 : 16,
              16,
              16,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  widget.type == QuestionEditorType.ADD
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Question Type"),
                            OutlineButton(
                              onPressed: () {
                                setState(() {
                                  _question.questionType = "STANDARD";
                                });
                              },
                              child: Text("Standard"),
                            ),
                            OutlineButton(
                              onPressed: () {
                                setState(() {
                                  _question.questionType = "PICTURE";
                                });
                              },
                              child: Text("Picture"),
                            ),
                          ],
                        )
                      : Container(),
                  Padding(padding: EdgeInsets.only(bottom: 16)),
                  FormInput(
                    initialValue: _question.question,
                    validate: validateForm,
                    labelText: "Question",
                    keyboardType: TextInputType.multiline,
                    onChanged: (val) {
                      setState(() {
                        _question.question = val;
                      });
                    },
                  ),
                  FormInput(
                    initialValue: _question.answer,
                    validate: validateForm,
                    labelText: "Answer",
                    keyboardType: TextInputType.multiline,
                    onChanged: (val) {
                      setState(() {
                        _question.answer = val;
                      });
                    },
                  ),
                  _question.questionType == "PICTURE"
                      ? ImageSelector(
                          fileImage: _newImage,
                          networkImage: _question.imageURL,
                          selectImage: _selectImage,
                          removeImage: _removeImage,
                        )
                      : Container(),
                  FormInput(
                    initialValue: _question.points.toString(),
                    validate: validateNumber,
                    keyboardType: TextInputType.number,
                    labelText: "Points",
                    onChanged: (val) {
                      setState(() {
                        _question.points = double.parse(val);
                      });
                    },
                  ),
                  CategorySelector(
                    initialValue: _question.category,
                    onSelect: (val) {
                      setState(() {
                        _question.category = val;
                      });
                    },
                  ),
                  ButtonPrimary(
                    text: widget.type == QuestionEditorType.ADD ? "Create" : "Save Changes",
                    isLoading: _isLoading,
                    fullWidth: true,
                    onPressed: _onSubmit,
                  ),
                  FormError(error: _error),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
