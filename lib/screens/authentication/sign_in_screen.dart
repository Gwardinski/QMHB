import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/models/state_models/user_data_state_model.dart';
import 'package:qmhb/models/user_model.dart';
import 'package:qmhb/services/authentication_service.dart';
import 'package:qmhb/shared/functions/validation.dart';
import 'package:qmhb/shared/widgets/button_primary.dart';
import 'package:qmhb/shared/widgets/form/form_error.dart';
import 'package:qmhb/shared/widgets/form/form_input.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final AuthenticationService _authService = AuthenticationService();
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';
  String _error = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                FormInput(
                  validate: validateEmail,
                  labelText: "Email",
                  disabled: _isLoading,
                  onChanged: (String val) {
                    setState(() {
                      _email = val;
                    });
                  },
                ),
                FormInput(
                  validate: validateEmail,
                  labelText: "Password",
                  obscureText: true,
                  disabled: _isLoading,
                  onChanged: (String val) {
                    setState(() {
                      _password = val;
                    });
                  },
                ),
                ButtonPrimary(
                  child: _isLoading ? LoadingSpinnerHourGlass() : Text("Submit"),
                  onPressed: _onSubmit,
                ),
                FormError(error: _error),
              ],
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
      UserModel userModel = await _authService.signInWithEmailAndPassword(
        email: _email.trim(),
        password: _password.trim(),
      );
      if (userModel != null) {
        final userDataStateModel = Provider.of<UserDataStateModel>(context);
        userDataStateModel.updateCurrentUser(userModel);
      } else {
        _updateError('Failed to log in');
        _updateIsLoading(false);
      }
    }
  }
}
