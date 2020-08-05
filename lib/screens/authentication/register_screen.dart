import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/models/user_model.dart';
import 'package:qmhb/services/authentication_service.dart';
import 'package:qmhb/shared/functions/validation.dart';
import 'package:qmhb/shared/widgets/button_primary.dart';
import 'package:qmhb/shared/widgets/form/form_error.dart';
import 'package:qmhb/shared/widgets/form/form_input.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final AuthenticationService _authService = AuthenticationService();
  final _formKey = GlobalKey<FormState>();
  String _displayName;
  String _email;
  String _password;
  String _error = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 600),
            padding: EdgeInsets.fromLTRB(16.0, 4, 16.0, 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  FormInput(
                    validate: validateForm,
                    labelText: "Display Name",
                    onChanged: (String val) {
                      setState(() {
                        _displayName = val;
                      });
                    },
                  ),
                  FormInput(
                    validate: validateEmail,
                    labelText: "Email",
                    onChanged: (String val) {
                      setState(() {
                        _email = val;
                      });
                    },
                  ),
                  FormInput(
                    validate: validatePassword,
                    labelText: "Password",
                    obscureText: true,
                    onChanged: (String val) {
                      setState(() {
                        _password = val;
                      });
                    },
                  ),
                  ButtonPrimary(
                    isLoading: _isLoading,
                    text: "Submit",
                    onPressed: _isLoading ? null : _onSubmit,
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
      _updateIsLoading(true);
      UserModel userModel = await _authService.registerWithEmailAndPassword(
        email: _email.trim(),
        password: _password.trim(),
        displayName: _displayName.trim(),
      );
      if (userModel != null) {
        final userDataStateModel = Provider.of<UserDataStateModel>(context);
        userDataStateModel.updateCurrentUser(userModel);
        Navigator.of(context).pop();
      } else {
        _updateError('Failed to register');
      }
      _updateIsLoading(false);
    }
  }
}
