import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/services/user_service.dart';
import 'package:qmhb/shared/exceptions/exceptions.dart';
import 'package:qmhb/shared/functions/validation.dart';
import 'package:qmhb/shared/widgets/button_primary.dart';
import 'package:qmhb/shared/widgets/form/form_error.dart';
import 'package:qmhb/shared/widgets/form/form_input.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

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
                    fullWidth: true,
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
      try {
        final userService = Provider.of<UserService>(context);
        await userService.registerWithEmailAndPassword(
          email: _email.trim(),
          password: _password.trim(),
          displayName: _displayName.trim(),
        );
        Navigator.of(context).pop();
      } on BadRequestException {
        _updateError('Invalid Request');
      } on ConflictException {
        _updateError('This email is already in use');
      } catch (e) {
        _updateError('Failed to register');
      } finally {
        _updateIsLoading(false);
      }
    }
  }
}
