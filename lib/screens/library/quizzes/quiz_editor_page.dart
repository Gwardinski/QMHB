import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/services/quiz_collection_service.dart';
import 'package:qmhb/services/user_collection_service.dart';
import 'package:qmhb/shared/functions/image_capture.dart';
import 'package:qmhb/shared/functions/validation.dart';
import 'package:qmhb/shared/widgets/button_primary.dart';
import 'package:qmhb/shared/widgets/form/form_error.dart';
import 'package:qmhb/shared/widgets/form/form_input.dart';
import 'package:qmhb/shared/widgets/form/image_selector.dart';

import '../../../get_it.dart';

class QuizEditorPage extends StatefulWidget {
  final QuizModel quizModel;

  QuizEditorPage({
    this.quizModel,
  });
  @override
  _QuizEditorState createState() => _QuizEditorState();
}

class _QuizEditorState extends State<QuizEditorPage> {
  final _formKey = GlobalKey<FormState>();
  QuizModel _quiz;
  bool _isLoading = false;
  String _error = "";
  File _newImage;

  @override
  void initState() {
    super.initState();
    _quiz = widget.quizModel;
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
      _editQuiz();
    }
  }

  _selectImage() async {
    final newImage = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ImageCapture(
          fileImage: _newImage,
          networkImage: _quiz.imageURL,
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
      _quiz.imageURL = null;
    });
  }

  _saveImage() async {
    String filepath = 'images/quiz/${_quiz.uid}-${_quiz.title}.png';
    final FirebaseStorage storage = FirebaseStorage(
      storageBucket: 'gs://qmhb-b432b.appspot.com',
    );
    StorageUploadTask uploadTask = storage.ref().child(filepath).putFile(_newImage);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    return await storageTaskSnapshot.ref.getDownloadURL();
  }

  _editQuiz() async {
    if (_formKey.currentState.validate()) {
      _updateIsLoading(true);
      _updateError('');
      final quizService = Provider.of<QuizCollectionService>(context);
      final userService = Provider.of<UserCollectionService>(context);
      final userModel = Provider.of<UserDataStateModel>(context).user;
      try {
        if (_newImage != null) {
          final newImageUrl = await _saveImage();
          _quiz.imageURL = newImageUrl;
        }
        await quizService.editQuizOnFirebaseCollection(
          _quiz,
        );
        await userService.updateUserDataOnFirebase(userModel);
        Navigator.of(context).pop();
      } catch (e) {
        print(e);
        _updateError('Failed to edit Quiz');
      } finally {
        _updateIsLoading(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Edit Quiz",
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
                    initialValue: _quiz.title,
                    validate: validateForm,
                    labelText: "Title",
                    onChanged: (val) {
                      setState(() {
                        _quiz.title = val;
                      });
                    },
                  ),
                  FormInput(
                    initialValue: _quiz.description,
                    validate: validateForm,
                    keyboardType: TextInputType.multiline,
                    labelText: "Description",
                    onChanged: (val) {
                      setState(() {
                        _quiz.description = val;
                      });
                    },
                  ),
                  ImageSelector(
                    fileImage: _newImage,
                    networkImage: _quiz.imageURL,
                    selectImage: _selectImage,
                    removeImage: _removeImage,
                  ),
                  ButtonPrimary(
                    text: "Save Quiz!",
                    isLoading: _isLoading,
                    onPressed: _onSubmit,
                    fullWidth: true,
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
