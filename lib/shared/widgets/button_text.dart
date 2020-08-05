import 'package:flutter/material.dart';
import 'package:qmhb/get_it.dart';
import 'package:qmhb/models/state_models/app_size.dart';

enum ButtonTextType { PRIMARY, SECONDARY }

class ButtonText extends StatelessWidget {
  final String text;
  final Function onTap;
  final ButtonTextType type;

  const ButtonText({
    Key key,
    @required this.text,
    @required this.onTap,
    @required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: getIt<AppSize>().spacingXl,
        padding: EdgeInsets.symmetric(horizontal: getIt<AppSize>().rSpacingMd),
        child: Center(
          child: Text(
            text,
            style: type == ButtonTextType.PRIMARY
                ? TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )
                : TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).accentColor,
                    decoration: TextDecoration.underline,
                  ),
          ),
        ),
      ),
    );
  }
}
