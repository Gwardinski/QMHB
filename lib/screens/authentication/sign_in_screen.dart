import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qmhb/services/authentication_service.dart';
import 'package:qmhb/shared/functions/validation.dart';
import 'package:qmhb/shared/widgets/button_primary.dart';
import 'package:qmhb/shared/widgets/form/form_error.dart';
import 'package:qmhb/shared/widgets/form/form_input.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _formKey = GlobalKey<FormState>();

  AuthenticationService _authService;
  String _email = '';
  String _password = '';
  String _error = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authService = Provider.of<AuthenticationService>(context, listen: false);
  }

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
                        text: "Submit",
                        isLoading: _isLoading,
                        fullWidth: true,
                        onPressed: _isLoading ? null : _onSubmit,
                      ),
                      FormError(error: _error),
                      ButtonPrimary(
                        text: "Google",
                        isLoading: false,
                        onPressed: _isLoading ? null : _googleSignIn,
                      ),
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

  _googleSignIn() async {
    try {
      _updateIsLoading(true);
      await _authService.googleSignIn();
      Navigator.of(context).pop();
    } catch (e) {
      _updateError('Failed to log in');
    } finally {
      _updateIsLoading(false);
    }
  }

  _onSubmit() async {
    if (_formKey.currentState.validate()) {
      try {
        _updateIsLoading(true);
        await _authService.signInWithEmailAndPassword(
          email: _email.trim(),
          password: _password.trim(),
        );
        Navigator.of(context).pop();
      } catch (e) {
        _updateError('Failed to log in');
        print(e.toString());
      } finally {
        _updateIsLoading(false);
      }
    }
  }
}
