import 'package:flutter/material.dart';
import 'package:qmhb/models/state_models/app_size.dart';
import 'package:qmhb/shared/widgets/loading_spinner.dart';

import '../../get_it.dart';

class ButtonPrimary extends StatelessWidget {
  final String text;
  final onPressed;
  final isLoading;
  final fullWidth;

  const ButtonPrimary({
    Key key,
    @required this.text,
    @required this.onPressed,
    this.isLoading = false,
    this.fullWidth = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: fullWidth ? double.infinity : 128,
      child: RaisedButton(
        color: Color(0xff333333),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? LoadingSpinnerHourGlass()
            : Text(
                text,
                style: TextStyle(fontSize: 18),
              ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(getIt<AppSize>().borderRadius),
          ),
          side: BorderSide(width: 1.0, color: Theme.of(context).accentColor),
        ),
      ),
    );
  }
}
