import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({
    Key key,
    this.message = "An error occured",
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: double.infinity,
      child: Center(
        child: Text(message),
      ),
    );
  }
}
