import 'package:flutter/material.dart';

class ButtonText extends StatelessWidget {
  final String text;
  final Function onTap;

  const ButtonText({
    Key key,
    @required this.text,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onTap,
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).accentColor,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
