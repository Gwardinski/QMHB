import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/question_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/services/question_service.dart';
import 'package:qmhb/services/round_service.dart';
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
      widget.type == QuestionEditorType.ADD
          ? _createQuestion()
          : _editQuestion();
    }
  }

  _createQuestion() async {
    _updateIsLoading(true);
    _updateError('');
    final questionService = Provider.of<QuestionService>(context);
    try {
      if (_newImage != null) {
        final newImageUrl = await _saveImage();
        _question.imageURL = newImageUrl;
      }
      await questionService.createQuestion(_question);
      if (widget.roundModel != null) {
        final roundService = Provider.of<RoundService>(context);
        await roundService.addQuestionToRound(widget.roundModel, _question);
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
    _updateIsLoading(true);
    _updateError('');
    final questionService = Provider.of<QuestionService>(context);
    try {
      if (_newImage != null) {
        final newImageUrl = await _saveImage();
        _question.imageURL = newImageUrl;
      }
      await questionService.editQuestion(_question);
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

  _saveImage() async {
    return '';
    // String filepath =
    //     'images/question/${_question.uid}-${_question.answer}.png';
    // final FirebaseStorage storage = FirebaseStorage(
    //   storageBucket: 'gs://qmhb-b432b.appspot.com',
    // );
    // StorageUploadTask uploadTask =
    //     storage.ref().child(filepath).putFile(_newImage);
    // StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    // return await storageTaskSnapshot.ref.getDownloadURL();
  }

  _setAsImagePrompt(String type) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Question Type'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Changing Question type will remove any picture or music you have selected.'),
                Text('Are you sure you wish to change question type?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Change Type'),
              onPressed: () {
                _setTypeAs(type);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _setTypeAs(String type) {
    setState(() {
      _question.questionType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.type == QuestionEditorType.ADD
              ? "Create Question"
              : "Edit Question",
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
                  widget.type == QuestionEditorType.ADD
                      ? Column(
                          children: [
                            Text("Question Type"),
                            Padding(padding: EdgeInsets.only(bottom: 8)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                OutlinedButton(
                                  onPressed: () {
                                    _question.questionType != "STANDARD"
                                        ? _setAsImagePrompt("STANDARD")
                                        : _setTypeAs("STANDARD");
                                  },
                                  child: Text("Standard"),
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    _question.questionType == "MUSIC"
                                        ? _setAsImagePrompt("PICTURE")
                                        : _setTypeAs("PICTURE");
                                  },
                                  child: Text("Picture"),
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    _question.questionType == "PICTURE"
                                        ? _setAsImagePrompt("MUSIC")
                                        : _setTypeAs("MUSIC");
                                  },
                                  child: Text("Music"),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Container(),
                  Padding(padding: EdgeInsets.only(bottom: 16)),
                  _question.questionType == "PICTURE"
                      ? ImageSelector(
                          fileImage: _newImage,
                          networkImage: _question.imageURL,
                          selectImage: _selectImage,
                          removeImage: _removeImage,
                        )
                      : Container(),
                  _question.questionType == "MUSIC"
                      ? Container(
                          height: 80,
                          padding: EdgeInsets.only(bottom: 16),
                          width: double.infinity,
                          child: Center(
                              child: Text(
                                  "TODO - Spotify Song Selector to go here")),
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
                    text: widget.type == QuestionEditorType.ADD
                        ? "Create"
                        : "Save Changes",
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
