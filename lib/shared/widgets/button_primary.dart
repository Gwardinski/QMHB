import 'package:flutter/material.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';

class ButtonPrimary extends StatelessWidget {
  final String text;
  final onPressed;
  final isLoading;

  const ButtonPrimary({
    Key key,
    @required this.text,
    @required this.onPressed,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 128,
      child: RaisedButton(
        color: Color(0xff333333),
        onPressed: isLoading ? null : onPressed,
        child: isLoading ? LoadingSpinnerHourGlass() : Text(text),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          side: BorderSide(width: 1.0, color: Theme.of(context).accentColor),
        ),
      ),
    );
  }
}
