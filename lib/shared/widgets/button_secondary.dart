import 'package:flutter/material.dart';

class ButtonSecondary extends StatelessWidget {
  final String title;
  final Function onTap;

  ButtonSecondary({
    @required this.title,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      child: MaterialButton(
        onPressed: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
    );
  }
}
