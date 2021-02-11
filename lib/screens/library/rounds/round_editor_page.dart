import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/quiz_model.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/services/quiz_collection_service.dart';
import 'package:qmhb/services/round_collection_service.dart';
import 'package:qmhb/services/user_collection_service.dart';
import 'package:qmhb/shared/functions/image_capture.dart';
import 'package:qmhb/shared/functions/validation.dart';
import 'package:qmhb/shared/widgets/button_primary.dart';
import 'package:qmhb/shared/widgets/form/form_error.dart';
import 'package:qmhb/shared/widgets/form/form_input.dart';
import 'package:qmhb/shared/widgets/form/image_selector.dart';

import '../../../get_it.dart';

enum RoundEditorType {
  ADD,
  EDIT,
}

class RoundEditorPage extends StatefulWidget {
  final RoundEditorType type;
  final RoundModel roundModel;
  final QuizModel quizModel;

  RoundEditorPage({
    @required this.type,
    this.roundModel,
    this.quizModel,
  });
  @override
  _RoundEditorPageState createState() => _RoundEditorPageState();
}

class _RoundEditorPageState extends State<RoundEditorPage> {
  final _formKey = GlobalKey<FormState>();
  RoundModel _round;
  bool _isLoading = false;
  String _error = "";
  File _newImage;

  @override
  void initState() {
    super.initState();
    if (widget.roundModel != null) {
      _round = widget.roundModel;
    } else {
      _round = RoundModel.newRound();
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
      widget.type == RoundEditorType.ADD ? _createRound() : _editRound();
    }
  }

  _selectImage() async {
    final newImage = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ImageCapture(
          fileImage: _newImage,
          networkImage: _round.imageURL,
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
      _round.imageURL = null;
    });
  }

  _saveImage() async {
    return '';
    // String filepath = 'images/round/${_round.uid}-${_round.title}.png';
    // final FirebaseStorage storage = FirebaseStorage(
    //   storageBucket: 'gs://qmhb-b432b.appspot.com',
    // );
    // StorageUploadTask uploadTask = storage.ref().child(filepath).putFile(_newImage);
    // StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    // return await storageTaskSnapshot.ref.getDownloadURL();
  }

  _createRound() async {
    if (_formKey.currentState.validate()) {
      _updateIsLoading(true);
      _updateError('');
      final roundService = Provider.of<RoundCollectionService>(context);
      final userService = Provider.of<UserCollectionService>(context);
      final userModel = Provider.of<UserDataStateModel>(context).user;
      try {
        if (_newImage != null) {
          final newImageUrl = await _saveImage();
          _round.imageURL = newImageUrl;
        }
        String newDocId = await roundService.addRoundToFirebaseCollection(
          _round,
          userModel.uid,
        );
        userModel.roundIds.add(newDocId);
        await userService.updateUserDataOnFirebase(userModel);
        if (widget.quizModel != null) {
          final quizService = Provider.of<QuizCollectionService>(context);
          final newQuiz = widget.quizModel;
          newQuiz.roundIds.add(newDocId);
          await quizService.editQuizOnFirebaseCollection(newQuiz);
        }
        Navigator.of(context).pop();
      } catch (e) {
        print(e.toString());
        _updateError('Failed to create Question');
      } finally {
        _updateIsLoading(false);
      }
    }
  }

  _editRound() async {
    if (_formKey.currentState.validate()) {
      _updateIsLoading(true);
      _updateError('');
      final roundService = Provider.of<RoundCollectionService>(context);
      final userService = Provider.of<UserCollectionService>(context);
      final userModel = Provider.of<UserDataStateModel>(context).user;
      try {
        if (_newImage != null) {
          final newImageUrl = await _saveImage();
          _round.imageURL = newImageUrl;
        }
        await roundService.editRoundOnFirebaseCollection(
          _round,
        );
        await userService.updateUserDataOnFirebase(userModel);
        Navigator.of(context).pop();
      } catch (e) {
        print(e);
        _updateError('Failed to edit Round');
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
          widget.type == RoundEditorType.ADD ? "Create Round" : "Edit Round",
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
                    initialValue: _round.title,
                    validate: validateForm,
                    labelText: "Title",
                    onChanged: (val) {
                      setState(() {
                        _round.title = val;
                      });
                    },
                  ),
                  FormInput(
                    initialValue: _round.description,
                    validate: validateForm,
                    keyboardType: TextInputType.multiline,
                    labelText: "Description",
                    onChanged: (val) {
                      setState(() {
                        _round.description = val;
                      });
                    },
                  ),
                  ImageSelector(
                    fileImage: _newImage,
                    networkImage: _round.imageURL,
                    selectImage: _selectImage,
                    removeImage: _removeImage,
                  ),
                  ButtonPrimary(
                    text: widget.type == RoundEditorType.ADD
                        ? "Create"
                        : "Save Changes",
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
