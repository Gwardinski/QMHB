import 'package:flutter/material.dart';

class ButtonPrimary extends StatelessWidget {
  final child;
  final onPressed;

  const ButtonPrimary({
    Key key,
    @required this.child,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 120,
      child: RaisedButton(
        color: Color(0xff333333),
        onPressed: onPressed,
        child: child,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          side: BorderSide(width: 1.0, color: Theme.of(context).accentColor),
        ),
      ),
    );
  }
}
