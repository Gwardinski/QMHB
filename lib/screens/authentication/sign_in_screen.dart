import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/services/user_service.dart';
import 'package:qmhb/shared/exceptions/exceptions.dart';
import 'package:qmhb/shared/functions/validation.dart';
import 'package:qmhb/shared/widgets/button_primary.dart';
import 'package:qmhb/shared/widgets/form/form_error.dart';
import 'package:qmhb/shared/widgets/form/form_input.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _formKey = GlobalKey<FormState>();

  String _email = 'g1@test.com';
  String _password = 'qqqqq';
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
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      FormInput(
                        validate: validateEmail,
                        labelText: "Email",
                        disabled: _isLoading,
                        initialValue: "g1@test.com",
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
                        initialValue: "qqqqq",
                        onChanged: (String val) {
                          setState(() {
                            _password = val;
                          });
                        },
                      ),
                      ButtonPrimary(
                        text: "Submit",
                        isLoading: _isLoading,
                        fullWidth: true,
                        onPressed: _isLoading ? null : _onSubmit,
                      ),
                      FormError(error: _error),
                    ],
                  ),
                ),
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
      try {
        _updateIsLoading(true);
        final userService = Provider.of<UserService>(context, listen: false);
        await userService.signInWithEmailAndPassword(
          email: _email.trim(),
          password: _password.trim(),
        );
        Navigator.of(context).pop();
      } on BadRequestException {
        _updateError('Invalid Request');
      } on NotFoundException {
        _updateError('Could not find a user with that email and/or password');
      } catch (e) {
        _updateError('An error occured logging you in');
      } finally {
        _updateIsLoading(false);
      }
    }
  }
}
