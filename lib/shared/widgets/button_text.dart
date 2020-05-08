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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Color(0xffFFA630),
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    );
  }
}
