import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/round_model.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/services/round_collection_service.dart';
import 'package:qmhb/services/user_collection_service.dart';
import 'package:qmhb/shared/functions/image_capture.dart';
import 'package:qmhb/shared/functions/validation.dart';
import 'package:qmhb/shared/widgets/button_primary.dart';
import 'package:qmhb/shared/widgets/form/form_error.dart';
import 'package:qmhb/shared/widgets/form/form_input.dart';
import 'package:qmhb/shared/widgets/image_switcher.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../get_it.dart';

class RoundEditor extends StatefulWidget {
  final RoundModel roundModel;

  RoundEditor({
    this.roundModel,
  });
  @override
  _RoundEditorState createState() => _RoundEditorState();
}

class _RoundEditorState extends State<RoundEditor> {
  final _formKey = GlobalKey<FormState>();
  RoundModel _round;
  bool _isLoading = false;
  String _error = "";
  File _newImage;

  @override
  void initState() {
    super.initState();
    _round = widget.roundModel;
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
      _editRound();
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
    String filepath = 'images/round/${_round.uid}-${_round.title}.png';
    final FirebaseStorage storage = FirebaseStorage(
      storageBucket: 'gs://qmhb-b432b.appspot.com',
    );
    StorageUploadTask uploadTask = storage.ref().child(filepath).putFile(_newImage);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    return await storageTaskSnapshot.ref.getDownloadURL();
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
    return SingleChildScrollView(
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
                Row(
                  children: [
                    GestureDetector(
                      onTap: _selectImage,
                      child: Container(
                        color: Theme.of(context).primaryColorDark,
                        width: 120,
                        height: 120,
                        child: ImageSwitcher(
                          fileImage: _newImage,
                          networkImage: _round.imageURL,
                          showNoImageText: true,
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(right: 16)),
                    Expanded(
                      child: Column(
                        children: [
                          ButtonPrimary(
                            text: "Select Image",
                            fullWidth: true,
                            onPressed: _selectImage,
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 16)),
                          ButtonPrimary(
                            text: "Remove Image",
                            fullWidth: true,
                            onPressed: _removeImage,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(bottom: 16)),
                ButtonPrimary(
                  text: "Save Round!",
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
    );
  }
}
